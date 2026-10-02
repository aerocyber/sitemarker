import 'package:flutter/foundation.dart';
import 'package:sitemarker/core/repos/folders_repo.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';

class FoldersProvider extends ChangeNotifier {
  final FoldersRepository _repo;
  FoldersProvider(this._repo);

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
    if (_rootFolders.isEmpty) {
      _isLoading = true;
      notifyListeners();
    }

    _rootFolders = await _repo.getRootFolders();

    _isLoading = false;
    notifyListeners();
  }

  /// Load sub folders
  Future<void> loadSubFolders(int parentId) async {
    if (!_subDirsCache.containsKey(parentId)) {
      _isLoading = true;
      notifyListeners();
    }

    _subDirsCache[parentId] = await _repo.getSubfolders(parentId);

    _isLoading = false;
    notifyListeners();
  }

  /// Load trash
  Future<void> loadTrash() async {
    _isLoading = true;
    notifyListeners();
    _trashFolders = await _repo.getDeletedFolders();
    _isLoading = false;
    notifyListeners();
  }

  /// Create a new folder
  Future<void> createFolder(SmFolder folder) async {
    await _repo.createFolder(folder);

    if (folder.parentId == null || folder.parentId == 1) {
      await loadRootFolders();
    } else {
      await loadSubFolders(folder.parentId!);
    }
  }

  /// Rename folder
  Future<void> renameFolder(SmFolder folder, String newName) async {
    await _repo.renameFolder(folder, newName);
    if (folder.parentId == null || folder.parentId == 1) {
      await loadRootFolders();
    } else {
      await loadSubFolders(folder.parentId!);
    }
  }

  /// Soft delete
  Future<void> sendToTrash(SmFolder folder) async {
    await _repo.sendFolderToTrash(folder);

    // Evict ONLY the deleted folder's cache so it doesn't take up memory
    _subDirsCache.remove(folder.id);

    // This naturally replaces the current entry for the parent, preserving nav history
    if (folder.parentId == null || folder.parentId == 1) {
      await loadRootFolders();
    } else {
      await loadSubFolders(folder.parentId!);
    }
  }

  /// Undo soft delete
  Future<void> restoreFolderFromTrash(SmFolder folder) async {
    _isLoading = true;
    notifyListeners();
    await _repo.restoreFolderFromTrash(folder);
    await loadTrash();

    if (folder.parentId == null || folder.parentId == 1) {
      await loadRootFolders();
    } else {
      await loadSubFolders(folder.parentId!);
    }
  }

  /// Perma delete
  Future<void> permaDeleteFolder(SmFolder folder) async {
    _isLoading = true;
    notifyListeners();
    await _repo.permaDeleteFolder(folder);
    await loadTrash();
  }
}
