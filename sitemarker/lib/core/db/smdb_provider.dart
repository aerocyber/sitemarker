import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/core/db/sqlitedb/sm_db.dart';
import 'package:sitemarker/core/html_fns.dart';
import 'package:sitemarker/core/data_helper.dart';

/// Provider for all database and user data related activities
class SmdbProvider extends ChangeNotifier {
  // The db
  late SitemarkerDB db;
  // The records with isDeleted = false
  List<SitemarkerRecord> _records = [];
  // Getter for records with isDeleted = false
  List<SitemarkerRecord> get records => _records;
  // Soft deleted records
  List<SitemarkerRecord> deletedRecords = [];
  // All records
  List<SitemarkerRecord> allRecords = [];

  /// Load the values from db. Not to be called from outside the class
  void init() async {
    List<SitemarkerRecord> recs = await db.allRecords;
    for (int i = 0; i < recs.length; i++) {
      if (recs[i].isDeleted) {
        deletedRecords.add(recs[i]);
      } else {
        _records.add(recs[i]);
      }
    }
    allRecords = recs;
    notifyListeners();
  }

  SmdbProvider() {
    db = SitemarkerDB();
    init();
  }

  /// Get the default id to be used. Called internally.
  int getDefaultId() {
    if (_records.isNotEmpty) {
      return _records.last.id + 1;
    }
    return 0;
  }

  /// Add a new record
  void insertRecord(SmRecord record) async {
    final rec = SitemarkerRecord(
      id: getDefaultId(),
      name: record.name,
      url: record.url,
      tags: record.tags,
      isDeleted: false,
      dateAdded: record.dt,
    );
    _records.add(rec);
    db.insertRecord(rec);
    notifyListeners();
  }

  /// Soft delete a record
  void deleteRecord(SmRecord record) async {
    final rec = await db.getRecordsByName(record.name);
    db.toggleDelete(rec.first);
    deletedRecords.add(rec.first);
    _records.remove(rec.first);
    notifyListeners();
  }

  /// Update a record
  void updateRecord(SitemarkerRecord record) async {
    db.updateRecord(record);
    _records = await db.allRecords;
    notifyListeners();
  }

  /// Import from html
  importFromHTML() async {
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
      throw Exception('User cancelled');
    }

    File f = File(result.files.single.path!);

    try {
      recs = HtmlFns.fromHtml((await f.readAsString()));
    } on Exception {
      rethrow;
    }
    for (int i = 0; i < recs.length; i++) {
      if ((await db.getRecordsByName(recs[i].name)).isNotEmpty) {
        continue;
      } else if ((await db.getRecordsByURL(recs[i].url)).isNotEmpty) {
        continue;
      }
      SitemarkerRecord smr = SitemarkerRecord(
        id: getDefaultId(),
        name: recs[i].name,
        url: recs[i].url,
        tags: recs[i].tags,
        isDeleted: false,
        dateAdded: recs[i].dt,
      );
      _records.add(smr);
      await db.insertRecord(smr);
    }

    notifyListeners();
  }

  /// Export to html
  exportToHTML(List<SmRecord> exportingRecords) async {
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
      throw Exception('User cancelled');
    }

    String data = HtmlFns.toHtml(exportingRecords);
    File f = File(outFile);
    await f.writeAsString(data);

    notifyListeners();
  }

  // Implement import from omio file
  importFromOmioFile() async {
    List<SmRecord> recs;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['omio'],
      dialogTitle: 'Select an omio bookmarks file',
      allowMultiple: false,
      initialDirectory: (await getApplicationDocumentsDirectory()).path,
      lockParentWindow: true,
      type: FileType.custom,
    );
    if (result == null) {
      // User cancelled it
      throw Exception('User cancelled');
    }

    File f = File(result.files.single.path!);

    try {
      recs = DataHelper.fromOmio(await f.readAsString());
    } on Exception {
      rethrow;
    }
    for (int i = 0; i < recs.length; i++) {
      if ((await db.getRecordsByName(recs[i].name)).isNotEmpty) {
        continue;
      } else if ((await db.getRecordsByURL(recs[i].url)).isNotEmpty) {
        continue;
      }
      SitemarkerRecord smr = SitemarkerRecord(
        id: getDefaultId(),
        name: recs[i].name,
        url: recs[i].url,
        tags: recs[i].tags,
        isDeleted: false,
        dateAdded: recs[i].dt,
      );
      _records.add(smr);
      await db.insertRecord(smr);
    }

    notifyListeners();
  }

  // Implement export to omio file
  exportToOmioFile(List<SmRecord> recordsToExport) async {
    String? outFile = await FilePicker.platform.saveFile(
      allowedExtensions: ['omio'],
      dialogTitle: 'Please select an output file:',
      fileName: 'sitemarker-html-output-${DateTime.now().toString()}.omio',
      type: FileType.custom,
      lockParentWindow: true,
      initialDirectory: (await getDownloadsDirectory())!.path,
    );

    if (outFile == null) {
      // User cancelled the operation
      throw Exception('User cancelled');
    }

    String data = DataHelper.convertToOmio(recordsToExport);
    File f = File(outFile);
    await f.writeAsString(data);

    notifyListeners();
  }
}
