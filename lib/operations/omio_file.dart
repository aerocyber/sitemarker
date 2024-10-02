import 'dart:convert';
import 'dart:io';
import 'package:sitemarker/operations/errors.dart';
import 'package:sitemarker/operations/sitemarker_data.dart';
import 'package:sitemarker/operations/sitemarker_record.dart';

class OmioFile {
  /// All .omio file related operations are done via OmioFile.
  SitemarkerRecords smr = SitemarkerRecords();
  late String omioFilePath;

  OmioFile(this.omioFilePath);

  bool readOmioFile() {
    /// Read omio file content and write value to SitemarkerRecords object smr
    String dat = File(omioFilePath).readAsStringSync(encoding: utf8);
    bool isValid = isValidOmio(dat);
    if (!isValid) {
      throw InvalidOmioFileExcepion(File(omioFilePath));
    }
    var data = jsonDecode(dat);
    if (data != null) {
      data?.forEach((key, value) {
        String name = key;
        String url = value["URL"];
        List<String> tags = value["Categories"];

        smr.addRecord(name, url, tags);
      });
    } else {
      return false;
    }
    return true;
  }

  bool isValidOmio(String omioString) {
    /// Validate .omio file.
    bool isValidJson = true;
    bool isValidOmio = true;
    Map? json_;
    Map<dynamic, dynamic>? data;
    try {
      json_ = jsonDecode(omioString);
      data = json.decode(json_!["Data"]);
    } catch (e) {
      isValidJson = false;
    }

    if (isValidJson == false) {
      isValidOmio = false;
    }

    if ((json_ != null) || (isValidOmio == true) || (data == null)) {
      data!.forEach((key, value) {
        if (key is String) {
          if (value is Map) {
            if (value.containsKey("URL")) {
              if (value.containsKey("Categories")) {
                if (value["URL"] is String) {
                  if (value["Categories"] is List<String>) {
                    if (SitemarkerRecords.isValidUrl(value["URL"]) == true) {
                      isValidOmio = true;
                    } else {
                      isValidOmio = false;
                      return;
                    }
                  } else {
                    isValidOmio = false;
                    return;
                  }
                } else {
                  isValidOmio = false;
                  return;
                }
              } else {
                isValidOmio = false;
                return;
              }
            } else {
              isValidOmio = false;
              return;
            }
          } else {
            isValidOmio = false;
            return;
          }
        } else {
          isValidOmio = false;
          return;
        }
      });
    }

    return isValidOmio;
  }

  void writeToOmioFile(SitemarkerRecords smrsToWrite) {
    /// Write SitemarkerRecords to .omio file.
    Map<String, dynamic> head = {
      "Header": {
        "Omio Version": "3.0",
      }
    };
    Map<String, dynamic> footer = {
      "End of DB": true,
    };
    Map<String, String> dat = {
      "Data": smrsToWrite.toJson(),
    };

    Map<String, dynamic> toWrite = {};
    toWrite.addAll(head);
    toWrite.addAll(dat);
    toWrite.addAll(footer);

    File(omioFilePath).writeAsStringSync(
      json.encode(toWrite),
    );
    print(json.decode(json.encode(toWrite))["Data"].runtimeType);
  }

  List<SitemarkerRecord> getSmr() {
    return smr.getRecords();
  }
}
