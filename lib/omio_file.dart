import 'dart:convert';
import 'dart:io';
import 'package:sitemarker/sitemarker_data.dart';

class OmioFile {
  /// All .omio file related operations are done via OmioFile.
  SitemarkerRecords smr = SitemarkerRecords();
  late String omioFilePath;
  late File omioFile;

  OmioFile(this.omioFilePath);

  bool readOmioFile() {
    // /// Read omio file content and write value to SitemarkerRecords object smr
    // //String dat = omioFilePath.readAsStringSync(encoding: utf8);
    // bool isValid = isValidOmio(dat);
    // if (!isValid) {
    //   throw InvalidOmioFileExcepion(omioFilePath);
    // }
    // var data = jsonDecode(dat);
    // if (data != null) {
    //   data?.forEach((key, value) {
    //     String name = key;
    //     String url = value["URL"];
    //     List<String> tags = value["Categories"];

    //     smr.addRecord(name, url, tags);
    //   });
    // } else {
    //   return false;
    // }
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
                    if (smr.isValidUrl(value["URL"]) == true) {
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

  bool writeToOmioFile(SitemarkerRecords smrsToWrite) {
    // /// Write SitemarkerRecords to .omio file.
    // String dat = smrsToWrite.toJson();

    // var writer = omioFilePath.openWrite();
    // writer.write(dat);
    // writer.close();
    return true;
  }
}
