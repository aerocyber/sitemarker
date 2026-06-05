class TagNotFoundException implements Exception {
  int id;

  TagNotFoundException({required this.id});

  @override
  String toString() {
    return "Tag with id $id not found";
  }
}
