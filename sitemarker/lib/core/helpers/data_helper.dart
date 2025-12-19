import 'package:sitemarker/core/helpers/html_fns.dart';
import 'package:validators/validators.dart' as validators;
import 'package:http/http.dart' as http;
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Class with methods aiding in various things related to data management
class DataHelper {
  /// Get the title of the HTML page which is pointed by the url
  static Future<String?> getPageTitleFromURL(String url) async {
    if (!validators.isURL(url)) {
      // TODO: log it!
      throw Exception('Invalid URL');
    }

    final Uri uri = Uri.parse(url);
    try {
      http.Response r = await http.get(uri);
      if (r.statusCode == 200) {
        return HtmlFns.getTitle(r.body);
      } else if (r.statusCode >= 400 && r.statusCode < 500) {
        // TODO: Log it!
        return null;
      }
    } on Exception {
      // TODO: Log it!
      return null;
    }

    return null;
  }

  static String getTagStringFromList(List<String> tags) {
    String tag = "";
    for (String s in tags) {
      if (s.isNotEmpty) {
        tag += s;
      }
      if (tags.last == s) {
        tag += ',';
      }
    }

    return tag;
  }

  /// Convert a list of SmRecord to omio string
  static String convertToOmio(List<SmRecord> recordsToConvert) {
    Map<String, dynamic> omioMap = {};
    Map<String, String> omioHeader = {
      "Omio Version": "4.2",
      "Created On": DateTime.timestamp().toString()
    };
    int recCount = 0;
    Map<String, Map<String, String>> omioBody = {};

    for (int i = 0; i < recordsToConvert.length; i++) {
      recCount++;
      omioBody.addAll({
        recordsToConvert[i].name: {
          "URL": recordsToConvert[i].url,
          "Categories": getTagStringFromList(recordsToConvert[i].tags),
          "Added On": recordsToConvert[i].dateAdded.toString(),
          "Notes": recordsToConvert[i].notes ?? "",
        }
      });
    }

    omioHeader.addAll({
      "Record Count": recCount.toString(),
      "Data Hash":
          sha256.convert(utf8.encode(json.encode(omioBody))).toString(),
    });
    Map<String, String> omioFooter = {
      "Header Hash":
          sha256.convert(utf8.encode(json.encode(omioHeader))).toString(),
    };

    omioMap.addAll({
      "Header": omioHeader,
      "Data": omioBody,
      "Omio Info": omioFooter,
    });
    return json.encode(omioMap);
  }

  /// Convert omioString to a List of SmRecord
  static List<SmRecord> fromOmio(String omioString) {
    List<SmRecord> records = [];
    Map<String, dynamic> imported = json.decode(omioString);
    if (imported["Header"] == null ||
        imported["Omio Info"] == null ||
        imported["Data"] == null) {
      // TODO: Log it!
      throw Exception('Invalid omio file');
    }
    if (sha256
            .convert(utf8.encode(json.encode(imported["Header"]!)))
            .toString() !=
        imported["Omio Info"]!["Header Hash"]!) {
      // TODO: Log it!
      throw Exception('Invalid omio file. Hash mismatched');
    }
    if (sha256
            .convert(utf8.encode(json.encode(imported["Data"]!)))
            .toString() !=
        imported["Header"]!["Data Hash"]!) {
      // TODO: Log it!
      throw Exception('Invalid omio file. Hash mismatched');
    }

    for (String key in imported["Data"]!.keys) {
      for (String k in ["URL", "Categories", "Added On"]) {
        if (!((imported["Data"]![key]) as List).contains(k)) {
          // TODO: Log it!
          throw Exception("Invalid omio");
        }
      }
    }

    for (String key in imported["Data"]!.keys) {
      for (String k in ["URL", "Categories", "Added On"]) {
        if (!((imported["Data"]![key]) as List).contains(k)) {
          // TODO: Log it!
          throw Exception("Invalid omio");
        }
      }
      records.add(
        SmRecord(
          folderId: 1,
          notes: imported["Data"]![key]!["Notes"],
          name: key,
          url: imported["Data"]![key]!["URL"]!,
          tags: imported["Data"]![key]!["categories"] ?? "",
          dateAdded: DateTime.parse(imported["Data"]![key]!["Added On"]!),
          dateModified: DateTime.parse(imported["Data"]![key]!["Added On"]!),
        ),
      );
    }

    return records;
  }
}
