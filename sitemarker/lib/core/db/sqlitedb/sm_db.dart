import 'package:drift/drift.dart';
import 'package:sitemarker/core/db/sqlitedb/shared_db.dart' as impl;
import 'package:sitemarker/core/db/sqlitedb/sm_db.steps.dart';

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
        ),
        beforeOpen: (details) async {
          if (details.hadUpgrade) {
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

  // SELECTs
  /// Get all records
  Future<List<SitemarkerRecord>> get allRecords =>
      select(sitemarkerRecords).get();

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

  /// Get records matching/containing tags
  Future<List<SitemarkerRecord>> getRecordsByTags(List<String> tags) async {
    List<SitemarkerRecord> toRet = [];
    List<SitemarkerRecord> tmp = [];
    List<SitemarkerRecord> srl = await select(sitemarkerRecords).get();

    for (int i = 0; i < srl.length; i++) {
      List<String> s = srl[i].tags.split(",");
      for (int j = 0; i < s.length; j++) {
        String str = s[i].trim();
        s[i] = str;
      }
      tmp.add(SitemarkerRecord(
        id: srl[i].id,
        name: srl[i].name,
        url: srl[i].url,
        tags: srl[i].tags,
        isDeleted: srl[i].isDeleted,
        dateAdded: srl[i].dateAdded,
      ));
    }

    for (int i = 0; i < tmp.length; i++) {
      List<String> tmpTags = tmp[i].tags.split(',');
      bool ignoreIter = false;
      for (int t = 0; t < tags.length; t++) {
        if (!tmpTags.contains(tags[i])) {
          tmp.removeAt(i);
          ignoreIter = true;
        }
      }
      if (ignoreIter) {
        break;
      }
    }

    toRet = tmp;

    return toRet;
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
      tags: record.tags,
      isDeleted: !record.isDeleted,
      dateAdded: record.dateAdded,
    );

    return update(sitemarkerRecords).replace(rec);
  }

  /// Soft delete a record
  Future<bool> softDelete(SitemarkerRecord record) {
    SitemarkerRecord rec = SitemarkerRecord(
      id: record.id,
      name: record.name,
      url: record.url,
      tags: record.tags,
      isDeleted: true,
      dateAdded: record.dateAdded,
    );

    return update(sitemarkerRecords).replace(rec);
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
}

/// Schema definition
class SitemarkerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
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
