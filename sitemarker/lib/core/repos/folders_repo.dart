import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/db/daos/folder_dao.dart';
import 'package:sitemarker/core/logging/logger.dart';

class FoldersRepository {
  final FolderDao _folderDao;

  FoldersRepository(this._folderDao);

  /// Fetch ALL active (non-deleted) folders across the entire tree
  Future<List<SmFolder>> getAllFolders() async {
    LogManager.instance.log(LogLevel.debug, 'Fetching all non-deleted folders');
    try {
      return await _folderDao.getNonDeletedFolders();
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to fetch all folders: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Fetch ONLY top-level root folders for fast initial app startup.
  /// Root folders are defined as having parentId as null or pointing to home (ID 1).
  Future<List<SmFolder>> getRootFolders() async {
    LogManager.instance.log(
      LogLevel.debug,
      'Fetching root folders for initial startup',
    );
    try {
      final allFolders = await _folderDao.getNonDeletedFolders();

      // Filter in-memory to avoid adding a new SQL query to FolderDao for 4.0
      return allFolders
          .where((folder) => folder.parentId == null || folder.parentId == 1)
          .toList();
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to fetch root folders: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Fetch direct subfolders of a specific parent folder
  Future<List<SmFolder>> getSubfolders(int parentId) async {
    LogManager.instance.log(
      LogLevel.debug,
      'Fetching subfolders for parent: $parentId',
    );
    try {
      final allFolders = await _folderDao.getNonDeletedFolders();
      return allFolders.where((folder) => folder.parentId == parentId).toList();
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to fetch subfolders for $parentId: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Create new folder
  Future<int> createFolder(String name, {int? parentId}) async {
    LogManager.instance.log(
      LogLevel.info,
      'Creating folder: $name under parent: $parentId',
    );
    try {
      final folder = SmFolder(name: name, parentId: parentId, isDeleted: false);
      return await _folderDao.createFolder(folder);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to create folder $name: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Rename folder
  Future<bool> renameFolder(SmFolder folder, String newName) async {
    LogManager.instance.log(
      LogLevel.info,
      'Renaming folder ID ${folder.id} to $newName',
    );
    try {
      return await _folderDao.updateFolderById(folder, newName);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to rename folder: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Soft delete folder
  Future<bool> toggleSoftDelete(SmFolder folder) async {
    LogManager.instance.log(
      LogLevel.info,
      'Toggling soft delete on folder ID ${folder.id}',
    );
    try {
      return await _folderDao.toggleSoftDeleteFolderById(folder);
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to toggle delete on folder: $e\n$stack',
      );
      rethrow;
    }
  }
}
