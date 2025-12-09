/// Assisting data structure for DB to application and application to DB data passing
class SmRecord {
  int? id;
  String name;
  String url;
  String tags;
  DateTime dt;
  bool? isDeleted;
  String? notes;

  SmRecord({
    this.id,
    this.isDeleted,
    this.notes,
    required this.name,
    required this.url,
    required this.tags,
    required this.dt,
  });

  @override
  String toString() {
    return 'SmRecord{id: $id, name: $name, url: $url, tags: $tags, dt: $dt, isDeleted: $isDeleted}';
  }
}
