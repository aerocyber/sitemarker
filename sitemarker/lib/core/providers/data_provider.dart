import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/file_io/file_servicer.dart';
import 'package:sitemarker/core/helpers/data_helper.dart';
import 'package:sitemarker/core/helpers/dir_view_helper.dart';
import 'package:sitemarker/core/helpers/html_fn_helper.dart';

class DataProvider extends ChangeNotifier {
  // The db
  late SitemarkerDB _db;

  // States
  int _currentFolderId = 1;
  List<Folder> _subfolders = [];
  List<SmRecord> _records = [];
  List<SmRecord> _globalDeletedRecords = [];

  // For "back" button navigation.
  // Practically, it's a stack
  final List<Map<int, String>> _folderHistory = [];

  bool _isLoading = true;
  StreamSubscription? _subscription;

  // Getters for UI
  List<Folder> get subfolder => _subfolders;
  List<SmRecord> get records => _records;
  bool get isLoading => _isLoading;
  int get currentFolderId => _currentFolderId;
  bool get isRoot => _folderHistory.isEmpty;
  List<SmRecord> get globalDeletedRecords => _globalDeletedRecords;
  List<SmRecord> get activeRecords =>
      _records.where((r) => r.isDeleted).toList();

  DataProvider() {
    init();
  }

  void init() {
    _db = SitemarkerDB();
    openFolder(1, addToHistory: false);
    getDeletedRecords();
  }

  void openFolder(int folderId, {bool addToHistory = true}) async {
    _isLoading = true;
    notifyListeners();

    String folderName = "Home";
    if (addToHistory && _currentFolderId != folderId) {
      if (_currentFolderId != 1) {
        final names = await _db.getFolderById(_currentFolderId);
        if (names.isNotEmpty) {
          folderName = names.first;
        }
      }

      _folderHistory.add({_currentFolderId: folderName});
    }

    _currentFolderId = folderId;

    // Cancel old stream, start a new one
    _subscription?.cancel();

    _subscription = _db.watchDirectory(folderId).listen((DirView data) async {
      _subfolders = data.subdirs;
      List<SmRecord> r = [];
      for (SitemarkerRecord rec in data.records) {
        var t =
            (await _db.getAllTagsInRecord(rec.id)).map((t) => t.name).toList();
        r.add(SmRecord.fromSitemarkerRecord(rec, t));
      }
      _records = r;
      _isLoading = false;
      notifyListeners();
    }, onError: (e) {
      // TODO: Log it!
      print("DB Error: $e");
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> undoSoftDelete(SmRecord record) async {
    _isLoading = true;
    notifyListeners();

    await _db.toggleDelete(record.toSitemarkerRecord());

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateRecord(SmRecord record) async {
    _isLoading = true;
    notifyListeners();

    await _db.updateRecord(record.toSitemarkerRecord());

    _isLoading = false;
    notifyListeners();
  }

  bool navigateBack() {
    if (_folderHistory.isEmpty) return false;

    final previousFolderId = _folderHistory.removeLast();
    openFolder(previousFolderId.keys.toList().last, addToHistory: false);
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

  Future<void> deleteRecord(SmRecord record) async {
    _isLoading = true;
    notifyListeners();

    await _db.softDelete(record.toSitemarkerRecord());

    _isLoading = false;
    notifyListeners();
  }

  // TODO: Delete folder (feature update)

  Future<void> getDeletedRecords() async {
    _isLoading = true;
    notifyListeners();

    final _deletedRecords = await _db.getDeletedRecords();
    final List<SmRecord> deletedRecords = [];

    for (SitemarkerRecord record in _deletedRecords) {
      final tags =
          (await _db.getAllTagsInRecord(record.id)).map((t) => t.name).toList();
      deletedRecords.add(SmRecord.fromSitemarkerRecord(record, tags));
    }

    _globalDeletedRecords = deletedRecords;
    _isLoading = false;
    notifyListeners();
  }

  Future<List<SmRecord>> getRecordsNotDeleted() async {
    _isLoading = true;
    notifyListeners();

    final List<SmRecord> __records = [];
    for (SmRecord rec in _records) {
      if (!(rec.isDeleted)) {
        __records.add(rec);
      }
    }
    _isLoading = false;
    notifyListeners();

    return __records;
  }

  /// Perma delete record
  // TODO: Implement perma delete with safety logs for sync
  void deleteRecordPermanently(SmRecord record) async {
    _isLoading = true;
    notifyListeners();

    await _db.hardDelete(record.toSitemarkerRecord());
    _isLoading = false;
    notifyListeners();
  }

  Future<void> exportToOmioFile(List<SmRecord> recordsToExport) async {
    _isLoading = true;
    notifyListeners();

    await saveFile(DataHelper.convertToOmio(recordsToExport));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> importFromHTML() async {
    _isLoading = true;
    notifyListeners();
    List<SmRecord> recs;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['html', 'htm'],
      dialogTitle: 'Select a HTML bookmarks file',
      allowMultiple: false,
      initialDirectory: (await getApplicationDocumentsDirectory()).path,
      lockParentWindow: true,
      type: FileType.custom,
    );

    if (result == null) {
      // User cancelled it
      _isLoading = false;
      notifyListeners();
      return;
    }

    File f = File(result.files.single.path!);

    try {
      recs = HtmlFns.fromHtml((await f.readAsString()));

      final folderId = await _db.createFolder(
          "Imported-from-HTML-ON-${DateTime.now().toIso8601String()}");

      for (int i = 0; i < recs.length; i++) {
        recs[i].folderId = folderId;
        await _db.createRecordsWithTags(record: recs[i]);
      }
    } on Exception {
      // TODO: Log it!
      _isLoading = false;
      notifyListeners();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> exportToHTML(List<SmRecord> exportingRecords) async {
    _isLoading = true;
    notifyListeners();

    String? outFile = await FilePicker.platform.saveFile(
      allowedExtensions: ['html'],
      dialogTitle: 'Please select an output file:',
      fileName: 'sitemarker-html-output-${DateTime.now().toString()}.html',
      type: FileType.custom,
      lockParentWindow: true,
      initialDirectory: (await getDownloadsDirectory())!.path,
    );

    if (outFile == null) {
      // User cancelled the operation
      // TODO: Log it!
      _isLoading = false;
      notifyListeners();
    }

    String data = HtmlFns.toHtml(exportingRecords);
    File f = File(outFile!);
    await f.writeAsString(data);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> importFromOmioFile() async {
    _isLoading = true;
    notifyListeners();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ["omio"],
      dialogTitle: "Select omio file",
      allowMultiple: false,
      initialDirectory: (await getApplicationDocumentsDirectory()).path,
      lockParentWindow: true,
      type: FileType.custom,
    );

    if (result == null) {
      // User cancelled the operation
      // TODO: Log it!
      _isLoading = false;
      notifyListeners();
      return;
    }

    File f = File(result.files.single.path!);
    if (!f.existsSync()) {
      // File exists.
      // TODO: Log it!
      _isLoading = false;
      notifyListeners();
      throw FileSystemException("File not found");
    }

    try {
      List<SmRecord> recordsToImport =
          DataHelper.fromOmio(await f.readAsString());

      for (SmRecord rec in recordsToImport) {
        rec.folderId = _currentFolderId;
        await _db.createRecordsWithTags(record: rec);
      }
    } catch (e) {
      // Error with omio file
      _isLoading = false;
      notifyListeners();
      throw Exception("Invalid omio file");
    }

    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _db.close();
    super.dispose();
  }
}
