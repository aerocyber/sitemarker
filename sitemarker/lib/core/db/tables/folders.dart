import 'package:drift/drift.dart';

// DB v4: Added Folders/Subfolders/record concept. This shifts the entire
// structure from record-only to dir-record based filesystem style structure
class FolderRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get parentId =>
      integer().nullable().references(FolderRecords, #id)();
  TextColumn get name => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  DateTimeColumn get dateAdded => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get dateModified =>
      dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get lastSynced => dateTime().nullable()();

  @override
  List<String> get customConstraints => ['UNIQUE(parent_id, name)'];
}
