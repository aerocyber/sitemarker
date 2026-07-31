import 'package:sitemarker/core/db/daos/tags_dao.dart';
import 'package:sitemarker/core/db/daos/tag_mapping_dao.dart';
import 'package:sitemarker/core/logging/logger.dart';

class TagsRepository {
  final TagsDao _tagsDao;
  final TagMappingDao _mappingDao;

  TagsRepository(this._tagsDao, this._mappingDao);

  /// Get all tags
  Future<List<Map<int, String>>> getAllTags() async {
    LogManager.instance.log(LogLevel.debug, 'Fetching all tags');
    try {
      return await _tagsDao.getAllTags;
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to fetch tags: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Create a new tag
  Future<int> createTag(String name) async {
    LogManager.instance.log(LogLevel.info, 'Creating new tag: $name');
    try {
      return await _tagsDao.addNewTag(name);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to create tag $name: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Rename an existing tag
  Future<bool> renameTag(int tagId, String newName) async {
    LogManager.instance.log(LogLevel.info, 'Renaming tag $tagId to $newName');
    try {
      return await _tagsDao.updateTag(tagId, newName);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to update tag $tagId: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Attach a tag to a bookmark record
  Future<int> attachTagToRecord(int tagId, int bookmarkId) async {
    LogManager.instance.log(
      LogLevel.info,
      'Mapping tag $tagId to bookmark $bookmarkId',
    );
    try {
      return await _mappingDao.createMapping(tagId, bookmarkId);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed mapping tag to bookmark: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Remove a tag-to-bookmark mapping
  Future<int> removeMapping(int mappingId) async {
    LogManager.instance.log(
      LogLevel.info,
      'Removing tag mapping ID: $mappingId',
    );
    try {
      return await _mappingDao.deleteMapping(mappingId);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed deleting mapping $mappingId: $e\n$stack',
      );
      rethrow;
    }
  }
}
