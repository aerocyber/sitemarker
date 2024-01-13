import 'dart:io';
import 'package:sitemarker/sitemarker_record.dart';

class InvalidUrlError implements Exception {
  /// Raised when the URL is invalid.
  String url;
  InvalidUrlError(this.url);

  @override
  String toString() {
    return "The URL $url is invalid";
  }
}

class RecordNotFoundException implements Exception {
  /// Raised when record is not found in various operations.
  String name;
  RecordNotFoundException(this.name);

  @override
  String toString() {
    return "Record with name: $name is not found in records.";
  }
}

class DuplicateRecordException implements Exception {
  /// Raised when the record is already present in various operations.
  SitemarkerRecord smr;
  DuplicateRecordException(this.smr);

  @override
  String toString() {
    return "There exist a record with name ${smr.name} or URL ${smr.url}";
  }
}

class InvalidOmioFileExcepion implements Exception {
  /// Raised when the .omio file is invalid.
  File omioFilePath;
  InvalidOmioFileExcepion(this.omioFilePath);

  @override
  String toString() {
    return "The file $omioFilePath is not a valid omio file.";
  }
}