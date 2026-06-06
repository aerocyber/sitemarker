import 'package:drift/drift.dart';
import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/db/tables/record_tags.dart';
import 'package:sitemarker/core/errors/db_error/tag_not_found.dart';

part 'tags_dao.g.dart';

@DriftAccessor(tables: [RecordTags])
class TagsDao extends DatabaseAccessor<SitemarkerDB> with _$TagsDaoMixin {
  TagsDao(super.db);

  /// Get all tags
  /// This is a list of Tag Id : Tag Name mappings
  Future<List<Map<int, String>>> get getAllTags async => (await select(
    recordTags,
  ).get()).map((tag) => {tag.id: tag.name}).toList();

  /// Get tag by Id
  /// Returns null if not found
  Future<RecordTag?> getTagById(int tagId) async {
    return await (select(
      recordTags,
    )..where((tag) => tag.id.equals(tagId))).getSingleOrNull();
  }

  /// Change tag name
  /// Throws `TagNotFoundException` if tag is not found
  Future<bool> updateTag(int tagId, String newTagName) async {
    RecordTag? recordTagSearch = await getTagById(tagId);

    if (recordTagSearch == null) throw TagNotFoundException(id: tagId);

    return update(
      recordTags,
    ).replace(recordTagSearch.copyWith(name: newTagName));
  }

  /// Insert a new tag
  Future<int> addNewTag(String tagName) {
    return into(recordTags).insert(RecordTagsCompanion(name: Value(tagName)));
  }
}
