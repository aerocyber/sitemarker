import 'package:drift/drift.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/db/dbio/shared_db.dart' as impl;
import 'package:sitemarker/core/db/sm_db.steps.dart';

import 'package:sitemarker/core/db/tables/folders.dart';
import 'package:sitemarker/core/db/tables/record_tags.dart';
import 'package:sitemarker/core/db/tables/sitemarker_records.dart';
import 'package:sitemarker/core/db/tables/tag_mappings.dart';

import 'package:sitemarker/core/db/daos/folder_dao.dart';
import 'package:sitemarker/core/db/daos/records_dao.dart';

part 'sm_db.g.dart';

// TODO: Optimize data fetching from tables.

/// DB
@DriftDatabase(
  tables: [SitemarkerRecords, RecordTags, TagMappings, FolderRecords],
  daos: [FolderDao, RecordsDao],
  include: {'tables/search.drift'},
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
      onCreate: (Migrator m) async {
        await m.createAll();

        await customStatement(
          "INSERT INTO sitemarker_records_fts(sitemarker_records_fts) VALUES('rebuild');",
        );
      },
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
        // from3To4: (m, schema) async {
        //   // 1. Ceate the brand new tables!
        //   await m.createTable(schema.folders);
        //   await m.createTable(schema.recordTags);
        //   await m.createTable(schema.tagMappings);

        //   // 2. Insert the Default root folder aka / (id 1)
        //   await into(schema.folders).insert(
        //     RawValuesInsertable({
        //       'id': const Variable<int>(1),
        //       'name': const Variable<String>('home'),
        //     }),
        //     mode: InsertMode.insertOrIgnore,
        //   );

        //   // 3. Extract Tags BEFORE we alter the main table
        //   // (If v4 removed the 'tags' column, alterTable will delete it, so we read it now)
        //   final rawRowsOfTags = await customSelect(
        //     'SELECT id, tags FROM sitemarker_records',
        //   ).get();

        //   // 4. Safely migrate the main table
        //   // We tell Drift explicitly which columns are new so it doesn't
        //   // try to look for them in the old v3 database.
        //   await m.addColumn(
        //     sitemarkerRecords,
        //     schema.sitemarkerRecords.lastSynced,
        //   );
        //   await m.addColumn(sitemarkerRecords, schema.sitemarkerRecords.notes);
        //   await m.addColumn(
        //     sitemarkerRecords,
        //     schema.sitemarkerRecords.folderId,
        //   );

        //   // 5. Process and insert the tags into the new mapping tables
        //   Map<String, int> tagCache = {};
        //   for (final row in rawRowsOfTags) {
        //     final recordId = row.read<int>('id');

        //     // Safety check: ensure tags column actually existed in the result
        //     if (!row.data.containsKey('tags')) continue;

        //     final tagsString = row.read<String?>('tags');

        //     if (tagsString != null && tagsString.isNotEmpty) {
        //       final tagsList = tagsString
        //           .split(',')
        //           .map((t) => t.trim())
        //           .where((t) => t.isNotEmpty);

        //       for (final tag in tagsList) {
        //         int? tagId = tagCache[tag];

        //         if (tagId == null) {
        //           final existingTag = await customSelect(
        //             'SELECT id FROM record_tags WHERE name = ?',
        //             variables: [Variable<String>(tag)],
        //           ).getSingleOrNull();

        //           if (existingTag != null) {
        //             tagId = existingTag.read<int>('id');
        //           } else {
        //             tagId = await into(schema.recordTags).insert(
        //               RawValuesInsertable({'name': Variable<String>(tag)}),
        //             );
        //           }
        //           tagCache[tag] = tagId;
        //         }

        //         await into(schema.tagMappings).insert(
        //           RawValuesInsertable({
        //             'bookmark_id': Variable<int>(recordId),
        //             'tag_id': Variable<int>(tagId),
        //           }),
        //           mode: InsertMode.insertOrIgnore,
        //         );
        //       }
        //     }
        //   }
        //   await customStatement(
        //     "INSERT INTO sitemarker_records_fts(sitemarker_records_fts) VALUES('rebuild');",
        //   );
        // },

        from3To4: (m, schema) async {
          // 1. Create the brand new tables
          await m.createTable(schema.folders);
          await m.createTable(schema.recordTags);
          await m.createTable(schema.tagMappings);

          // 2. Insert the Default root folder (id 1)
          await into(schema.folders).insert(
            RawValuesInsertable({
              'id': const Variable<int>(1),
              'name': const Variable<String>('home'),
            }),
            mode: InsertMode.insertOrIgnore,
          );

          // Phase 3A: Parse CSV strings and insert unique tags
          await customStatement('''
            WITH RECURSIVE split(bookmark_id, tag, rest) AS (
              SELECT id, '', tags || ',' 
              FROM sitemarker_records 
              WHERE tags IS NOT NULL AND tags != ''
              
              UNION ALL
              
              SELECT bookmark_id,
                     trim(substr(rest, 1, instr(rest, ',') - 1)),
                     substr(rest, instr(rest, ',') + 1)
              FROM split
              WHERE rest != ''
            )

            INSERT OR IGNORE INTO record_tags (name)
            SELECT DISTINCT tag FROM split WHERE tag != '';
          ''');

          // Phase 3B: Re-run the split to map the bookmark IDs to the newly created Tag IDs
          await customStatement('''
            WITH RECURSIVE split(bookmark_id, tag, rest) AS (
              SELECT id, '', tags || ',' 
              FROM sitemarker_records 
              WHERE tags IS NOT NULL AND tags != ''
              
              UNION ALL
              
              SELECT bookmark_id,
                     trim(substr(rest, 1, instr(rest, ',') - 1)),
                     substr(rest, instr(rest, ',') + 1)
              FROM split
              WHERE rest != ''
            )

            INSERT OR IGNORE INTO tag_mappings (bookmark_id, tag_id)
            SELECT s.bookmark_id, t.id 
            FROM split s 
            JOIN record_tags t ON s.tag = t.name 
            WHERE s.tag != '';
          ''');

          // 4. Safely add the new columns to the main table
          await m.addColumn(
            schema.sitemarkerRecords,
            schema.sitemarkerRecords.lastSynced,
          );
          await m.addColumn(
            schema.sitemarkerRecords,
            schema.sitemarkerRecords.notes,
          );
          await m.addColumn(
            schema.sitemarkerRecords,
            schema.sitemarkerRecords.folderId,
          );

          // 5. Rebuild the search index
          await customStatement(
            "INSERT INTO sitemarker_records_fts(sitemarker_records_fts) VALUES('rebuild');",
          );
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

          await customStatement('PRAGMA foreign_keys = ON');
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

  /// Get all folders
  Future<List<FolderRecord>> get allFolders => select(folderRecords).get();
}
