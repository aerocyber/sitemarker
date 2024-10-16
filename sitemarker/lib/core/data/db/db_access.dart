import 'package:drift/drift.dart';
import 'package:sitemarker/core/data/db/shared_db.dart' as impl;

part 'db_access.g.dart';

class SitemarkerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get url => text()();
  TextColumn get tags => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [SitemarkerRecords])
