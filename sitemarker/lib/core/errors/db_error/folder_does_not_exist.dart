class FolderDoesNotExistException implements Exception {
  int parentId;

  FolderDoesNotExistException({required this.parentId});

  @override
  String toString() {
    return "Folder with ID $parentId does not exist. Try creating one.";
  }
}
