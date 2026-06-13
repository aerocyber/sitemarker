import 'package:drift/drift.dart';
import 'package:sitemarker/core/db/tables/sitemarker_records.dart';
import 'package:sitemarker/core/db/tables/record_tags.dart';

// DB v4: Make tag-bookmark mapping into a separate table
class TagMappings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookmarkId => integer().references(
    SitemarkerRecords,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get tagId =>
      integer().references(RecordTags, #id, onDelete: KeyAction.cascade)();

  @override
  List<String> get customConstraints => ['UNIQUE(bookmark_id, tag_id)'];
}
