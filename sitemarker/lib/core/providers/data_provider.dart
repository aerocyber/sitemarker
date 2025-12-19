import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/helpers/dir_view_helper.dart';

class DataProvider extends ChangeNotifier {
  // The db
  late SitemarkerDB _db;

  // States
  int _currentFolderId = 1;
  List<Folder> _subfolders = [];
  List<SitemarkerRecord> _records = [];

  // For "back" button navigation.
  // Practically, it's a stack
  final List<int> _folderHistory = [];

  bool _isLoading = true;
  StreamSubscription? _subscription;

  // Getters for UI
  List<Folder> get subfolder => _subfolders;
  List<SitemarkerRecord> get records => _records;
  bool get isLoading => _isLoading;
  int get currentFolderId => _currentFolderId;
  bool get isRoot => _folderHistory.isEmpty;

  DataProvider() {
    init();
  }

  void init() {
    _db = SitemarkerDB();
    openFolder(1, addToHistory: false);
  }

  void openFolder(int folderId, {bool addToHistory = true}) {
    if (addToHistory && _currentFolderId != folderId) {
      _folderHistory.add(_currentFolderId);
    }

    _currentFolderId = folderId;
    _isLoading = true;
    notifyListeners();

    // Cancel old stream, start a new one
    _subscription?.cancel();

    _subscription = _db.watchDirectory(folderId).listen((DirView data) {
      _subfolders = data.subdirs;
      _records = data.records;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      // TODO: Log it!
      print("DB Error: $e");
      _isLoading = false;
      notifyListeners();
    });
  }

  bool navigateBack() {
    if (_folderHistory.isEmpty) return false;

    final previousFolderId = _folderHistory.removeLast();
    openFolder(previousFolderId, addToHistory: false);
    return true;
  }

  Future<void> addRecord(SmRecord record) async {
    _isLoading = true;
    notifyListeners();

    record.folderId = _currentFolderId;
    await _db.createRecordsWithTags(record: record);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> createFolder(String name) async {
    _isLoading = true;
    notifyListeners();
    await _db.into(_db.folders).insert(
          FoldersCompanion.insert(
            name: name,
            parentId: Value(_currentFolderId),
          ),
        );

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteRecord(SitemarkerRecord record) async {
    _isLoading = true;
    notifyListeners();

    await _db.softDelete(record);

    _isLoading = false;
    notifyListeners();
  }

  // TODO: Delete folder (feature update)

  @override
  void dispose() {
    _subscription?.cancel();
    _db.close();
    super.dispose();
  }

  Future<List<SmRecord>> getDeletedRecords() async {
    _isLoading = true;
    notifyListeners();

    final List<SmRecord> deletedRecords = [];
    for (SitemarkerRecord rec in _records) {
      if (rec.isDeleted) {
        final tags = (await _db.getAllTagsInRecord(rec.id)).map((t) => t.name)
            as List<String>;
        deletedRecords.add(SmRecord.fromSitemarkerRecord(rec, tags));
      }
    }
    _isLoading = false;
    notifyListeners();

    return deletedRecords;
  }

  Future<List<SmRecord>> getRecordsNotDeleted() async {
    _isLoading = true;
    notifyListeners();

    final List<SmRecord> __records = [];
    for (SitemarkerRecord rec in _records) {
      if (!(rec.isDeleted)) {
        final tags = (await _db.getAllTagsInRecord(rec.id)).map((t) => t.name)
            as List<String>;
        __records.add(SmRecord.fromSitemarkerRecord(rec, tags));
      }
    }
    _isLoading = false;
    notifyListeners();

    return __records;
  }
}
