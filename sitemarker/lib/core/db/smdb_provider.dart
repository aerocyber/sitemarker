import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/core/db/sqlitedb/sm_db.dart';
import 'package:sitemarker/core/html_fns.dart';

class SmdbProvider extends ChangeNotifier {
  late SitemarkerDB db;
  List<SitemarkerRecord> _records = [];
  List<SitemarkerRecord> get records => _records;
  List<SitemarkerRecord> deletedRecords = [];
  List<SitemarkerRecord> allRecords = [];

  /// Load the values from db. Not to be called from ooutside the class
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
  int getDefualtId() {
    if (_records.isNotEmpty) {
      return _records.last.id + 1;
    }
    return 0;
  }

  void insertRecord(SmRecord record) async {
    final rec = SitemarkerRecord(
      id: getDefualtId(),
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

  void deleteRecord(SmRecord record) async {
    final rec = await db.getRecordsByName(record.name);
    db.softDelete(rec.first);
    deletedRecords.add(rec.first);
    _records.remove(rec.first);
    notifyListeners();
  }

  void updateRecord(SitemarkerRecord record) async {
    db.updateRecord(record);
    _records = await db.allRecords;
    notifyListeners();
  }

  // TODO: Implement import from html
  importFromHTML(String htmlFileLocation) async {
    File f = File(htmlFileLocation);

    if (!(await f.exists())) {
      throw Exception('File not found: $htmlFileLocation');
    }

    List<SmRecord> recs = HtmlFns.fromHtml((await f.readAsString()));
    for (int i = 0; i < recs.length; i++) {
      if ((await db.getRecordsByName(recs[i].name)).isNotEmpty) {
        continue;
      } else if ((await db.getRecordsByURL(recs[i].url)).isNotEmpty) {
        continue;
      }
      SitemarkerRecord smr = SitemarkerRecord(
        id: getDefualtId(),
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

  // TODO: Implement export to html
  exportToHTML(String htmlFileLocation) {}

  // TODO: Implement import from omio file
  importFromOmioFile(String omioFileLocation) {}

  // TODO: Implement export to omio file
  exportToOmioFile(String omioFileLocation) {}
}