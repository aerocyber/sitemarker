import 'package:flutter/material.dart';
import 'package:sitemarker/core/data/data_model.dart';
import 'package:sitemarker/core/data/database/db.dart';

class DbProvider extends ChangeNotifier {
  late SitemarkerDB db;
  List<DBDataModel> _records = [];
  List<DBDataModel> get records => _records;

  void init() async {
    List<SitemarkerRecord> dbrecords = await db.allRecords;

    for (int i = 0; i < dbrecords.length; i++) {
      _records.add(
        DBDataModel(
            id: dbrecords[i].id,
            name: dbrecords[i].name,
            url: dbrecords[i].url,
            tags: dbrecords[i].tags,
            isDeleted: dbrecords[i].isDeleted),
      );
    }

    notifyListeners();
  }

  DbProvider() {
    db = SitemarkerDB();
    init();
  }

  int getDefaultId() {
    if (_records.isEmpty) {
      return 0;
    }
    return _records.last.id! + 1;
  }

  void insertRecord(DBDataModel rec) {
    final record = SitemarkerRecord(
      id: getDefaultId(),
      name: rec.name,
      url: rec.url,
      tags: rec.tags,
      isDeleted: rec.isDeleted,
    );
    rec.id = record.id;
    db.insertRecord(record);
    _records.add(rec);
    notifyListeners();
  }

  void deleteRecord(DBDataModel rec) async {
    int id = rec.id!;
    final record = await db.getRecordsById(id);
    db.deleteRecord(record.first);
    init();
  }
}
