import 'package:flutter_test/flutter_test.dart';

import 'package:sitemarker/core/db/sm_db.dart';

// Import the Drift testing tools and your exact generated schema path
import 'package:drift_dev/api/migrations_native.dart';
import '../../generated_migrations_for_drift/schema.dart';
import '../../generated_migrations_for_drift/schema_v3.dart';

void main() {
  late SchemaVerifier verifier;

  setUpAll(() {
    // GeneratedHelper comes from your generated_migrations_for_drift/schema.dart
    verifier = SchemaVerifier(GeneratedHelper());
  });

  test('from3To4 Migration: 100,000 records migrate under 5 seconds', () async {
    const targetRecords = 100000;

    // 1. GET THE V3 SCHEMA BLUEPRINT
    // This allows us to generate multiple independent connections to the same shared RAM
    final schema = await verifier.schemaAt(3);

    // 2. OPEN V3, INSERT DATA, AND CLOSE
    final dbV3 = DatabaseAtV3(schema.newConnection());

    await dbV3.customStatement('''
      WITH RECURSIVE generate_data(x) AS (
         SELECT 1 UNION ALL SELECT x+1 FROM generate_data LIMIT $targetRecords
      )
      INSERT INTO sitemarker_records (name, url, date_added, date_modified, tags)
      SELECT 
        'Bookmark ' || x,
        'https://example.com/page' || x,
        strftime('%s', 'now'),
        strftime('%s', 'now'),
        CASE 
          WHEN x % 3 = 0 THEN 'flutter, drift, database' 
          WHEN x % 5 = 0 THEN 'rust, tauri, performance' 
          ELSE 'general' 
        END
      FROM generate_data;
    ''');

    // CRITICAL: We MUST close V3 so the connection lock is released.
    // Because we used schema.newConnection(), the data survives in shared RAM!
    await dbV3.close();

    // ---------------------------------------------------------
    // 3. OPEN V4 AND TRIGGER MIGRATION
    // ---------------------------------------------------------
    final stopwatch = Stopwatch()..start();

    // By giving V4 a brand new connection to the shared DB, Drift sees a
    // "freshly opened" state, checks the user_version, and FIRES from3To4!
    final dbV4 = SitemarkerDB(schema.newConnection());

    await verifier.migrateAndValidate(dbV4, 4);

    stopwatch.stop();

    // ---------------------------------------------------------
    // 4. BUDGET AND INTEGRITY ASSERTIONS
    // ---------------------------------------------------------
    final elapsedMs = stopwatch.elapsedMilliseconds;
    print('--- MIGRATION BENCHMARK RESULT ---');
    print('Processed $targetRecords records in: $elapsedMs ms');
    print(
      'Throughput: ${(targetRecords / (elapsedMs / 1000)).toStringAsFixed(0)} records/sec',
    );
    print('----------------------------------');

    expect(
      elapsedMs,
      lessThanOrEqualTo(5000),
      reason: 'Migration exceeded the 5-second performance budget.',
    );

    // Verify Row Integrity
    final recordCount = await dbV4
        .customSelect('SELECT COUNT(*) AS c FROM sitemarker_records')
        .getSingle();
    expect(recordCount.read<int>('c'), targetRecords);

    // Verify Core Folder Automation
    final folderCount = await dbV4
        .customSelect('SELECT COUNT(*) AS c FROM folder_records')
        .getSingle();
    expect(folderCount.read<int>('c'), 1);

    await dbV4.close();
  });
}
