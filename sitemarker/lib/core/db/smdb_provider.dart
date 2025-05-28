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
  // Duplicate records as part of import
  List<SmRecord> _importDups = [];
  // Getter for dups
  List<SmRecord> get importDups => _importDups;
  // Counter for successful imports
  int _successImport = 0;
  // Getter for successful imports
  int get successImport => _successImport;

  /// Load the values from db. Not to be called from outside the class
  void init() async {
    await populate();
    notifyListeners();
  }

  SmdbProvider() {
    db = SitemarkerDB();
    init();
  }

  populate() async {
    allRecords = await db.allRecords;
    _records =
        allRecords.where((element) => element.isDeleted == false).toList();
    deletedRecords =
        allRecords.where((element) => element.isDeleted == true).toList();
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
    await db.insertRecord(rec);
    populate();
    notifyListeners();
  }

  /// toggle delete a record
  void toggleDeleteRecord(SmRecord record) async {
    final rec = await db.getRecordsByName(record.name);
    db.toggleDelete(rec.first);
    populate();
    notifyListeners();
  }

  /// Soft delete a record
  void softDeleteRecord(SmRecord record) async {
    final rec = await db.getRecordsByName(record.name);
    await db.softDelete(rec.first);
    populate();
    notifyListeners();
  }

  /// Update a record
  void updateRecord(SmRecord record) async {
    await db.updateRecord(SitemarkerRecord(
      id: record.id!,
      name: record.name,
      url: record.url,
      tags: record.tags,
      isDeleted: record.isDeleted!,
      dateAdded: record.dt,
    ));
    populate();
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
    populate();
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
  // THIS IS THE CORRECTED CODE FOR SmdbProvider.importFromOmioFile
// Please use this version
  importFromOmioFile(File f) async {
    List<SmRecord> recs;

    try {
      recs = DataHelper.fromOmio(await f.readAsString());
    } on Exception {
      rethrow;
    }

    _importDups = [];
    _successImport = 0;

    // Use a Set to track duplicate records encountered in the current batch
    // This prevents adding the same conceptual duplicate multiple times to _importDups
    Set<String> uniqueDuplicateKeys = {};

    for (int i = 0; i < recs.length; i++) {
      final currentRecord = recs[i];
      // A key for the current record, useful for the Set. Trim to handle whitespace.
      final recordKey =
          '${currentRecord.name.trim()}-${currentRecord.url.trim()}';

      // Check if a record with the same name exists in the database
      final dbRecordsByName = await db.getRecordsByName(currentRecord.name);
      // Check if a record with the same URL exists in the database
      final dbRecordsByURL = await db.getRecordsByURL(currentRecord.url);

      // If ANY database duplicate is found (by name OR by URL)
      if (dbRecordsByName.isNotEmpty || dbRecordsByURL.isNotEmpty) {
        // This record is a duplicate against the database.
        // Now, check if we've already added this *specific duplicate* to our _importDups list in this batch.
        if (!uniqueDuplicateKeys.contains(recordKey)) {
          _importDups.add(currentRecord);
          uniqueDuplicateKeys
              .add(recordKey); // Mark as added to the duplicates list
        }
        // Do NOT increment _successImport or insert into DB if it's a duplicate
      } else {
        // This record is NOT a duplicate in the database, so import it
        _successImport++;
        SitemarkerRecord smr = SitemarkerRecord(
          id: getDefaultId(), // Ensure this generates a unique ID
          name: currentRecord.name,
          url: currentRecord.url,
          tags: currentRecord.tags,
          isDeleted: false,
          dateAdded: currentRecord.dt,
        );
        _records.add(
            smr); // Add to in-memory list (if _records is your main data source)
        await db.insertRecord(smr); // Insert into the database
      }
    }

    populate();
    notifyListeners();
    // print(
    //     "ImportDups: $_importDups"); // Now this should correctly show duplicates
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

  /// Get all the records as a List of SmRecord
  List<SmRecord> getAllRecords() {
    return allRecords
        .map(
          (e) => SmRecord(
            id: e.id,
            name: e.name,
            url: e.url,
            dt: e.dateAdded,
            tags: e.tags,
          ),
        )
        .toList();
  }

  /// Get all the undeleted records as a List of SmRecord
  List<SmRecord> getAllUndeletedRecords() {
    return _records
        .map(
          (e) => SmRecord(
            id: e.id,
            name: e.name,
            url: e.url,
            dt: e.dateAdded,
            tags: e.tags,
          ),
        )
        .toList();
  }

  /// Get all the undeleted records as a List of SmRecord
  List<SmRecord> getAllDeletedRecords() {
    return deletedRecords
        .map(
          (e) => SmRecord(
            id: e.id,
            name: e.name,
            url: e.url,
            dt: e.dateAdded,
            tags: e.tags,
          ),
        )
        .toList();
  }

  /// Perma delete record
  void deleteRecordPermanently(SmRecord record) async {
    final rec = await db.getRecordsByName(record.name);
    db.hardDelete(rec.first);
    populate();
    notifyListeners();
  }
}
