import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sitemarker/core/db/daos/folder_dao.dart';

import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/errors/db_error/folder_does_not_exist.dart';
import 'package:sitemarker/core/errors/db_error/id_cannot_be_null.dart';

void main() {
  late SitemarkerDB db;
  late FolderDao folderDao;

  // Runs before EVERY test to guarantee a completely clean slate
  setUp(() {
    db = SitemarkerDB(NativeDatabase.memory());
    folderDao = FolderDao(db);
  });

  // Runs after EVERY test to clear the RAM
  tearDown(() async {
    await db.close();
  });

  group('FolderDao - Creation & Retrieval', () {
    test('Can create a root folder and retrieve it by ID', () async {
      final newFolder = SmFolder(name: 'Work', parentId: null, isDeleted: false);

      final insertedId = await folderDao.createFolder(newFolder);
      final retrievedFolder = await folderDao.getFolderById(insertedId);

      expect(retrievedFolder, isNotNull);
      expect(retrievedFolder!.id, insertedId);
      expect(retrievedFolder.name, 'Work');
      expect(retrievedFolder.parentId, isNull);
      expect(retrievedFolder.isDeleted, isFalse);
    });

    test('Can create a nested subfolder', () async {
      // 1. Create the parent
      final parentId = await folderDao.createFolder(
        SmFolder(name: 'Tech', parentId: null, isDeleted: false),
      );

      // 2. Create the child
      final childId = await folderDao.createFolder(
        SmFolder(name: 'Flutter', parentId: parentId, isDeleted: false),
      );

      final childFolder = await folderDao.getFolderById(childId);
      expect(childFolder!.parentId, parentId);
      expect(childFolder.name, 'Flutter');
    });
  });

  group('FolderDao - Exceptions & Constraints', () {
    test('Throws FolderDoesNotExistException if parentId is invalid', () async {
      // Trying to attach a folder to parentId 999 (which doesn't exist)
      final ghostFolder = SmFolder(name: 'Ghost', parentId: 999, isDeleted: false);

      expect(
        () => folderDao.createFolder(ghostFolder),
        throwsA(isA<FolderDoesNotExistException>()),
      );
    });

    test(
      'SQLite UNIQUE constraint prevents duplicate folder names in the same parent directory',
      () async {
        final rootId = await folderDao.createFolder(
          SmFolder(name: 'Root', parentId: null, isDeleted: false),
        );

        // Insert the first valid subfolder
        await folderDao.createFolder(
          SmFolder(name: 'Duplicate', parentId: rootId, isDeleted: false),
        );

        // Attempting to insert the exact same name under the exact same parent should throw a SQLite Exception
        expect(
          () => folderDao.createFolder(
            SmFolder(name: 'Duplicate', parentId: rootId, isDeleted: false),
          ),
          throwsA(isException),
        );
      },
    );
  });

  group('FolderDao - Updates & Deletions', () {
    test('Can successfully rename a folder', () async {
      final folderId = await folderDao.createFolder(
        SmFolder(name: 'Old Name', parentId: null, isDeleted: false),
      );
      final folderToUpdate = await folderDao.getFolderById(folderId);

      final success = await folderDao.updateFolderById(
        folderToUpdate!,
        'New Name',
      );
      final updatedFolder = await folderDao.getFolderById(folderId);

      expect(success, isTrue);
      expect(updatedFolder!.name, 'New Name');
    });

    test('Throws IdCannotBeNullException on update if ID is missing', () async {
      final invalidFolder = SmFolder(
        name: 'Missing ID',
        parentId: null, isDeleted: false
      ); // ID is null by default

      expect(
        () => folderDao.updateFolderById(invalidFolder, 'New Name'),
        throwsA(isA<IdCannotBeNullException>()),
      );
    });

    test(
      'Soft delete accurately separates active and deleted folders',
      () async {
        // Create two folders
        final keepId = await folderDao.createFolder(
          SmFolder(name: 'Keep', parentId: null, isDeleted: false),
        );
        final trashId = await folderDao.createFolder(
          SmFolder(name: 'Trash', parentId: null, isDeleted: false),
        );

        final folderToTrash = await folderDao.getFolderById(trashId);

        // Soft delete the second folder
        await folderDao.toggleSoftDeleteFolderById(folderToTrash!);

        // Verify the filters work
        final activeFolders = await folderDao.getNonDeletedFolders();
        final deletedFolders = await folderDao.getDeletedFolders();

        expect(activeFolders.length, 1);
        expect(activeFolders.first.id, keepId);

        expect(deletedFolders.length, 1);
        expect(deletedFolders.first.id, trashId);
        expect(deletedFolders.first.isDeleted, isTrue);
      },
    );

    test('Permanent delete entirely removes the record from SQLite', () async {
      final folderId = await folderDao.createFolder(
        SmFolder(name: 'Temp', parentId: null, isDeleted: false),
      );
      final folderToDelete = await folderDao.getFolderById(folderId);

      await folderDao.permaDeleteFolderById(folderToDelete!);

      final ghostSearch = await folderDao.getFolderById(folderId);
      expect(ghostSearch, isNull);
    });
  });
}
