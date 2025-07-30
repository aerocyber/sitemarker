import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
const platform = MethodChannel('io.github.aerocyber.sitemarker.files');

Future<void> saveFile(String content) async {
  final fileName =
      "Sitemarker-${DateTime.now().toIso8601String().replaceAll(RegExp(r'[:.]'), '-')}.omio";
  final encoded = utf8.encode(content);

  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt < 29) {
      final status = await Permission.storage.request();
      if (!status.isGranted) return;
    }

    try {
      await platform.invokeMethod('saveFile', {
        'name': fileName,
        'bytes': encoded,
      });
      return;
    } on PlatformException catch (e) {
      // print("Platform error while saving: ${e.message}");
      return;
    }
  }

  // Non-Android fallback
  String? r = await FilePicker.platform.saveFile(
    allowedExtensions: ['omio'],
    bytes: encoded,
    dialogTitle: "Select export location",
    fileName: fileName,
    lockParentWindow: true,
    type: FileType.custom,
  );
}

Future<String?> readFile() async {
  if (Platform.isAndroid) {
    final androidInfo = await deviceInfo.androidInfo;
    if (androidInfo.version.sdkInt < 29) {
      final status = await Permission.storage.request();
      if (!status.isGranted) return null;
    }

    try {
      final result = await platform.invokeMethod('readFile');
      if (result != null && result is String) {
        return result;
      }
    } on PlatformException catch (e) {
      print("Platform error while reading: ${e.message}");
    }
    return null;
  }

  FilePickerResult? r = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    allowedExtensions: ['omio'],
    dialogTitle: "Select the exported file",
    lockParentWindow: true,
    type: FileType.custom,
  );
  if (r == null) return null;
  return await File(r.files.single.path!).readAsString();
}
