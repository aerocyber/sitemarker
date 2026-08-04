import 'package:flutter/foundation.dart';
import 'package:sitemarker/core/repos/folders_repo.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';

class FoldersProvier extends ChangeNotifier {
  final FoldersRepository _repo;
  FoldersProvier(this._repo);

  List<SmFolder> _rootFolders = [];
  List<SmFolder> get rootFolders => _rootFolders;

  List<SmFolder> _currentSubDirs = [];
  List<SmFolder> get currentSubDirs => _currentSubDirs;

  List<SmFolder> _trashFolders = [];
  List<SmFolder> get trashFolders => _trashFolders;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Helper function
  /// Toggles (updates) the loading state
  void toggleLoading() => _isLoading = !_isLoading;

  /// Load all root folders
  Future<void> loadRootFolders() async {
    toggleLoading();
    notifyListeners();
    _rootFolders = await _repo.getRootFolders();
    _isLoading = false;
    notifyListeners();
  }

  /// Load sub folders
  Future<void> loadSubFolders(int parentId) async {
    toggleLoading();
    notifyListeners();
    _currentSubDirs = await _repo.getSubfolders(parentId);
    toggleLoading();
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
  Future<void> createFolder(String name, {int? parentId}) async {
    await _repo.createFolder(name, parentId: parentId);

    if (parentId == null || parentId == 1) {
      await loadRootFolders();
    } else {
      await loadSubFolders(parentId);
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
    // Refresh to reflect the recursive removal
    if (folder.parentId == null || folder.parentId == 1) {
      await loadRootFolders();
    } else {
      await loadSubFolders(folder.parentId!);
    }
  }


  /// Undo soft delete
  Future<void> restoreFromTrash(SmFolder folder) async {
    await _repo.restoreFolderFromTrash(folder);
    await loadTrash();
    await loadRootFolders();
  }
}
