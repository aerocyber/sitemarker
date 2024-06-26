import 'package:flutter/material.dart';
import 'package:sitemarker/data/database/record_data_model.dart';
import 'package:sitemarker/data/database/database.dart';

class DBRecordProvider extends ChangeNotifier {
  late SitemarkerDB db;
  List<SitemarkerRecord> _records = [];
  List<SitemarkerRecord> get records => _records;

  void init() async {
    _records = await db.allRecords;
    notifyListeners();
  }

  DBRecordProvider() {
    db = SitemarkerDB();
    init();
  }

  int getDefaultId() {
    if (_records.isNotEmpty) {
      return _records.last.id + 1;
    }
    return 0;
  }

  void insertRecord(RecordDataModel record) async {
    final rec = SitemarkerRecord(
      id: getDefaultId(),
      name: record.name,
      url: record.url,
      tags: record.tags.join(','),
      isDeleted: false,
    );
    _records.add(rec);
    db.insertRecord(rec);
    notifyListeners();
  }

  void deleteRecord(RecordDataModel record) async {
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
