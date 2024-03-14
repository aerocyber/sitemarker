import 'package:flutter/material.dart';
import 'package:sitemarker/data/data_helper.dart';
import 'package:sitemarker/data/data_model.dart';

class DBRecordProvider extends ChangeNotifier {
  late SitemarkerDB db;
  List<SitemarkerRecord> _records = [];
  List<SitemarkerRecord> get records => _records;
  late String dbDir;
  bool inspectorIsar = false;

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
      tags: record.tags,
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
  }
}
