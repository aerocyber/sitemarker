import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:universal_io/io.dart';

class DBRecordProvider extends ChangeNotifier {
  late Future<Isar?> db;
  List<DBRecord> _records = [];
  List<DBRecord> get records => _records;
  late String dbDir;
  bool inspectorIsar = true;

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
      dbDir = p.join(appDoc.path, 'sitemarker-db');

      if (!(await Directory(dbDir).exists())) {
        await Directory(dbDir).create(recursive: true);
      }

      return await Isar.open(
        [DBRecordSchema],
        directory: dbDir,
        inspector: inspectorIsar,
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
      isar.dBRecords.delete(record.id);
      _records.remove(record);

      // Yeah, no, as if it works.
    });
    // Work around to delete a record. Trust me, I'm annoyed too.
    // If you know how to do it properly, please do so.
    // You know what? I might as well do a special announcement for that if
    // you do.
    deleteWorkaround();
    notifyListeners();
  }

  void deleteWorkaround() async {
    final recs = _records; // Get records.

    final isar = await db;
    await isar!.close(deleteFromDisk: true); // Close the db. Delete the db.

    // Now, reopen the db.
    final isarTemp = await openDB();
    List<DBRecord> localRecords = [];
    isarTemp!.txn(() async {
      final dbrecordCollection = isarTemp.dBRecords;
      localRecords = await dbrecordCollection.where().findAll();
    });

    for (int i = 0; i < recs.length; i++) {
      await isarTemp.writeTxn(() async {
        await isarTemp.dBRecords.put(recs[i]);
        localRecords.add(recs[i]);
      });
    }

    // Close the new instance
    await isarTemp.close();

    // Reopen the old one
    // I know, it's annoying and frustrating
    _records = [];
    db = openDB();
    init();
    notifyListeners(); // That's it, I guess.
  }

  // Future<void> deleteRecord(DBRecord record) async {
  //   final isar = await db;
  //   await isar!.writeTxn(() async {
  //     final recordToDelete =
  //         await isar.dBRecords.where().idEqualTo(record.id).findFirst();
  //     if (recordToDelete != null) {
  //       await record.delete();
  //     }
  //   });
  // }
}
