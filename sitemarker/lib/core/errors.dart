import 'dart:io';
import 'package:sitemarker/data/database/record_data_model.dart';

class InvalidUrlError implements Exception {
  /// Raised when the URL is invalid.
  String url;
  InvalidUrlError(this.url);

  @override
  String toString() {
    return 'The URL $url is invalid';
  }
}

class RecordNotFoundException implements Exception {
  /// Raised when record is not found in various operations.
  String name;
  RecordNotFoundException(this.name);

  @override
  String toString() {
    return 'Record with name: $name is not found in records.';
  }
}

class DuplicateRecordException implements Exception {
  /// Raised when the record is already present in various operations.
  RecordDataModel rec;
  DuplicateRecordException(this.rec);

  @override
  String toString() {
    return 'There exist a record with name ${rec.name} or URL ${rec.url}';
  }
}

class InvalidOmioFileExcepion implements Exception {
  /// Raised when the .omio file is invalid.
  File omioFilePath;
  InvalidOmioFileExcepion(this.omioFilePath);

  @override
  String toString() {
    return 'The file $omioFilePath is not a valid omio file.';
  }
}

class CouldNotLaunchBrowserException implements Exception {
  /// Raised when URL could not be launched via browser
  String url;
  CouldNotLaunchBrowserException(this.url);

  @override
  String toString() {
    return "$url couldn't be launched via browser.";
  }
}
