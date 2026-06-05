import 'package:sitemarker/core/db/sm_db.dart';

/// Assisting data structure for DB to application and application to DB data passing
class SmRecord {
  int? id;
  DateTime? lastSynced;
  String? notes;
  bool isDeleted;
  int folderId;
  DateTime dateAdded;
  DateTime dateModified;
  String name;
  String url;
  List<String> tags;

  SmRecord({
    required this.id,
    required this.notes,
    required this.lastSynced,
    required this.isDeleted,
    required this.name,
    required this.url,
    required this.tags,
    required this.folderId,
    required this.dateAdded,
    required this.dateModified,
  });

  static SmRecord fromSitemarkerRecord(
      SitemarkerRecord record, List<String> tags) {
    return SmRecord(
      id: record.id,
      name: record.name,
      url: record.url,
      tags: tags,
      dateAdded: record.dateAdded,
      dateModified: record.dateModified,
      folderId: record.folderId,
      lastSynced: record.lastSynced,
      isDeleted: record.isDeleted,
      notes: record.notes,
    );
  }

  SitemarkerRecord toSitemarkerRecord() {
    return SitemarkerRecord(
      id: id ?? -1,
      name: name,
      url: url,
      isDeleted: isDeleted,
      dateAdded: dateAdded,
      dateModified: dateModified,
      folderId: folderId,
      lastSynced: lastSynced,
      notes: notes,
    );
  }
}
