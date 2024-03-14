import 'package:drift/drift.dart';
import 'package:sitemarker/data/shared_db.dart' as impl;

part 'data_model.g.dart';

@DriftDatabase(tables: [Records])
class SitemarkerDB extends _$SitemarkerDB {
  SitemarkerDB() : super(impl.connect());

  @override
  int get schemaVersion => 1;

  // SELECTs
  Future<List<Record>> get allRecords => select(records).get();

  Future<List<Record>> getRecordsByName(String name) {
    return (select(records)..where((t) => t.name.equals(name))).get();
  }

  // INSERT
  Future<int> insertRecord(Record record) => into(records).insert(record);

  // UPDATE
  Future<bool> updateRecord(Record record) => update(records).replace(record);

  // DELETE
  Future<int> deleteRecord(Record record) => delete(records).delete(record);
}

class Records extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get url => text()();
  TextColumn get tags => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}
