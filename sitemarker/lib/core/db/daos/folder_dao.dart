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

  /// Recursively soft-deletes or restores a folder, all its nested subfolders,
  /// and all contained bookmarks.
  /// Throws `IdCannotBeNullException` if folderInfo.id is null
  Future<void> setFolderDeletedStatus(
    SmFolder folderInfo,
    bool isDeleted,
  ) async {
    if (folderInfo.id == null) throw IdCannotBeNullException();

    final folderId = folderInfo.id!;

    await db.transaction(() async {
      await customUpdate(
        '''
        WITH RECURSIVE subfolders(id) AS (
          SELECT id FROM folder_records WHERE id = ?
          UNION ALL
          SELECT f.id FROM folder_records f
          INNER JOIN subfolders s ON f.parent_id = s.id
        )
        UPDATE folder_records
        SET is_deleted = ?
        WHERE id IN (SELECT id FROM subfolders);
        ''',
        variables: [Variable.withInt(folderId), Variable.withBool(isDeleted)],
        updates: {folderRecords},
      );

      await customUpdate(
        '''
        WITH RECURSIVE subfolders(id) AS (
          SELECT id FROM folder_records WHERE id = ?
          UNION ALL
          SELECT f.id FROM folder_records f
          INNER JOIN subfolders s ON f.parent_id = s.id
        )
        UPDATE sitemarker_records
        SET is_deleted = ?
        WHERE folder_id IN (SELECT id FROM subfolders);
        ''',
        variables: [Variable.withInt(folderId), Variable.withBool(isDeleted)],
        updates: {db.sitemarkerRecords},
      );
    });
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

    final newStatus = !folder.isDeleted;
    await setFolderDeletedStatus(folder, newStatus);
    return true;
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

  /// Recursively and permanently deletes a folder, its subfolders, and all contained bookmarks
  Future<void> wipeFolderTree(int folderId) async {
    await db.transaction(() async {
      // Destroy all nested bookmarks
      await customUpdate(
        '''
        WITH RECURSIVE subfolders(id) AS (
          SELECT id FROM folder_records WHERE id = ?
          UNION ALL
          SELECT f.id FROM folder_records f
          INNER JOIN subfolders s ON f.parent_id = s.id
        )
        DELETE FROM sitemarker_records
        WHERE folder_id IN (SELECT id FROM subfolders);
        ''',
        variables: [Variable.withInt(folderId)],
        updates: {db.sitemarkerRecords},
      );

      // Destroy the folders themselves
      await customUpdate(
        '''
        WITH RECURSIVE subfolders(id) AS (
          SELECT id FROM folder_records WHERE id = ?
          UNION ALL
          SELECT f.id FROM folder_records f
          INNER JOIN subfolders s ON f.parent_id = s.id
        )
        DELETE FROM folder_records
        WHERE id IN (SELECT id FROM subfolders);
        ''',
        variables: [Variable.withInt(folderId)],
        updates: {folderRecords},
      );
    });
  }
}
