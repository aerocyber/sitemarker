import 'package:isar/isar.dart';

part 'data_model.g.dart';

@Collection()
class DBRecord {
  final id = Isar.autoIncrement;
  String name;
  String url;
  String tags;

  @Index()
  bool isDeleted;

  DBRecord(
      {required this.name,
      required this.url,
      required this.tags,
      required this.isDeleted});
}
