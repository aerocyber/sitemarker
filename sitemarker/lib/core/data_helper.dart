import 'package:sitemarker/core/html_fns.dart';
import 'package:validators/validators.dart' as validators;
import 'package:http/http.dart' as http;
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Class with methods aiding in various things related to data management
class DataHelper {
  /// Get the title of the HTML page which is pointed by the url
  static Future<String> getPageTitleFromURL(String url) async {
    if (!validators.isURL(url)) {
      throw Exception('Invalid URL');
    }

    String title = '';
    String respHttp = '';

    final Uri uri = Uri.parse(url);
    try {
      http.Response r = await http.get(uri);
      if (r.statusCode == 200) {
        respHttp = r.body;
        title = HtmlFns.getTitle(respHttp);
      } else if (r.statusCode >= 400 && r.statusCode < 500) {
        throw Exception('Client side request failed');
      }
    } on Exception {
      rethrow;
    }

    return title;
  }

  /// Convert a list of SmRecord to omio string
  static String convertToOmio(List<SmRecord> recordsToConvert) {
    Map<String, dynamic> omioMap = {};
    Map<String, String> omioHeader = {
      "Omio Version": "4.1.1",
      "Created On": DateTime.timestamp().toString()
    };
    int recCount = 0;
    Map<String, Map<String, String>> omioBody = {};

    for (int i = 0; i < recordsToConvert.length; i++) {
      recCount++;
      omioBody.addAll({
        recordsToConvert[i].name: {
          "URL": recordsToConvert[i].url,
          "Categories": recordsToConvert[i].tags,
          "Added On": recordsToConvert[i].dt.toString(),
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
      throw Exception('Invalid omio file');
    }
    if (sha256
            .convert(utf8.encode(json.encode(imported["Header"]!)))
            .toString() !=
        imported["Omio Info"]!["Header Hash"]!) {
      throw Exception('Invalid omio file. Hash mismatched');
    }
    if (sha256
            .convert(utf8.encode(json.encode(imported["Data"]!)))
            .toString() !=
        imported["Header"]!["Data Hash"]!) {
      throw Exception('Invalid omio file. Hash mismatched');
    }

    
    for (String key in imported["Data"]!.keys) {
      records.add(
        SmRecord(
          name: key,
          url: imported["Data"]![key]!["URL"]!,
          tags: imported["Data"]![key]!["categories"] ?? "",
          dt: DateTime.parse(imported["Data"]![key]!["Added On"]!),
        ),
      );
    }

    return records;
  }
}
