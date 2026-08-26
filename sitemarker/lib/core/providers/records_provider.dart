import 'package:flutter/foundation.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/repos/records_repo.dart';

class RecordsProvider extends ChangeNotifier {
  final RecordsRepository _repo;

  RecordsProvider(this._repo);

  List<SmRecord> _currentRecords = [];
  List<SmRecord> get currentRecords => _currentRecords;

  List<SmRecord> _trashRecords = [];
  List<SmRecord> get trashRecords => _trashRecords;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadActiveRecords() async {
    _isLoading = true;
    notifyListeners();
    _currentRecords = await _repo.getActiveRecords();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadRecordsByFolder(int folderId) async {
    _isLoading = true;
    notifyListeners();
    _currentRecords = await _repo.getRecordsByFolder(folderId);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadTrash() async {
    _isLoading = true;
    notifyListeners();
    _trashRecords = await _repo.getDeletedRecords();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addRecord(SmRecord record) async {
    await _repo.addRecord(record);
    await loadRecordsByFolder(record.folderId);
  }

  Future<void> updateRecord(SmRecord record) async {
    await _repo.updateRecord(record);
    await loadRecordsByFolder(record.folderId);
  }

  Future<void> sendToTrash(SmRecord record) async {
    await _repo.sendRecordToTrash(record);
    await loadRecordsByFolder(record.folderId);
  }

  Future<void> restoreFromTrash(SmRecord record) async {
    await _repo.restoreRecordFromTrash(record);
    await loadTrash(); // Refresh the recycle bin view
  }

  Future<void> permaDelete(SmRecord record) async {
    await _repo.permaDeleteRecord(record);
    await loadTrash();
  }

  Future<List<SmRecord>> searchRecords(String query) async {
    if (query.trim().isEmpty) return [];
    return await _repo.searchRecords(query.trim());
  }
}
