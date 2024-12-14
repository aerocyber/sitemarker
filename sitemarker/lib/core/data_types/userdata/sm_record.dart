/// Assisting data structure for DB to application and application to DB data passing
class SmRecord {
  String name;
  String url;
  String tags;
  DateTime dt;

  SmRecord({
    required this.name,
    required this.url,
    required this.tags,
    required this.dt,
  });
}
