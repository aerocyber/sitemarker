import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:sitemarker/core/data_types/sm_tag.dart';
import 'package:sitemarker/core/logging/logger.dart';
import 'package:sitemarker/core/repos/tags_repo.dart';

class TagsProvider extends ChangeNotifier {
  final TagsRepository _repo;
  final log = LogManager.instance;

  TagsProvider(this._repo);

  List<SmTag> _allTags = [];
  List<SmTag> get allTags => _allTags;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadTags() async {
    log.log(LogLevel.debug, '[TAG PROVIDER]: Received request for loadTags');
    try {
      _isLoading = true;
      notifyListeners();
      _allTags = await _repo.getAllTags();
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[TAG PROVIDER]: Failed to load tags to state. Error: $e\n$stack',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  FutureOr<int?> createTag(String name) async {
    log.log(LogLevel.debug, '[TAG PROVIDER]: Received request for createTag');
    try {
      final newId = await _repo.createTag(name);
      log.log(LogLevel.debug, '[TAG PROVIDER]: Refreshing tags');
      await loadTags();
      return newId;
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[TAG PROVIDER]: Failed to create tag. Error: $e\n$stack',
      );
      return null;
    }
  }

  Future<void> renameTag(int id, String newName) async {
    log.log(LogLevel.debug, '[TAG PROVIDER]: Received request for renameTag');
    try {
      await _repo.renameTag(id, newName);
      log.log(LogLevel.debug, 'Updating the tag cache');
      await loadTags();
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[TAG PROVIDER]: Failed to rename tag. Error: $e\n$stack',
      );
    }
  }

  Future<void> attachTag(int tagId, int recordId) async {
    log.log(LogLevel.debug, '[TAG PROVIDER]: Received request for attachTag');
    try {
      await _repo.attachTagToRecord(tagId, recordId);
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        'Failed attaching tag to record. Error: $e\n$stack',
      );
    }
  }

  Future<void> removeMapping(int mappingId) async {
    log.log(
      LogLevel.debug,
      '[TAG PROVIDER]: Received request for removeMapping',
    );
    try {
      await _repo.removeMapping(mappingId);
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[TAG PROVIDER]: Failed to remove tag mapping. Error: $e\n$stack',
      );
    }
  }
}
