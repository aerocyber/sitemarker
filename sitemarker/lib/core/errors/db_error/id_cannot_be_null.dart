class IdCannotBeNullException implements Exception {
  @override
  String toString() {
    return "ID of this table entry cannot be null";
  }
}
