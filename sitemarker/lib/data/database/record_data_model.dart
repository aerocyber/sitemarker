class RecordDataModel {
  String name;
  String url;
  List<String> tags;

  RecordDataModel({required this.name, required this.url, required this.tags});

  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, Map<String, String>> toJson() {
    return {
      name: {"URL": url, "Categories": tags.toString()}
    };
  }
}
