/// Assisting data structure for DB to application and application to DB data passing
class SmRecord {
  int? id;
  String name;
  String url;
  String tags;
  DateTime dt;
  bool? isDeleted;

  SmRecord({
    this.id,
    this.isDeleted,
    required this.name,
    required this.url,
    required this.tags,
    required this.dt,
  });
}
