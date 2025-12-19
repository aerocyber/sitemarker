import 'package:drift/drift.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/core/db/dbio/shared_db.dart' as impl;
import 'package:sitemarker/core/db/sm_db.steps.dart';
import 'package:sitemarker/core/helpers/dir_view_helper.dart';

part 'sm_db.g.dart';

/// DB
@DriftDatabase(tables: [SitemarkerRecords, RecordTags, TagMappings, Folders])
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
            // Create new tables
            await m.createTable(schema.folders);
            await m.createTable(schema.recordTags);
            await m.createTable(schema.tagMappings);

            // Default folder (id 1: root)
            into(schema.folders).insert(
              RawValuesInsertable({
                'id': Variable<int>(1),
                'name': Variable<String>('Root'),
              }),
              mode: InsertMode.insertOrIgnore,
            );

            await m.renameTable(
                schema.sitemarkerRecords, 'sitemarker_records_old');
            await m.createTable(schema.sitemarkerRecords);

            await customStatement('''
              INSERT INTO sitemarker_records (
                id, name, url, is_deleted, date_added, date_modified, 
                folder_id, last_synced, notes
              )
              SELECT 
                id, name, url, is_deleted, date_added, date_modified, 
                1, NULL, NULL 
              FROM sitemarker_records_old
            ''');

            // Add new columns
            // await m.addColumn(
            //     schema.sitemarkerRecords, schema.sitemarkerRecords.folderId);
            // await m.addColumn(
            //     schema.sitemarkerRecords, schema.sitemarkerRecords.lastSynced);
            // await m.addColumn(
            //     schema.sitemarkerRecords, schema.sitemarkerRecords.notes);

            // Migrate tags

            final rawRowsOfTags = await customSelect(
              'SELECT id, tags FROM sitemarker_records_old',
            ).get();

            Map<String, int> tagCache = {};

            for (final row in rawRowsOfTags) {
              final recordId = row.read<int>('id');
              final tagsString = row.read<String?>('tags');

              if (tagsString != null && tagsString.isNotEmpty) {
                // split and trim
                final tagsList = tagsString
                    .split(',')
                    .map((t) => t.trim())
                    .where((t) => t.isNotEmpty);

                // deduplicated insert/assignment
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
                        RawValuesInsertable({
                          'name': Variable<String>(tag),
                        }),
                      );
                    }
                    tagCache[tag] = tagId;
                  }
                  await into(schema.tagMappings).insert(
                    RawValuesInsertable(
                      {
                        'bookmark_id': Variable<int>(recordId),
                        'tag_id': Variable<int>(tagId),
                      },
                    ),
                    mode: InsertMode.insertOrIgnore,
                  );
                }
              }
            }

            await customStatement('DROP TABLE sitemarker_records_old');
          },
        ),
        beforeOpen: (details) async {
          if (details.hadUpgrade && details.versionBefore! < 2) {
            await update(sitemarkerRecords).write(
              SitemarkerRecordsCompanion(
                dateAdded: Value(
                  DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day),
                ),
              ),
            );
          }
        });
  }

  // Watcher (Helper) for Provider
  Stream<DirView> watchDirectory(int folderId) {
    final folderStream =
        (select(folders)..where((f) => f.parentId.equals(folderId))).watch();

    final recordStream = (select(sitemarkerRecords)
          ..where((r) => r.folderId.equals(folderId)))
        .watch();

    return Rx.combineLatest2(
        folderStream,
        recordStream,
        (List<Folder> f, List<SitemarkerRecord> r) =>
            DirView(records: r, subdirs: f));
  }

  // Writer (Helper) for record creation
  Future<void> createRecordsWithTags({required SmRecord record}) {
    return transaction(() async {
      final recordId = await into(sitemarkerRecords)
          .insert(SitemarkerRecordsCompanion.insert(
        name: record.name,
        url: record.url,
        folderId: Value(record.folderId),
      ));
      record.id = recordId;

      if (record.tags.isNotEmpty) {
        for (String tag in record.tags) {
          if (tag.trim().isEmpty) {
            // Empty tag
            continue;
          }
          final existingTag = await (select(recordTags)
                ..where((t) => t.name.equals(tag)))
              .getSingleOrNull();

          int tagId;
          if (existingTag != null) {
            tagId = existingTag.id;
          } else {
            tagId = await into(recordTags)
                .insert(RecordTagsCompanion.insert(name: tag));
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
    return (select(sitemarkerRecords)
          ..where((t) => t.folderId.equals(folderId)))
        .get();
  }

  Future<List<String>> getFolderById(int folderId) async {
    return (await (select(folders)..where((t) => t.id.equals(folderId)))
            .get())
        .map((t) => t.name)
        .toList();
  }

  // Get all subfolders of a folder with folder ID known
  Future<List<Folder>> getAllSubfolders(int folderId) {
    return (select(folders)..where((t) => t.parentId.equals(folderId))).get();
  }

  // Get all tags of a record where the ID of the record is known
  Future<List<RecordTag>> getAllTagsInRecord(int recordId) async {
    final mappings = await (select(tagMappings)
          ..where((t) => t.bookmarkId.equals(recordId)))
        .get();
    List<RecordTag> records = [];
    for (final mapping in mappings) {
      records.add(await (select(recordTags)
            ..where((t) => t.id.equals(mapping.tagId)))
          .getSingle());
    }

    return records;
  }

  // Get all bookmarks which have got the same tag id
  Future<List<SitemarkerRecord>> getAllRecordsByTagId(int tagId) async {
    final mappings =
        await (select(tagMappings)..where((t) => t.tagId.equals(tagId))).get();

    List<SitemarkerRecord> records = [];
    for (final mapping in mappings) {
      records.add(await (select(sitemarkerRecords)
            ..where((t) => t.id.equals(mapping.bookmarkId)))
          .getSingle());
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
      DateTime dateRangeStart, DateTime dateRangeEnd) {
    return (select(sitemarkerRecords)
          ..where((t) => t.dateAdded.isBetween(
                Constant(dateRangeStart),
                Constant(dateRangeEnd),
              )))
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

    return update(sitemarkerRecords).replace(
      record.copyWith(isDeleted: true),
    );
  }

  /// Get deleted records
  Future<List<SitemarkerRecord>> getDeletedRecords() {
    return (select(sitemarkerRecords)..where((t) => t.isDeleted.equals(true)))
        .get();
  }

  /// Get undeleted records
  Future<List<SitemarkerRecord>> getUndeletedRecords() {
    return (select(sitemarkerRecords)..where((t) => t.isDeleted.equals(false)))
        .get();
  }

  /// Get all folders
  Future<List<Folder>> get allFolders => select(folders).get();
}

/// Schema definition
class SitemarkerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get url => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  // DB v2: Added the dateAdded column
  DateTimeColumn get dateAdded => dateTime().withDefault(Constant(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day)))();

  // DB v3: Added the dateModified column
  DateTimeColumn get dateModified => dateTime().withDefault(Constant(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day)))();

  // DB v4: Added the last synced column
  DateTimeColumn get lastSynced => dateTime().nullable()();

  // DB v4: Added the notes column
  TextColumn get notes => text().nullable()();

  // DB v4: Added the folderId column
  // 1 is root
  IntColumn get folderId =>
      integer().references(Folders, #id).withDefault(const Constant(1))();

  @override
  List<String> get customConstraints => ['UNIQUE(folder_id, name)'];
}

// DB v4: Move tags outside of SitemarkerRecords
class RecordTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}

// DB v4: Make tag-bookmark mapping into a separate table
class TagMappings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookmarkId => integer()
      .references(SitemarkerRecords, #id, onDelete: KeyAction.cascade)();
  IntColumn get tagId =>
      integer().references(RecordTags, #id, onDelete: KeyAction.cascade)();
}

// DB v4: Added Folders/Subfolders/record concept. This shifts the entire
// structure from record-only to dir-record based filesystem style structure
class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parentId => integer().nullable().references(Folders, #id)();
  TextColumn get name => text()();

  @override
  List<String> get customConstraints => ['UNIQUE(parent_id, name)'];
}
