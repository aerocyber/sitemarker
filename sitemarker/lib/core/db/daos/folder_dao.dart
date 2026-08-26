import 'package:drift/drift.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/db/tables/folders.dart';
import 'package:sitemarker/core/errors/db_error/folder_does_not_exist.dart';
import 'package:sitemarker/core/errors/db_error/id_cannot_be_null.dart';

part 'folder_dao.g.dart';

@DriftAccessor(tables: [FolderRecords])
class FolderDao extends DatabaseAccessor<SitemarkerDB> with _$FolderDaoMixin {
  FolderDao(super.db);

  /// Create a folder with folder information.
  /// The folder information is provided by folderInfo parameter
  /// `folderInfo.id` can be null or contain a value but will be ignored
  /// `folderInfo.name` cannot be null
  /// `folderInfo.parentId` can be null. If it is null, the folder will be a subfolder of the root otherwise of the folder corresponding to the parentId.
  /// Raises `FolderDoesNotExistException` if the provided `folderInfo.parentId` is found not to exist.
  Future<int> createFolder(SmFolder folderInfo) async {
    if (folderInfo.parentId != null &&
        (await getFolderById(folderInfo.parentId!) == null)) {
      throw FolderDoesNotExistException(parentId: folderInfo.parentId!);
    }
    return (await into(folderRecords).insert(
      FolderRecordsCompanion(
        name: Value(folderInfo.name),
        parentId: Value(folderInfo.parentId),
      ),
    ));
  }

  /// Get folder record (folder Id, name and parent id) based on the folder's id
  /// Returns `null` if not found.
  Future<SmFolder?> getFolderById(int folderId) async {
    FolderRecord? folderRecordById = await (select(
      folderRecords,
    )..where((f) => f.id.equals(folderId))).getSingleOrNull();

    if (folderRecordById == null) return null;

    return SmFolder.fromFolders(folderRecordById);
  }

  /// Get all folders which are not deleted
  /// Returns `null` if not found.
  Future<List<SmFolder>> getNonDeletedFolders() async {
    return (await (select(folderRecords)
              ..where((f) => f.isDeleted.equals(false) & f.id.equals(1).not()))
            .get())
        .map((folder) => SmFolder.fromFolders(folder))
        .toList();
  }

  /// Get all folders which are deleted
  /// Returns `null` if not found.
  Future<List<SmFolder>> getDeletedFolders() async {
    return (await (select(
          folderRecords,
        )..where((f) => f.isDeleted.equals(true))).get())
        .map((folder) => SmFolder.fromFolders(folder))
        .toList();
  }

  /// Permanently delete a folder by Id
  /// Throws `FolderDoesNotExistException` if not found
  /// Throws `IdCannotBeNullException` if folderInfo.id is null
  /// On success, returns `true`
  Future<int> permaDeleteFolderById(SmFolder folderInfo) async {
    if (folderInfo.id == null) throw IdCannotBeNullException();

    SmFolder? folder = await getFolderById(folderInfo.id!);

    if (folder == null) {
      throw FolderDoesNotExistException(parentId: folderInfo.id!);
    }

    return (await delete(folderRecords).delete(folder.toFolderRecord()));
  }

  /// Soft delete a folder by Id
  /// Throws `FolderDoesNotExistException` if not found
  /// Throws `IdCannotBeNullException` if folderInfo.id is null
  /// On success, returns `true`
  Future<bool> toggleSoftDeleteFolderById(SmFolder folderInfo) async {
    if (folderInfo.id == null) throw IdCannotBeNullException();

    SmFolder? folder = await getFolderById(folderInfo.id!);

    if (folder == null) {
      throw FolderDoesNotExistException(parentId: folderInfo.id!);
    }

    return (await update(
      folderRecords,
    ).replace(folder.toFolderRecord().copyWith(isDeleted: !folder.isDeleted)));
  }

  /// Update name of the folder by Id
  /// Throws `FolderDoesNotExistException` if not found
  /// Throws `IdCannotBeNullException` if folderInfo.id is null
  /// On success, returns `true`
  Future<bool> updateFolderById(SmFolder folderInfo, String newName) async {
    if (folderInfo.id == null) throw IdCannotBeNullException();

    SmFolder? folder = await getFolderById(folderInfo.id!);

    if (folder == null) {
      throw FolderDoesNotExistException(parentId: folderInfo.id!);
    }

    return (await update(
      folderRecords,
    ).replace(folder.toFolderRecord().copyWith(name: newName)));
  }
}
