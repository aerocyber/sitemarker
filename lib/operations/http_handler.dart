import 'dart:convert';

import 'package:http/http.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:encrypt/encrypt.dart';

class HttpHandler {
  final String baseUrl;
  late String authKey; // for authentication signature

  HttpHandler({
    required this.baseUrl,
  });

  List<SitemarkerRecord> _decryptData(String encryptedDta, String password) {
    List<SitemarkerRecord> smList = [];
    if (password.length > 32) {
      // error
      throw Exception(
          "Key length can be a maximum of 32"); // TODO: Implement this properly
    }
    return smList;
  }

  String _encryptData(List<SitemarkerRecord> smr, String password) {
    String encryptedData = '';
    String toEncrypt = json.encode(smr);
    if (password.length > 32) {
      // error
      throw Exception(
          "Key length can be a maximum of 32"); // TODO: Implement this properly
    }
    return encryptedData;
  }

  String httpGetDataFromDB() {
    String getResponse = '';
    return getResponse;
  }

  Map<String, dynamic> httpGetAuthResponse(Uri authUrl) {
    Map<String, dynamic> authResponse = {};
    return authResponse;
  }

  bool insertData(List<SitemarkerRecord> smr) {
    bool isSuccess = true;
    Uri urlEndpoint = Uri.parse(baseUrl + "/put"); // TODO: DOC
    // METHOD: POST
    return isSuccess;
  }

  bool isAuthSuccess() {
    bool isValid = true;
    return isValid;
  }
}
