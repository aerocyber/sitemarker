import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:sitemarker/core/logging/logger.dart';

/// Connect to the db
DatabaseConnection connect() {
  return DatabaseConnection.delayed(
    Future(() async {
      final db = await WasmDatabase.open(
        databaseName: 'sitemarker-app',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );
      if (db.missingFeatures.isNotEmpty) {
        LogManager.instance.log(
          LogLevel.warning,
          'Using ${db.chosenImplementation} due to unsupported browser features: ${db.missingFeatures}',
        );
      }
      return db.resolvedExecutor;
    }),
  );
}
