import 'package:flutter/foundation.dart';
import 'package:sitemarker/core/logging/logger.dart';
import 'package:sitemarker/core/repos/folders_repo.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';

class FoldersProvider extends ChangeNotifier {
  final FoldersRepository _repo;
  FoldersProvider(this._repo);
  final log = LogManager.instance;

  List<SmFolder> _rootFolders = [];
  List<SmFolder> get rootFolders => _rootFolders;

  // List<SmFolder> _currentSubDirs = [];
  // List<SmFolder> get currentSubDirs => _currentSubDirs;

  final Map<int, List<SmFolder>> _subDirsCache = {};
  List<SmFolder> getSubDirs(int parentId) => _subDirsCache[parentId] ?? [];

  List<SmFolder> _trashFolders = [];
  List<SmFolder> get trashFolders => _trashFolders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Load all root folders
  Future<void> loadRootFolders() async {
    log.log(
      LogLevel.debug,
      '[FOLDER PROVIDER]: Received request for loadRootFolders',
    );
    try {
      if (_rootFolders.isEmpty) {
        _isLoading = true;
        notifyListeners();
      }

      _rootFolders = await _repo.getRootFolders();
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[FOLDER PROVIDER]: Failed to load root folders into state. Error: $e\n$stack',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load sub folders
  Future<void> loadSubFolders(int parentId) async {
    log.log(
      LogLevel.debug,
      '[FOLDER PROVIDER]: Received request for loadSubfolders',
    );

    try {
      if (!_subDirsCache.containsKey(parentId)) {
        _isLoading = true;
        notifyListeners();
      }

      _subDirsCache[parentId] = await _repo.getSubfolders(parentId);
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[FOLDER PROVIDER]: Failed to load subfolders into state. Error: $e\n$stack',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load trash
  Future<void> loadTrash() async {
    log.log(
      LogLevel.debug,
      '[FOLDER PROVIDER]: Received request for loadTrash',
    );
    try {
      _isLoading = true;
      notifyListeners();
      _trashFolders = await _repo.getDeletedFolders();
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[FOLDER PROVIDER]: Failed loading deleted folders to state. Error: $e\n$stack',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new folder
  Future<void> createFolder(SmFolder folder) async {
    log.log(
      LogLevel.debug,
      '[FOLDER PROVIDER]: Received request for createFolder',
    );
    try {
      await _repo.createFolder(folder);

      if (folder.parentId == null || folder.parentId == 1) {
        await loadRootFolders();
      } else {
        await loadSubFolders(folder.parentId!);
      }
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[FOLDER PROVIDER]: Failed creating folder. Error: $e\n$stack',
      );
    }
  }

  /// Rename folder
  Future<void> renameFolder(SmFolder folder, String newName) async {
    log.log(
      LogLevel.debug,
      '[FOLDER PROVIDER]: Received request for renameFolder',
    );
    try {
      await _repo.renameFolder(folder, newName);
      if (folder.parentId == null || folder.parentId == 1) {
        await loadRootFolders();
      } else {
        await loadSubFolders(folder.parentId!);
      }
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[FOLDER PROVIDER]: Failed to rename folder. Error: $e\n$stack',
      );
    }
  }

  /// Soft delete
  Future<void> sendToTrash(SmFolder folder) async {
    log.log(
      LogLevel.debug,
      '[FOLDER PROVIDER]: Received request to sendToTrash',
    );
    try {
      await _repo.sendFolderToTrash(folder);

      // Evict ONLY the deleted folder's cache so it doesn't take up memory
      log.log(
        LogLevel.debug,
        '[FOLDER PROVIDER]: Triggering removal of subdir cache',
      );
      _subDirsCache.remove(folder.id);

      // This naturally replaces the current entry for the parent, preserving nav history
      if (folder.parentId == null || folder.parentId == 1) {
        await loadRootFolders();
      } else {
        await loadSubFolders(folder.parentId!);
      }
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[FOLDER PROVIDER]: Failed to send record to trash. Error: $e\n$stack',
      );
    }
  }

  /// Undo soft delete
  Future<void> restoreFolderFromTrash(SmFolder folder) async {
    log.log(
      LogLevel.debug,
      '[FOLDER PROVIDER]: Received request for restoreFolderFromTrash',
    );
    try {
      _isLoading = true;
      notifyListeners();
      await _repo.restoreFolderFromTrash(folder);
      await loadTrash();

      if (folder.parentId == null || folder.parentId == 1) {
        await loadRootFolders();
      } else {
        await loadSubFolders(folder.parentId!);
      }
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[FOLDER PROVIDER]: Failed to restore folder from tash. Error: $e\n$stack',
      );
    }
  }

  /// Perma delete
  Future<void> permaDeleteFolder(SmFolder folder) async {
    log.log(
      LogLevel.debug,
      '[FOLDER PROVIDER]: Received request for permaDeleteFolder',
    );
    try {
      _isLoading = true;
      notifyListeners();
      await _repo.permaDeleteFolder(folder);
      log.log(LogLevel.debug, '[FOLDER PROVIDER]: Reload trash state');
      await loadTrash();
    } catch (e, stack) {
      log.log(
        LogLevel.error,
        '[FOLDER PROVIDER]: Failed to perma delete record. Error: $e\n$stack',
      );
    }
  }
}
