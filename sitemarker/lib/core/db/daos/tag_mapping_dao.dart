import 'package:drift/drift.dart';
import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/db/tables/tag_mappings.dart';
import 'package:sitemarker/core/errors/db_error/mapping_not_found.dart';

part 'tag_mapping_dao.g.dart';

@DriftAccessor(tables: [TagMappings])
class TagMappingDao extends DatabaseAccessor<SitemarkerDB>
    with _$TagMappingDaoMixin {
  TagMappingDao(super.db);

  /// Get all tag mappings
  Future<List<TagMapping>> getAllTagMappings() {
    return select(tagMappings).get();
  }

  /// Get tag mapping by Id.
  /// If lookup fails, returns null
  Future<TagMapping?> getTagMappingById(int mappingId) {
    return (select(tagMappings)
          ..where((tagMapping) => tagMapping.id.equals(mappingId)))
        .getSingleOrNull();
  }

  /// Get tag mapping by tag id
  Future<List<TagMapping>> getTagMappingByTagId(int tagId) {
    return (select(
      tagMappings,
    )..where((tagMapping) => tagMapping.tagId.equals(tagId))).get();
  }

  /// Get tag mapping by bookmark id
  Future<List<TagMapping>> getTagMappingByBookmarkId(int bookmarkId) {
    return (select(
      tagMappings,
    )..where((tagMapping) => tagMapping.bookmarkId.equals(bookmarkId))).get();
  }

  /// Create tag id - bookmark id mapping.
  Future<int> createMapping(int tagId, int bookmarkId) {
    return into(tagMappings).insert(
      mode: InsertMode.insertOrIgnore,
      TagMappingsCompanion(bookmarkId: Value(bookmarkId), tagId: Value(tagId)),
    );
  }

  /// Delete mapping by mapping id.
  /// If mapping not found, raises `MappingNotFoundException`
  Future<int> deleteMapping(int mappingId) async {
    TagMapping? tagMapping = await getTagMappingById(mappingId);
    if (tagMapping == null) {
      throw MappingNotFoundException(mappingId: mappingId);
    }

    return delete(tagMappings).delete(tagMapping);
  }
}
