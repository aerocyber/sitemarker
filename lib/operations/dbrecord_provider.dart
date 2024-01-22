import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sitemarker/operations/data_model.dart';

class DBRecordProvider extends ChangeNotifier {
  late Future<Isar?> db;
  List<DBRecord> _records = [];
  List<DBRecord> get records => _records;

  void init() async {
    final isar = await db;
    isar!.txn(() async {
      final dbrecordCollection = isar.dBRecords;
      _records = await dbrecordCollection.where().findAll();
      notifyListeners();
    });
  }

  Future<Isar?> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final appDoc = await getApplicationDocumentsDirectory();
      final dir = p.join(appDoc.path, 'sitemarker-db');
      return await Isar.open(
        [DBRecordSchema],
        directory: dir,
        inspector: true,
      );
    }

    return Isar.getInstance();
  }

  DBRecordProvider() {
    db = openDB();
    init();
  }

  void insertRecord(DBRecord record) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.dBRecords.put(record);
      _records.add(record);
      notifyListeners();
    });
  }

  void deleteRecord(DBRecord record) async {
    final isar = await db;
    await isar!.writeTxn(() async {
      await isar.dBRecords.delete(record.id);
      _records.remove(record);

      notifyListeners();
    });
  }
}
