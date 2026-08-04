import 'package:flutter/foundation.dart';
import 'package:sitemarker/core/repos/tags_repo.dart';

class TagsProvider extends ChangeNotifier {
  final TagsRepository _repo;

  TagsProvider(this._repo);

  List<Map<int, String>> _allTags = [];
  List<Map<int, String>> get allTags => _allTags;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadTags() async {
    _isLoading = true;
    notifyListeners();
    _allTags = await _repo.getAllTags();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createTag(String name) async {
    await _repo.createTag(name);
    await loadTags();
  }

  Future<void> renameTag(int id, String newName) async {
    await _repo.renameTag(id, newName);
    await loadTags();
  }

  Future<void> attachTag(int tagId, int recordId) async {
    await _repo.attachTagToRecord(tagId, recordId);
  }

  Future<void> removeMapping(int mappingId) async {
    await _repo.removeMapping(mappingId);
  }
}
