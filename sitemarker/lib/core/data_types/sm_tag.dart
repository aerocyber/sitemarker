import 'package:sitemarker/core/db/sm_db.dart';

class SmTag {
  final int id;
  final String name;

  SmTag({required this.id, required this.name});

  static SmTag fromRecordTag(RecordTag recTag) =>
      SmTag(id: recTag.id, name: recTag.name);

  RecordTag toRecTag() => RecordTag(id: id, name: name);
}
