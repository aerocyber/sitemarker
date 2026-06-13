import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sitemarker/core/db/daos/folder_dao.dart';
import 'package:sitemarker/core/db/daos/records_dao.dart';

import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/data_types/sm_folder.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';

void main() {
  late SitemarkerDB db;
  late RecordsDao recordsDao;
  late FolderDao folderDao;

  late int rootFolderId;

  setUp(() async {
    db = SitemarkerDB(NativeDatabase.memory());
    recordsDao = RecordsDao(db);
    folderDao = FolderDao(db);

    // Seed the database with a default folder because bookmarks REQUIRE a valid folder_id
    rootFolderId = await folderDao.createFolder(
      SmFolder(name: 'Root', parentId: null, isDeleted: false),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('RecordsDao - Creation & Retrieval', () {
    test('Can successfully insert a bookmark and retrieve it by ID', () async {
      final newRecord = SmRecord(
        id: null,
        notes: null,
        lastSynced: null,
        name: 'GitHub',
        url: 'https://github.com',
        folderId: rootFolderId,
        tags: [],
        dateAdded: DateTime.now(),
        dateModified: DateTime.now(),
        isDeleted: false,
      );

      final insertedId = await recordsDao.addRecord(newRecord);
      final retrievedRecords = await recordsDao.getRecordById(insertedId);

      expect(retrievedRecords.isNotEmpty, isTrue);
      expect(retrievedRecords.first.name, 'GitHub');
      expect(retrievedRecords.first.folderId, rootFolderId);
    });

    test('Can retrieve bookmarks by specific Folder ID', () async {
      // Insert one in Root
      await recordsDao.addRecord(
        SmRecord(
          id: null,
          notes: null,
          lastSynced: null,
          name: 'Root Bookmark',
          url: 'https://example.com',
          folderId: rootFolderId,
          tags: [],
          dateAdded: DateTime.now(),
          dateModified: DateTime.now(),
          isDeleted: false,
        ),
      );

      // Create a Subfolder and insert one there
      final subFolderId = await folderDao.createFolder(
        SmFolder(name: 'Sub', parentId: rootFolderId, isDeleted: false),
      );
      await recordsDao.addRecord(
        SmRecord(
          id: null,
          notes: null,
          lastSynced: null,
          name: 'Sub Bookmark',
          url: 'https://example.com/sub',
          folderId: subFolderId,
          tags: [],
          dateAdded: DateTime.now(),
          dateModified: DateTime.now(),
          isDeleted: false,
        ),
      );

      final rootBookmarks = await recordsDao.getRecordByFolderId(rootFolderId);
      final subBookmarks = await recordsDao.getRecordByFolderId(subFolderId);

      expect(rootBookmarks.length, 1);
      expect(rootBookmarks.first.name, 'Root Bookmark');

      expect(subBookmarks.length, 1);
      expect(subBookmarks.first.name, 'Sub Bookmark');
    });
  });

  group('RecordsDao - Tagging Integration', () {
    test('createRecordsWithTags correctly maps tags across tables', () async {
      final recordWithTags = SmRecord(
        id: null,
        notes: null,
        lastSynced: null,
        name: 'Flutter Docs',
        url: 'https://flutter.dev',
        folderId: rootFolderId,
        tags: ['flutter', 'dart', 'ui'],
        dateAdded: DateTime.now(),
        dateModified: DateTime.now(),
        isDeleted: false,
      );

      // We use the helper method from sm_db.dart that handles the transaction
      await db.createRecordsWithTags(record: recordWithTags);

      // Verify the tags were extracted and mapped
      final allRecords = await recordsDao.getAllRecords();
      expect(allRecords.length, 1);

      final savedTags = allRecords.first.tags;
      expect(savedTags.length, 3);
      expect(savedTags.contains('flutter'), isTrue);
      expect(savedTags.contains('dart'), isTrue);
      expect(savedTags.contains('ui'), isTrue);
    });
  });

  group('RecordsDao - Searching & Filtering', () {
    test('getRecordByName performs case-insensitive searches', () async {
      await recordsDao.addRecord(
        SmRecord(
          id: null,
          notes: null,
          lastSynced: null,
          name: 'StackOverflow',
          url: 'https://stackoverflow.com',
          folderId: rootFolderId,
          tags: [],
          dateAdded: DateTime.now(),
          dateModified: DateTime.now(),
          isDeleted: false,
        ),
      );

      // Searching for 'stack' should match 'StackOverflow'
      final searchResults = await recordsDao.getRecordByName('stack');
      expect(searchResults.length, 1);
      expect(searchResults.first.name, 'StackOverflow');
    });
  });

  group('RecordsDao - Soft Deletion & Purging', () {
    test('Toggle soft delete moves records to the trash bin', () async {
      final recordId = await recordsDao.addRecord(
        SmRecord(
          id: null,
          notes: null,
          lastSynced: null,
          name: 'Trash Me',
          url: 'https://trash.com',
          folderId: rootFolderId,
          tags: [],
          dateAdded: DateTime.now(),
          dateModified: DateTime.now(),
          isDeleted: false,
        ),
      );

      // Fetch the full SmRecord to toggle
      final record = (await recordsDao.getRecordById(recordId)).first;

      // Send to trash
      await recordsDao.toggleSoftDeleteStatus(record);

      final activeList = await recordsDao.getAllNonDeletedRecords();
      final deletedList = await recordsDao.getAllDeletedRecords();

      expect(activeList.isEmpty, isTrue);
      expect(deletedList.length, 1);
      expect(deletedList.first.name, 'Trash Me');
    });

    test(
      'purgeOldRecords physically deletes items sitting in the trash for 60+ days',
      () async {
        // 1. Create a record that was soft-deleted 65 days ago
        final oldDate = DateTime.now().subtract(const Duration(days: 65));

        await recordsDao.addRecord(
          SmRecord(
            id: null,
            notes: null,
            lastSynced: null,
            name: 'Ancient Trash',
            url: 'https://old.com',
            folderId: rootFolderId,
            tags: [],
            dateAdded: oldDate,
            dateModified: oldDate, // We check against dateModified
            isDeleted: true, // It is already in the trash
          ),
        );

        // 2. Create a record deleted yesterday (should NOT be purged)
        final recentDate = DateTime.now().subtract(const Duration(days: 1));
        await recordsDao.addRecord(
          SmRecord(
            id: null,
            notes: null,
            lastSynced: null,
            name: 'Recent Trash',
            url: 'https://new.com',
            folderId: rootFolderId,
            tags: [],
            dateAdded: recentDate,
            dateModified: recentDate,
            isDeleted: true,
          ),
        );

        // Run the Janitor
        await recordsDao.purgeOldRecords();

        // Verify what survived
        final remainingTrash = await recordsDao.getAllDeletedRecords();
        expect(remainingTrash.length, 1);
        expect(remainingTrash.first.name, 'Recent Trash');
      },
    );
  });
}
