import 'dart:convert';
import 'dart:io';
import 'package:validators/validators.dart' as validators;
import 'package:sitemarker/data/database/record_data_model.dart';
import 'package:sitemarker/core/errors.dart';

class OmioFile {
  /// All .omio file related operations are done via OmioFile.
  List<RecordDataModel> recordData = [];
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

        recordData.add(
          RecordDataModel(name: name, url: url, tags: tags),
        );
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
    Map? data;
    try {
      data = jsonDecode(omioString);
    } catch (e) {
      isValidJson = false;
    }

    if (isValidJson == false) {
      isValidOmio = false;
    }

    if ((data != null) || (isValidOmio == true)) {
      data?.forEach((key, value) {
        if (key is String) {
          if (value is Map) {
            if (value.containsKey("URL")) {
              if (value.containsKey("Categories")) {
                if (value["URL"] is String) {
                  if (value["Categories"] is List<String>) {
                    if (validators.isURL(value["URL"],
                            requireProtocol: false) ==
                        true) {
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

  void writeToOmioFile(RecordDataModel smrsToWrite) {
    /// Write records to .omio file.
    Map<String, dynamic> dat = {
      "Header": {"Omio Version": "3.0"},
      "Data": getDBAsMap(),
      "Footer": {"End of DB": 'true'}
    };

    File(omioFilePath).writeAsStringSync(dat.toString());
  }

  List<RecordDataModel> getAll() {
    return recordData;
  }

  Map<String, Map<String, String>> getDBAsMap() {
    Map<String, Map<String, String>> maps = {};

    List<RecordDataModel> recordsTemp = getAll();

    for (int i = 0; i < recordsTemp.length; i++) {
      maps[recordsTemp[i].name] = {
        "URL": recordsTemp[i].url,
        "Categories": recordsTemp[i].tags.toString()
      };
    }

    return maps;
  }
}
