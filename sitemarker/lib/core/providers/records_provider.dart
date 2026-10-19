import 'package:flutter/foundation.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/logging/logger.dart';
import 'package:sitemarker/core/repos/records_repo.dart';

class RecordsProvider extends ChangeNotifier {
  final RecordsRepository _repo;

  int _creationId = -1;
  int get creationId => _creationId;
  LogManager log = LogManager.instance;

  RecordsProvider(this._repo);

  // List<SmRecord> _currentRecords = [];
  // List<SmRecord> get currentRecords => _currentRecords;

  final Map<int, List<SmRecord>> _recordsCache = {};
  List<SmRecord> getRecordsForFolder(int folderId) =>
      _recordsCache[folderId] ?? [];

  List<SmRecord> _trashRecords = [];
  List<SmRecord> get trashRecords => _trashRecords;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Future<void> loadActiveRecords() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   _currentRecords = await _repo.getActiveRecords();
  //   _isLoading = false;
  //   notifyListeners();
  // }

  Future<void> loadRecordsByFolder(int folderId) async {
    log.log(
      LogLevel.debug,
      '[RECORDS PROVIDER]: Received request for loadRecordsByFolder for folder id $folderId',
    );

    try {
      if (!_recordsCache.containsKey(folderId)) {
        _isLoading = true;
        notifyListeners();
      }

      _recordsCache[folderId] = await _repo.getRecordsByFolder(folderId);
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[RECORDS PROVIDER]: Failed to get records from folder. Error: $e\n$stack',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTrash() async {
    log.log(
      LogLevel.debug,
      '[RECORDS PROVIDER]: Received request for loadTrash',
    );
    _isLoading = true;
    notifyListeners();
    try {
      _trashRecords = await _repo.getDeletedRecords();
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[RECORDS PROVIDER]: Failed to load trash. Error: $e\n$stack',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecord(SmRecord record) async {
    log.log(
      LogLevel.debug,
      '[RECORDS PROVIDER]: Received request to addRecord',
    );
    _isLoading = true;
    try {
      _creationId = await _repo.addRecord(record);

      if (_recordsCache.containsKey(record.folderId)) {
        _recordsCache[record.folderId] = await _repo.getRecordsByFolder(
          record.folderId,
        );
      }
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[RECORDS PROVIDER]: Failed to add record. Error: $e\n$stack',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRecord(SmRecord record) async {
    log.log(
      LogLevel.debug,
      '[RECORDS PROVIDER]: Recieved request to updateRecord',
    );
    try {
      await _repo.updateRecord(record);
      await loadRecordsByFolder(record.folderId);
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[RECORDS PROVIDER]: Failed to update record. Error: $e\n$stack',
      );
    }
  }

  Future<void> sendToTrash(SmRecord record) async {
    log.log(
      LogLevel.debug,
      '[RECORDS PROVIDER]: Received request to sendToTrash',
    );
    try {
      if (_recordsCache.containsKey(record.folderId)) {
        _recordsCache[record.folderId] = _recordsCache[record.folderId]!
            .where((r) => r.id != record.id)
            .toList();
        notifyListeners();
      }

      await _repo.sendRecordToTrash(record);
      _recordsCache[record.folderId] = await _repo.getRecordsByFolder(
        record.folderId,
      );
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[RECORDS PROVIDER]: Error sending record to trash Error: $e\n$stack',
      );
    } finally {
      notifyListeners();
      await loadTrash();
    }
  }

  Future<void> restoreFromTrash(SmRecord record) async {
    log.log(
      LogLevel.debug,
      '[RECORDS PROVIDER]: Received request to requestFromTrash',
    );

    _isLoading = true;
    notifyListeners();

    try {
      await _repo.restoreRecordFromTrash(record);

      _recordsCache[record.folderId] = await _repo.getRecordsByFolder(
        record.folderId,
      );

      if (record.folderId != 1) {
        _recordsCache[1] = await _repo.getRecordsByFolder(1);
      }
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[RECORDS PROVIDER]: Failed to restore record from trash. Error: $e\n$stack',
      );
    } finally {
      await loadTrash();
    }
  }

  Future<void> permaDelete(SmRecord record) async {
    log.log(
      LogLevel.debug,
      '[RECORDS PROVIDER]: Received request to permaDelete',
    );
    try {
      await _repo.permaDeleteRecord(record);
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[RECORDS PROVIDER]: Failed to perma delete record. Error: $e\n$stack',
      );
    } finally {
      await loadTrash();
    }
  }

  // Future<List<SmRecord>> searchRecords(String query) async {
  //   log.log(
  //     LogLevel.debug,
  //     '[RECORDS PROVIDER]: Received request for searchRecords',
  //   );
  //   try {
  //     if (query.trim().isEmpty) return [];
  //     return await _repo.searchRecords(query.trim());
  //   } catch (e, stack) {
  //     log.log(
  //       LogLevel.error,
  //       '[RECORDS PROVIDER]: Failed to search records. Error: $e\n$stack',
  //     );
  //     return []; // Fallback for the function signature
  //   }
  // }

  Future<List<SmRecord>> searchAdvanced({
    String? nameQuery,
    String? urlQuery,
    List<String>? tags,
    int? folderId,
  }) async {
    log.log(
      LogLevel.debug,
      '[RECORDS PROVIDER]: Received request for searchAdvanced',
    );
    try {
      return await _repo.searchAdvanced(
        nameQuery: nameQuery,
        urlQuery: urlQuery,
        tags: tags,
        folderId: folderId,
      );
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[RECORDS PROVIDER]: Error searching for records. Error: $e\n$stack',
      );
      return []; // Fallback for function return type (function signature)
    }
  }

  void removeFolderFromCache(int folderId) {
    log.log(
      LogLevel.debug,
      '[RECORDS PROVIDER]: Received request to removeFolderFromCache',
    );
    try {
      _recordsCache.remove(folderId);
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[RECORDS PROVIDER]: Error removing folder from cache. Error: $e\n$stack',
      );
    }
    notifyListeners();
  }
}
