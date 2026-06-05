import 'package:drift/drift.dart';

// DB v4: Move tags outside of SitemarkerRecords
class RecordTags extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}
