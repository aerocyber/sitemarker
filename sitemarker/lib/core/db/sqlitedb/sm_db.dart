import 'package:drift/drift.dart';
import 'package:sitemarker/core/db/sqlitedb/shared_db.dart' as impl;
import 'package:sitemarker/core/db/sqlitedb/sm_db.steps.dart';

part 'sm_db.g.dart';

@DriftDatabase(tables: [SitemarkerRecords])
class SitemarkerDB extends _$SitemarkerDB {
  SitemarkerDB() : super(impl.connect());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onUpgrade: stepByStep(from1To2: (m, schema) async {
      await m.addColumn(
        schema.sitemarkerRecords,
        schema.sitemarkerRecords.dateAdded,
      );
    }), beforeOpen: (details) async {
      if (details.hadUpgrade) {
        await update(sitemarkerRecords).write(SitemarkerRecordsCompanion(
            dateAdded: Value(
          DateTime(
              DateTime.now().year, DateTime.now().month, DateTime.now().day),
        )));
      }
    });
  }

  // SELECTs
  Future<List<SitemarkerRecord>> get allRecords =>
      select(sitemarkerRecords).get();

  Future<List<SitemarkerRecord>> getRecordsByName(String name) {
    return (select(sitemarkerRecords)..where((t) => t.name.equals(name))).get();
  }

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

  // INSERT
  Future<int> insertRecord(SitemarkerRecord record) =>
      into(sitemarkerRecords).insert(record);

  // UPDATE
  Future<bool> updateRecord(SitemarkerRecord updatedRecord) =>
      update(sitemarkerRecords).replace(updatedRecord);

  // PERMANENT DELETE
  Future<int> hardDelete(SitemarkerRecord record) =>
      delete(sitemarkerRecords).delete(record);

  // SOFT DELETE
  Future<bool> softDelete(SitemarkerRecord record) {
    SitemarkerRecord rec = SitemarkerRecord(
      id: record.id,
      name: record.name,
      url: record.url,
      tags: record.tags,
      isDeleted: record.isDeleted,
      dateAdded: record.dateAdded,
    );

    return update(sitemarkerRecords).replace(rec);
  }
}

class SitemarkerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get url => text()();
  TextColumn get tags => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  // DB v2
  DateTimeColumn get dateAdded => dateTime().withDefault(Constant(DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day)))();
}
