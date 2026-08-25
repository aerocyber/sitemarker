import 'package:sitemarker/core/db/sm_db.dart';

class SmFolder {
  int? id;
  int? parentId; // null => root
  DateTime? lastSynced;
  String name;
  bool isDeleted;
  DateTime dateAdded;
  DateTime dateModified;

  SmFolder({
    this.id,
    required this.name,
    required this.parentId,
    required this.isDeleted,
    required this.dateAdded,
    required this.dateModified,
    required this.lastSynced,
  });

  static SmFolder fromFolders(FolderRecord folder) {
    return SmFolder(
      id: folder.id,
      name: folder.name,
      parentId: folder.parentId,
      isDeleted: folder.isDeleted,
      dateAdded: folder.dateAdded,
      dateModified: folder.dateModified,
      lastSynced: folder.lastSynced,
    );
  }

  FolderRecord toFolderRecord() {
    return FolderRecord(
      id: id ?? -1,
      name: name,
      parentId: parentId,
      isDeleted: isDeleted,
      dateAdded: dateAdded,
      dateModified: dateModified,
      lastSynced: lastSynced,
    );
  }
}
