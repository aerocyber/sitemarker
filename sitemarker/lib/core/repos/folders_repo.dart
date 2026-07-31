import 'package:drift/drift.dart';
// Adjust these imports to match your actual file paths
import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/logging/logger.dart';

class FoldersRepository {
  final SitemarkerDB _db;

  FoldersRepository(this._db);

  /// Fetch all active folders
  Future<List<FolderRecord>> getAllFolders() async {
    LogManager.instance.log(LogLevel.debug, 'Fetching all active folders');
    try {
      return await (_db.select(
        _db.folderRecords,
      )..where((f) => f.isDeleted.equals(false))).get();
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to fetch folders: $e\n$stack',
      );
      throw Exception('Could not load folders.');
    }
  }

  /// Fetch only top-level root folders (where parentId is null)
  /// This keeps the initial app startup fast and lightweight.
  Future<List<FolderRecord>> getRootFolders() async {
    LogManager.instance.log(LogLevel.debug, 'Fetching root level folders');
    try {
      return await (_db.select(_db.folderRecords)
            ..where((f) => f.parentId.isNull())
            ..where((f) => f.isDeleted.equals(false)))
          .get();
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to fetch root folders: $e\n$stack',
      );
      throw Exception('Could not load root folders.');
    }
  }

  /// Fetch only the direct subfolders of a specific parent directory
  Future<List<FolderRecord>> getSubfolders(int parentId) async {
    LogManager.instance.log(
      LogLevel.debug,
      'Fetching subfolders for parent: $parentId',
    );
    try {
      return await (_db.select(_db.folderRecords)
            ..where((f) => f.parentId.equals(parentId))
            ..where((f) => f.isDeleted.equals(false)))
          .get();
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to fetch subfolders: $e\n$stack',
      );
      throw Exception('Could not load subfolders.');
    }
  }

  /// Create a new folder.
  /// Leave parentId null to create a folder at the root level.
  Future<int> createFolder(String name, {int? parentId}) async {
    LogManager.instance.log(
      LogLevel.info,
      'Creating folder: $name under parent: $parentId',
    );
    try {
      final newFolder = FolderRecordsCompanion.insert(
        name: name,
        parentId: Value(parentId),
        isDeleted: const Value(false),
      );

      // Returns the auto-incremented ID of the new folder
      return await _db.into(_db.folderRecords).insert(newFolder);
    } catch (e, stack) {
      // Handles the UNIQUE(parent_id, name) constraint failure
      LogManager.instance.log(
        LogLevel.error,
        'Failed to create folder $name: $e\n$stack',
      );
      throw Exception(
        'Failed to create folder. A folder with this name might already exist here.',
      );
    }
  }

  /// Rename a folder or move it to a new parent
  Future<void> updateFolder(int id, {String? newName, int? newParentId}) async {
    LogManager.instance.log(LogLevel.info, 'Updating folder $id');
    try {
      final update = FolderRecordsCompanion(
        name: newName != null ? Value(newName) : const Value.absent(),
        parentId: newParentId != null
            ? Value(newParentId)
            : const Value.absent(),
      );

      await (_db.update(
        _db.folderRecords,
      )..where((f) => f.id.equals(id))).write(update);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to update folder $id: $e\n$stack',
      );
      throw Exception('Failed to update folder.');
    }
  }

  /// Soft-delete a folder (sets isDeleted to true instead of wiping it from disk)
  /// Especially useful for future sync
  Future<void> deleteFolder(int id) async {
    LogManager.instance.log(LogLevel.info, 'Soft-deleting folder $id');
    try {
      final update = const FolderRecordsCompanion(isDeleted: Value(true));

      await (_db.update(
        _db.folderRecords,
      )..where((f) => f.id.equals(id))).write(update);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to delete folder $id: $e\n$stack',
      );
      throw Exception('Failed to delete the folder.');
    }
  }
}
