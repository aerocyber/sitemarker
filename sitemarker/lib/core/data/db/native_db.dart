import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:universal_io/io.dart';

DatabaseConnection connect() {
  return DatabaseConnection.delayed(
    Future(
      () async {
        if (Platform.isAndroid) {
          await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();

          final cachebase = (await getTemporaryDirectory()).path;

          sqlite3.tempDirectory = cachebase;
        }

        return NativeDatabase.createBackgroundConnection(
          await getDatabaseFile,
        );
      },
    ),
  );
}

Future<File> get getDatabaseFile async {
  final dbPath = await getPath();

  return File(dbPath);
}

Future<String> getPath() async {
  String fname = "sitemarker.db";
  if (kDebugMode) {
    fname = "sitemarker.debug.db";
  }
  if (Platform.environment["XDG_DATA_HOME"] != null) {
    return File("${Platform.environment["XDG_DATA_HOME"]}/$fname").path;
  } else if (Platform.environment["SNAP_USER_COMMON"] != null) {
    return File("${Platform.environment["SNAP_USER_COMMON"]}/$fname").path;
  } else {
    return File("${(await getApplicationSupportDirectory()).path}/$fname").path;
  }
}
