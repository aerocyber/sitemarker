import 'dart:convert';

import 'package:sitemarker/sitemarker_record.dart';
import 'package:sitemarker/errors.dart';

class SitemarkerRecords {
  /// Sitemarker internal API implementation.
  List<SitemarkerRecord> smRecords = [];

  SitemarkerRecords(SitemarkerRecord? smr) {
    if (smr != null) {
      SitemarkerRecord? isFnd = search(smr.name, smr.url);

      if (isFnd != null) {
        throw DuplicateRecordException(smr);
      } else {
        smRecords.add(smr);
      }
    }
  }

  bool isValidUrl(String url) {
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
      SitemarkerRecord smrTmp = SitemarkerRecord(name, url, tags);
      smRecords.add(smrTmp);
    } else {
      throw DuplicateRecordException(SitemarkerRecord(name, url, tags));
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
}
