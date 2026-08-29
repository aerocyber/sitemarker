import 'package:drift/drift.dart';
import 'package:sitemarker/core/db/tables/folders.dart';

class SitemarkerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get url => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();

  // DB v2: Added the dateAdded column
  DateTimeColumn get dateAdded => dateTime().withDefault(currentDateAndTime)();

  // DB v3: Added the dateModified column
  DateTimeColumn get dateModified =>
      dateTime().withDefault(currentDateAndTime)();

  // DB v4: Added the last synced column
  DateTimeColumn get lastSynced => dateTime().nullable()();

  // DB v4: Added the notes column
  TextColumn get notes => text().nullable()();

  // DB v4: Added the folderId column
  // 1 is root
  IntColumn get folderId =>
      integer().references(FolderRecords, #id).withDefault(const Constant(1))();

  @override
  List<String> get customConstraints => [
    'UNIQUE(folder_id, name)',
    'UNIQUE(folder_id, url)',
  ];
}
