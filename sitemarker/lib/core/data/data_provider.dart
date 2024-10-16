import 'package:flutter/material.dart';
import 'package:sitemarker/core/data/db/db_access.dart';
import 'package:sitemarker/core/data/data_passing.dart';


class DataProvider extends ChangeNotifier{
  late SitemarkerDB db;
  List<SitemarkerRecord> _records = [];
  List<SitemarkerRecord> get records => _records;

  void init() async {
    _records = await db.allRecords;
    notifyListeners();
  }

  DataProvider() {
    db = SitemarkerDB();
    init();
  }

  int getDefaultId() {
    if (records.isNotEmpty) {
      return records.last.id + 1;
    }
    return 0;
  }

  void insertRecord(DataPassing record) {
    final rec = SitemarkerRecord(
      id: getDefaultId(),
      name: record.name,
      url: record.url,
      tags: record.tags,
      isDeleted: false,
    );

    _records.add(rec);
    db.insertRecord(rec);
    notifyListeners();
  }

  void deleteRecord(DataPassing record) async {
    final rec = await db.getRecordsByName(record.name);
    db.deleteRecord(rec.first);
    _records.remove(rec.first);
    notifyListeners();
  }

  void updateRecord(SitemarkerRecord record) async {
    db.updateRecord(record);
    _records = await db.allRecords;
    notifyListeners();
  }
}
