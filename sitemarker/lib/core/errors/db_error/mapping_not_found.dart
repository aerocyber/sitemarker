class MappingNotFoundException implements Exception {
  int mappingId;

  MappingNotFoundException({required this.mappingId});

  @override
  String toString() {
    return "Provided mapping with id $mappingId does not exist";
  }
}
