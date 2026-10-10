import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/db/daos/folder_dao.dart';
import 'package:sitemarker/core/db/daos/records_dao.dart';
import 'package:sitemarker/core/logging/logger.dart';

class RecordsRepository {
  final RecordsDao _recordsDao;
  final FolderDao _folderDao;

  RecordsRepository(this._recordsDao, this._folderDao);

  /// Fetch active bookmarks
  Future<List<SmRecord>> getActiveRecords() async {
    LogManager.instance.log(
      LogLevel.debug,
      '[RECORDS REPO]: Fetching active records',
    );
    try {
      return await _recordsDao.getAllNonDeletedRecords();
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        '[RECORDS REPO]: Failed fetching active records: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Fetch bookmarks for a specific folder
  Future<List<SmRecord>> getRecordsByFolder(int folderId) async {
    LogManager.instance.log(
      LogLevel.debug,
      '[RECORDS REPO]: Fetching records for folder: $folderId',
    );
    try {
      return await _recordsDao.getAllNonDeletedRecordsInFolder(folderId);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        '[RECORDS REPO]: Failed to fetch records for folder $folderId: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Fetch bookmarks in trash
  Future<List<SmRecord>> getDeletedRecords() async {
    LogManager.instance.log(
      LogLevel.debug,
      '[RECORDS REPO]: Fetching deleted records',
    );
    try {
      return await _recordsDao.getAllDeletedRecords();
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        '[RECORDS REPO]: Failed fetching deleted records: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Insert a new bookmark
  Future<int> addRecord(SmRecord record) async {
    LogManager.instance.log(
      LogLevel.debug,
      '[RECORDS REPO]: Adding record: ${record.url}',
    );
    try {
      return await _recordsDao.addRecord(record);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        '[RECORDS REPO]: Failed to add record ${record.url}: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Update existing bookmark
  Future<bool> updateRecord(SmRecord record) async {
    LogManager.instance.log(
      LogLevel.debug,
      '[RECORDS REPO]: Updating record ID: ${record.id}',
    );
    try {
      return await _recordsDao.replaceRecordWithNew(record);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        '[RECORDS REPO]: Failed to update record ${record.id}: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Soft-delete an individual bookmark
  Future<bool> sendRecordToTrash(SmRecord record) async {
    LogManager.instance.log(
      LogLevel.debug,
      '[RECORDS REPO]: Sending record ${record.id} to trash',
    );
    try {
      return await _recordsDao.toggleSoftDeleteStatus(record);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        '[RECORDS REPO]: Failed deleting record ${record.id}: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Restore an individual bookmark with Orphan Protection
  /// If the target folder is deleted or missing, reassigns folderId to root (ID 1).
  Future<bool> restoreRecordFromTrash(SmRecord record) async {
    LogManager.instance.log(
      LogLevel.debug,
      '[RECORDS REPO]: Restoring record ID: ${record.id}',
    );
    try {
      int targetFolderId = record.folderId;

      // Verify parent folder status
      final parentFolder = await _folderDao.getFolderById(targetFolderId);
      if (parentFolder == null || parentFolder.isDeleted) {
        // Parent folder is unavailable -> Fall back to root (home = 1)
        targetFolderId = 1;
        LogManager.instance.log(
          LogLevel.warning,
          '[RECORDS REPO]: Parent folder $record.folderId for record ${record.id} is deleted/missing. Falling back to root (ID 1).',
        );
      }

      // Re-assign folder ID if changed, set isDeleted to false, and replace
      final updatedRecord = SmRecord(
        id: record.id,
        name: record.name,
        url: record.url,
        folderId: targetFolderId,
        isDeleted: false,
        dateAdded: record.dateAdded,
        dateModified: DateTime.now(),
        lastSynced: record.lastSynced,
        notes: record.notes,
        tags: record.tags,
      );

      return await _recordsDao.replaceRecordWithNew(updatedRecord);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        '[RECORDS REPO]: Failed restoring record ${record.id}: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Permanently wipe a record from DB
  Future<void> permaDeleteRecord(SmRecord record) async {
    LogManager.instance.log(
      LogLevel.debug,
      '[RECORDS REPO]: Permanently deleting record ID: ${record.id}',
    );
    try {
      await _recordsDao.permaDeleteRecord(record);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        '[RECORDS REPO]: Failed perma-deleting record ${record.id}: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Search for entry
  Future<List<SmRecord>> searchRecords(String query) async {
    LogManager.instance.log(
      LogLevel.debug,
      '[RECORDS REPO]: Searching for $query',
    );
    try {
      return await _recordsDao.searchActive(query);
    } catch (e) {
      LogManager.instance.log(
        LogLevel.error,
        '[RECORDS REPO]: Search failed: $e',
      );
      return [];
    }
  }

  Future<List<SmRecord>> searchAdvanced({
    String? nameQuery,
    String? urlQuery,
    List<String>? tags,
    int? folderId,
  }) async {
    LogManager.instance.log(
      LogLevel.debug,
      '[RECORDS REPO]: Executing advanced search via DAO',
    );
    try {
      return await _recordsDao.advancedSearch(
        nameQuery: nameQuery,
        urlQuery: urlQuery,
        tags: tags,
        folderId: folderId,
      );
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        '[RECORDS REPO]: Advanced search failed: $e\n$stack',
      );
      return [];
    }
  }
}
