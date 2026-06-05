import 'package:sitemarker/core/db/sm_db.dart';

class SmFolder {
  int? id;
  int? parentId; // null => root
  String name;

  SmFolder({this.id, required this.name, required this.parentId});

  static SmFolder fromFolders(FolderRecord folder) {
    return SmFolder(name: folder.name, parentId: folder.parentId);
  }

  FolderRecord toFolderRecord() {
    return FolderRecord(id: id ?? -1, name: name, parentId: parentId);
  }
}
