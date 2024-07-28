class DBDataModel {
  int? id;
  String name;
  String url;
  String tags;
  bool isDeleted;

  static tagsFromList(List<String> tagString) {
    tagString.join(',');
  }

  DBDataModel({
    required this.id,
    required this.name,
    required this.url,
    required this.tags,
    required this.isDeleted,
  });
}
