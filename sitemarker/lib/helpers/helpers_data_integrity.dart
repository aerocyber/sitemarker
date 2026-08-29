import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/core/providers/records_provider.dart';

class DataIntegrityHelpers {
  /// Checks if a folder with the same name already exists in the target parent directory.
  static bool isFolderNameDuplicate(
    String folderName,
    int parentId,
    FoldersProvider provider,
  ) {
    // If parentId is 1 (root), check rootFolders. Otherwise, check currentSubDirs.
    final targetList = parentId == 1
        ? provider.rootFolders
        : provider.currentSubDirs;

    return targetList.any(
      (f) => f.name.toLowerCase() == folderName.toLowerCase() && !f.isDeleted,
    );
  }

  /// Checks if a bookmark with the same name already exists in the target folder.
  /// The database strictly enforces UNIQUE(folder_id, name)[cite: 20].
  static bool isRecordNameDuplicate(
    String recordName,
    int folderId,
    RecordsProvider provider,
  ) {
    return provider.currentRecords.any(
      (r) => r.name.toLowerCase() == recordName.toLowerCase() && !r.isDeleted,
    );
  }

  /// Checks if a bookmark with the same URL already exists in the target folder.
  /// The database strictly enforces UNIQUE(folder_id, url).
  static bool isRecordUrlDuplicate(
    String url,
    int folderId,
    RecordsProvider provider,
  ) {
    return provider.currentRecords.any(
      (r) => r.url.toLowerCase() == url.toLowerCase() && !r.isDeleted,
    );
  }
}
