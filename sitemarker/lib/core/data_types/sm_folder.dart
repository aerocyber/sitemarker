import 'package:sitemarker/core/db/sm_db.dart';

class SmFolder {
  int? id;
  int? parentId; // null => root
  String name;
  bool isDeleted;

  SmFolder({
    this.id,
    required this.name,
    required this.parentId,
    required this.isDeleted,
  });

  static SmFolder fromFolders(FolderRecord folder) {
    return SmFolder(
      id: folder.id,
      name: folder.name,
      parentId: folder.parentId,
      isDeleted: folder.isDeleted,
    );
  }

  FolderRecord toFolderRecord() {
    return FolderRecord(
      id: id ?? -1,
      name: name,
      parentId: parentId,
      isDeleted: isDeleted,
    );
  }
}
