import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';


DatabaseConnection connect() {
    return DatabaseConnection.delayed(Future(() async {
        final db = await WasmDatabase.open(
            databaseName: 'sitemarker-app',
            sqlite3Uri: Uri.parse('sqlite3.wasm'),
            driftWorkerUri: Uri.parse('drift_worker.js'),
        );

        // if (db.missingFeatures.isNotEmpty) {
            // //For logging
        // }

        return db.resolvedExecutor;
    }));
}
