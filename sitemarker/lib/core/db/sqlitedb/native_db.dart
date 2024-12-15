import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

/// Initialize the connection to db.
DatabaseConnection connect() {
  return DatabaseConnection.delayed(Future(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

      final cachebase = (await getTemporaryDirectory()).path;

      sqlite3.tempDirectory = cachebase;
    }

    return NativeDatabase.createBackgroundConnection(
      await getDatabaseFile,
    );
  }));
}

/// Get the db file.
Future<File> get getDatabaseFile async {
  final dbPath = await getPath();

  return File(dbPath);
}

/// Get the path to db file.
Future<String> getPath() async {
  String fileName = 'sitemarker';
  if (!kReleaseMode) fileName = 'sitemarker-debugdb';
  if (Platform.environment["XDG_DATA_HOME"] != null) {
    return File("${Platform.environment["XDG_DATA_HOME"]}/$fileName.db").path;
  } else if (Platform.environment['SNAP_USER_COMMON'] != null) {
    return File("${Platform.environment["SNAP_USER_COMMON"]}/$fileName.db")
        .path;
  } else {
    return File("${(await getApplicationSupportDirectory()).path}/$fileName.db")
        .path;
  }
}
