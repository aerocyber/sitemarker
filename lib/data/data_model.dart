import 'package:drift/drift.dart';
import 'package:sitemarker/data/shared_db.dart' as impl;

part 'data_model.g.dart';

@DriftDatabase(tables: [SitemarkerRecords])
class SitemarkerDB extends _$SitemarkerDB {
  SitemarkerDB() : super(impl.connect());

  @override
  int get schemaVersion => 1;

  // SELECTs
  Future<List<SitemarkerRecord>> get allRecords =>
      select(sitemarkerRecords).get();

  Future<List<SitemarkerRecord>> getRecordsByName(String name) {
    return (select(sitemarkerRecords)..where((t) => t.name.equals(name))).get();
  }

  // INSERT
  Future<int> insertRecord(SitemarkerRecord record) =>
      into(sitemarkerRecords).insert(record);

  // UPDATE
  Future<bool> updateRecord(SitemarkerRecord record) =>
      update(sitemarkerRecords).replace(record);

  // DELETE
  Future<int> deleteRecord(SitemarkerRecord record) =>
      delete(sitemarkerRecords).delete(record);
}

class SitemarkerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get url => text()();
  TextColumn get tags => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}
