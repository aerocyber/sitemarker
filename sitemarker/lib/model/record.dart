class RecordModel {
  // Name of the record.
  String name;
  // URL of the record.
  String url;
  // Tags of the record.
  List<String> tags;
  // Is the record deleted?
  bool isDeleted;

  RecordModel(
      {required this.name,
      required this.url,
      required this.tags,
      required this.isDeleted});
}
