import 'dart:convert';

import 'package:sitemarker/operations/sitemarker_record.dart';
import 'package:sitemarker/operations/errors.dart';

class SitemarkerRecords {
  /// Sitemarker internal API implementation.
  List<SitemarkerRecord> smRecords = [];

  SitemarkerRecords();

  static bool isValidUrl(String url) {
    /// Check if URL is valid.
    try {
      Uri _ = Uri.dataFromString(url);
    } on InvalidUrlError {
      return false;
    }
    return true;
  }

  SitemarkerRecord? search(String name, String url) {
    /// Search for SitemarkerRecord with name and url known.
    SitemarkerRecord? smr;

    for (int i = 0; i < smRecords.length; i++) {
      if ((smRecords[i].name == name) || (smRecords[i].url == url)) {
        smr = smRecords[i];
      }
    }

    if (smr != null) {
      return smr;
    } else {
      return null;
    }
  }

  void addRecord(String name, String url, List<String> tags) {
    /// Add a new SitemarkerRecord.
    if (isValidUrl(url) == false) {
      throw InvalidUrlError(url);
    }
    SitemarkerRecord? smr = search(name, url);
    if (smr == null) {
      SitemarkerRecord smrTmp = SitemarkerRecord();
      smrTmp.setRecord(name, url, tags);
      smRecords.add(smrTmp);
    } else {
      SitemarkerRecord x = SitemarkerRecord();
      x.setRecord(name, url, tags);
      throw DuplicateRecordException(x);
    }
  }

  void deleteRecord(String name) {
    /// Delete a SitemarkerRecord.
    SitemarkerRecord? smr = getByName(name);

    if (smr != null) {
      smRecords.remove(smr);
    } else {
      throw RecordNotFoundException(name);
    }
  }

  SitemarkerRecord? getByName(String name) {
    /// Search for SitemarkerRecord with name known.
    SitemarkerRecord? smr;

    for (int i = 0; i < smRecords.length; i++) {
      if (smRecords[i].name == name) {
        smr = smRecords[i];
      }
    }

    if (smr != null) {
      return smr;
    } else {
      return null;
    }
  }

  String toJson() {
    /// Convert SitemarkerRecords to JSON for storing in .omio files.
    Map<String, Map<dynamic, dynamic>> map = {};
    for (int i = 0; i < smRecords.length; i++) {
      map[smRecords[i].name] = {
        "URL": smRecords[i].url,
        "Categories": smRecords[i].url
      };
    }
    return jsonEncode(map);
  }

  int length() {
    return smRecords.length;
  }

  List<SitemarkerRecord> getRecords() {
    return smRecords;
  }
}
