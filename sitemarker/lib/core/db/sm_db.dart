import 'package:drift/drift.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/db/dbio/shared_db.dart' as impl;
import 'package:sitemarker/core/db/sm_db.steps.dart';

import 'package:sitemarker/core/db/tables/folders.dart';
import 'package:sitemarker/core/db/tables/record_tags.dart';
import 'package:sitemarker/core/db/tables/sitemarker_records.dart';
import 'package:sitemarker/core/db/tables/tag_mappings.dart';

import 'package:sitemarker/core/db/daos/folder_dao.dart';

part 'sm_db.g.dart';

/// DB
@DriftDatabase(
  tables: [SitemarkerRecords, RecordTags, TagMappings, FolderRecords],
  daos: [FolderDao],
)
class SitemarkerDB extends _$SitemarkerDB {
  // SitemarkerDB() : super(impl.connect());
  SitemarkerDB([QueryExecutor? e]) : super(e ?? impl.connect());

  /// The DB Schema version
  @override
  int get schemaVersion => 4;

  /// Migration code
  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: stepByStep(
        from1To2: (m, schema) async {
          await m.addColumn(
            schema.sitemarkerRecords,
            schema.sitemarkerRecords.dateAdded,
          );
        },
        from2To3: (m, schema) async {
          await m.addColumn(
            schema.sitemarkerRecords,
            schema.sitemarkerRecords.dateModified,
          );
        },
        from3To4: (m, schema) async {
          // 1. Ceate the brand new tables!
          await m.createTable(schema.folders);
          await m.createTable(schema.recordTags);
          await m.createTable(schema.tagMappings);

          // 2. Insert the Default root folder aka / (id 1)
          await into(schema.folders).insert(
            RawValuesInsertable({
              'id': const Variable<int>(1),
              'name': const Variable<String>('home'),
            }),
            mode: InsertMode.insertOrIgnore,
          );

          // 3. Extract Tags BEFORE we alter the main table
          // (If v4 removed the 'tags' column, alterTable will delete it, so we read it now)
          final rawRowsOfTags = await customSelect(
            'SELECT id, tags FROM sitemarker_records',
          ).get();

          // 4. Safely migrate the main table
          // We tell Drift explicitly which columns are new so it doesn't
          // try to look for them in the old v3 database.
          await m.addColumn(
            sitemarkerRecords,
            schema.sitemarkerRecords.lastSynced,
          );
          await m.addColumn(sitemarkerRecords, schema.sitemarkerRecords.notes);
          await m.addColumn(
            sitemarkerRecords,
            schema.sitemarkerRecords.folderId,
          );

          // 5. Process and insert the tags into the new mapping tables
          Map<String, int> tagCache = {};
          for (final row in rawRowsOfTags) {
            final recordId = row.read<int>('id');

            // Safety check: ensure tags column actually existed in the result
            if (!row.data.containsKey('tags')) continue;

            final tagsString = row.read<String?>('tags');

            if (tagsString != null && tagsString.isNotEmpty) {
              final tagsList = tagsString
                  .split(',')
                  .map((t) => t.trim())
                  .where((t) => t.isNotEmpty);

              for (final tag in tagsList) {
                int? tagId = tagCache[tag];

                if (tagId == null) {
                  final existingTag = await customSelect(
                    'SELECT id FROM record_tags WHERE name = ?',
                    variables: [Variable<String>(tag)],
                  ).getSingleOrNull();

                  if (existingTag != null) {
                    tagId = existingTag.read<int>('id');
                  } else {
                    tagId = await into(schema.recordTags).insert(
                      RawValuesInsertable({'name': Variable<String>(tag)}),
                    );
                  }
                  tagCache[tag] = tagId;
                }

                await into(schema.tagMappings).insert(
                  RawValuesInsertable({
                    'bookmark_id': Variable<int>(recordId),
                    'tag_id': Variable<int>(tagId),
                  }),
                  mode: InsertMode.insertOrIgnore,
                );
              }
            }
          }
        },
      ),
      beforeOpen: (details) async {
        if (details.hadUpgrade && details.versionBefore! < 2) {
          await update(sitemarkerRecords).write(
            SitemarkerRecordsCompanion(
              dateAdded: Value(
                DateTime(
                  DateTime.now().year,
                  DateTime.now().month,
                  DateTime.now().day,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  // Writer (Helper) for record creation
  Future<void> createRecordsWithTags({required SmRecord record}) {
    return transaction(() async {
      final recordId = await into(sitemarkerRecords).insert(
        SitemarkerRecordsCompanion.insert(
          name: record.name,
          url: record.url,
          folderId: Value(record.folderId),
        ),
      );
      record.id = recordId;

      if (record.tags.isNotEmpty) {
        for (String tag in record.tags) {
          if (tag.trim().isEmpty) {
            // Empty tag
            continue;
          }
          final existingTag = await (select(
            recordTags,
          )..where((t) => t.name.equals(tag))).getSingleOrNull();

          int tagId;
          if (existingTag != null) {
            tagId = existingTag.id;
          } else {
            tagId = await into(
              recordTags,
            ).insert(RecordTagsCompanion.insert(name: tag));
          }

          await into(tagMappings).insert(
            TagMappingsCompanion.insert(bookmarkId: recordId, tagId: tagId),
            mode: InsertMode.insertOrIgnore,
          );
        }
      }
    });
  }

  // SELECTs
  /// Get all records
  Future<List<SitemarkerRecord>> get allRecords =>
      select(sitemarkerRecords).get();

  // Get all records in folder with folder ID known
  Future<List<SitemarkerRecord>> getRecordsByFolderId(int folderId) {
    return (select(
      sitemarkerRecords,
    )..where((t) => t.folderId.equals(folderId))).get();
  }

  
  // Get all tags of a record where the ID of the record is known
  Future<List<RecordTag>> getAllTagsInRecord(int recordId) async {
    final mappings = await (select(
      tagMappings,
    )..where((t) => t.bookmarkId.equals(recordId))).get();
    List<RecordTag> records = [];
    for (final mapping in mappings) {
      records.add(
        await (select(
          recordTags,
        )..where((t) => t.id.equals(mapping.tagId))).getSingle(),
      );
    }

    return records;
  }

  // Get all bookmarks which have got the same tag id
  Future<List<SitemarkerRecord>> getAllRecordsByTagId(int tagId) async {
    final mappings = await (select(
      tagMappings,
    )..where((t) => t.tagId.equals(tagId))).get();

    List<SitemarkerRecord> records = [];
    for (final mapping in mappings) {
      records.add(
        await (select(
          sitemarkerRecords,
        )..where((t) => t.id.equals(mapping.bookmarkId))).getSingle(),
      );
    }

    return records;
  }

  /// Get records matching name
  Future<List<SitemarkerRecord>> getRecordsByName(String name) {
    return (select(sitemarkerRecords)..where((t) => t.name.equals(name))).get();
  }

  /// Get records matching url
  Future<List<SitemarkerRecord>> getRecordsByURL(String url) {
    return (select(sitemarkerRecords)..where((t) => t.url.equals(url))).get();
  }

  Future<List<SitemarkerRecord>> getRecordsByRangeOfDateAdded(
    DateTime dateRangeStart,
    DateTime dateRangeEnd,
  ) {
    return (select(sitemarkerRecords)..where(
          (t) => t.dateAdded.isBetween(
            Constant(dateRangeStart),
            Constant(dateRangeEnd),
          ),
        ))
        .get();
  }

  /// Add a new record
  Future<int> insertRecord(SitemarkerRecord record) =>
      into(sitemarkerRecords).insert(record);

  /// Update a record
  Future<bool> updateRecord(SitemarkerRecord updatedRecord) =>
      update(sitemarkerRecords).replace(updatedRecord);

  /// Permanently delete a record
  Future<int> hardDelete(SitemarkerRecord record) =>
      delete(sitemarkerRecords).delete(record);

  /// Set the isDeleted value to the opposite of current value
  Future<bool> toggleDelete(SitemarkerRecord record) {
    SitemarkerRecord rec = SitemarkerRecord(
      id: record.id,
      name: record.name,
      url: record.url,
      isDeleted: !record.isDeleted,
      dateAdded: record.dateAdded,
      dateModified: record.dateModified,
      folderId: record.folderId,
      lastSynced: record.lastSynced,
      notes: record.notes,
    );

    return update(sitemarkerRecords).replace(rec);
  }

  /// Soft delete a record
  Future<bool> softDelete(SitemarkerRecord record) {
    // SitemarkerRecord rec = SitemarkerRecord(
    //   id: record.id,
    //   name: record.name,
    //   url: record.url,
    //   isDeleted: true,
    //   dateAdded: record.dateAdded,
    //   dateModified: record.dateModified,
    //   folderId: record.folderId,
    //   lastSynced: record.lastSynced,
    //   notes: record.notes,
    // );

    return update(sitemarkerRecords).replace(record.copyWith(isDeleted: true));
  }

  /// Get deleted records
  Future<List<SitemarkerRecord>> getDeletedRecords() {
    return (select(
      sitemarkerRecords,
    )..where((t) => t.isDeleted.equals(true))).get();
  }

  /// Get undeleted records
  Future<List<SitemarkerRecord>> getUndeletedRecords() {
    return (select(
      sitemarkerRecords,
    )..where((t) => t.isDeleted.equals(false))).get();
  }

  /// Get all folders
  Future<List<FolderRecord>> get allFolders => select(folderRecords).get();
}
