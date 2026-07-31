import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/db/daos/folder_dao.dart';
import 'package:sitemarker/core/db/daos/records_dao.dart';
import 'package:sitemarker/core/logging/logger.dart';

class FoldersRepository {
  final FolderDao _folderDao;
  final RecordsDao _recordsDao;

  FoldersRepository(this._folderDao, this._recordsDao);

  /// Fetch all active folders
  Future<List<SmFolder>> getAllFolders() async {
    LogManager.instance.log(LogLevel.debug, 'Fetching all non-deleted folders');
    try {
      return await _folderDao.getNonDeletedFolders();
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to fetch folders: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Fetch root folders (parentId is null or home ID 1)
  Future<List<SmFolder>> getRootFolders() async {
    LogManager.instance.log(LogLevel.debug, 'Fetching root folders');
    try {
      final allFolders = await _folderDao.getNonDeletedFolders();
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

  /// Fetch folders in trash
  Future<List<SmFolder>> getDeletedFolders() async {
    LogManager.instance.log(LogLevel.debug, 'Fetching deleted folders');
    try {
      return await _folderDao.getDeletedFolders();
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed to fetch deleted folders: $e\n$stack',
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

  /// Recursive Soft-Delete
  /// Sends the folder, all nested subfolders, and all contained bookmarks to trash.
  Future<void> sendFolderToTrash(SmFolder folder) async {
    if (folder.id == null) return;
    LogManager.instance.log(
      LogLevel.info,
      'Recursively deleting folder ID: ${folder.id}',
    );

    try {
      // Soft delete this folder
      if (!folder.isDeleted) {
        await _folderDao.toggleSoftDeleteFolderById(folder);
      }

      // Soft delete all bookmarks directly inside this folder
      final recordsInFolder = await _recordsDao.getRecordByFolderId(folder.id!);
      for (final record in recordsInFolder) {
        if (!record.isDeleted) {
          await _recordsDao.toggleSoftDeleteStatus(record);
        }
      }

      // Find subfolders and recursively soft delete them
      final allFolders = await _folderDao.getNonDeletedFolders();
      final subfolders = allFolders.where((f) => f.parentId == folder.id);

      for (final subfolder in subfolders) {
        await sendFolderToTrash(subfolder);
      }
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed recursive delete on folder ${folder.id}: $e\n$stack',
      );
      rethrow;
    }
  }

  /// Recursive Restore with Parent Verification
  /// Restores a folder tree. If its original parent is deleted/missing, it falls back to root (ID 1).
  Future<void> restoreFolderFromTrash(SmFolder folder) async {
    if (folder.id == null) return;
    LogManager.instance.log(LogLevel.info, 'Restoring folder ID: ${folder.id}');

    try {
      // Check if parent folder exists and is active
      int? targetParentId = folder.parentId;
      if (targetParentId != null && targetParentId != 1) {
        final parentFolder = await _folderDao.getFolderById(targetParentId);
        if (parentFolder == null || parentFolder.isDeleted) {
          // Parent is gone or in trash -> re-attach to Root (home = 1)
          targetParentId = 1;
        }
      }

      // Restore folder state (and update parent ID if fallback occurred)
      if (folder.isDeleted || targetParentId != folder.parentId) {
        final updatedFolder = SmFolder(
          id: folder.id,
          name: folder.name,
          parentId: targetParentId,
          isDeleted: false,
        );
        await _folderDao.updateFolderById(updatedFolder, updatedFolder.name);
        if (folder.isDeleted) {
          await _folderDao.toggleSoftDeleteFolderById(folder);
        }
      }

      // Restore all bookmarks directly inside this folder
      final recordsInFolder = await _recordsDao.getRecordByFolderId(folder.id!);
      for (final record in recordsInFolder) {
        if (record.isDeleted) {
          await _recordsDao.toggleSoftDeleteStatus(record);
        }
      }

      // Find deleted subfolders and recursively restore them
      final deletedFolders = await _folderDao.getDeletedFolders();
      final subfolders = deletedFolders.where((f) => f.parentId == folder.id);

      for (final subfolder in subfolders) {
        await restoreFolderFromTrash(subfolder);
      }
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'Failed recursive restore on folder ${folder.id}: $e\n$stack',
      );
      rethrow;
    }
  }
}
