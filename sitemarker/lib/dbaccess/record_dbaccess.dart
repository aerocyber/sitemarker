import 'package:sitemarker/database/database.dart';
import 'package:sitemarker/model/record.dart';

class RecordDbaccess {
  final db = SitemarkerDB();
  late List<SitemarkerRecord> _records;

  void init() async {
    _records = await db.allRecords;
  }

  RecordDbaccess() {
    init();
  }

  int getDefaultId() {
    if (_records.isNotEmpty) {
      return _records.last.id + 1;
    }
    return 0;
  }

  // Add record
  void addRecord(RecordModel record) async {
    final tagString = record.tags.join(",");
    final rec = SitemarkerRecord(
        id: getDefaultId(),
        name: record.name,
        url: record.url,
        tags: tagString,
        isDeleted: record.isDeleted);
    _records.add(rec);
    db.insertRecord(rec);
  }

  // Delete
  void deleteRecord(RecordModel record) async {
    final rec = await db.getRecordsByName(record.name);
    db.deleteRecord(rec.first);
    _records.remove(rec.first);
  }

  // Update
  void updateRecord(SitemarkerRecord record) async {
    db.updateRecord(record);
    _records = await db.allRecords;
  }

  // Get all records
  List<RecordModel> getAll() {
    List<RecordModel> records = [];
    for (int i = 0; i < _records.length; i++) {
      final tagList = _records[i].tags.split(",");
      records.add(
        RecordModel(name: _records[i].name, url: _records[i].url, tags: tagList, isDeleted: _records[i].isDeleted)
      );
    }
    return records;
  }
}
