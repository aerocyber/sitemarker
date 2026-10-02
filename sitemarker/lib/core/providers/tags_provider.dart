import 'package:flutter/foundation.dart';
import 'package:sitemarker/core/data_types/sm_tag.dart';
import 'package:sitemarker/core/repos/tags_repo.dart';

class TagsProvider extends ChangeNotifier {
  final TagsRepository _repo;
  // final TagsMappi

  TagsProvider(this._repo);

  List<SmTag> _allTags = [];
  List<SmTag> get allTags => _allTags;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadTags() async {
    _isLoading = true;
    notifyListeners();
    _allTags = await _repo.getAllTags();
    _isLoading = false;
    notifyListeners();
  }

  Future<int> createTag(String name) async {
    final newId = await _repo.createTag(name);
    await loadTags();
    return newId; 
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

  // Future<List<String>> getTagsForRecord(int recordId) async {
  //   final recordTags = await _repo.
  // }
}
