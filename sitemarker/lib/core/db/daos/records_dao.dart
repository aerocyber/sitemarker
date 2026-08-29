import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:sitemarker/core/data_types/sm_record.dart';
import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/db/tables/sitemarker_records.dart';
import 'package:sitemarker/core/db/daos/tag_mapping_dao.dart';
import 'package:sitemarker/core/db/daos/tags_dao.dart';

part 'records_dao.g.dart';

@DriftAccessor(tables: [SitemarkerRecords])
class RecordsDao extends DatabaseAccessor<SitemarkerDB> with _$RecordsDaoMixin {
  RecordsDao(super.db);

  /// Get all records
  Future<List<SmRecord>> getAllRecords() async {
    TagMappingDao tagMappingDao = TagMappingDao(db);
    TagsDao tagsDao = TagsDao(db);

    List<SitemarkerRecord> records = await select(sitemarkerRecords).get();
    List<SmRecord> finalRecords = [];

    for (SitemarkerRecord record in records) {
      List<TagMapping> tagMapping = await tagMappingDao
          .getTagMappingByBookmarkId(record.id);

      List<String> tags = [];

      for (TagMapping mapping in tagMapping) {
        var tag = await tagsDao.getTagById(mapping.tagId);
        if (tag != null) tags.add(tag.name);
      }

      finalRecords.add(SmRecord.fromSitemarkerRecord(record, tags));
    }

    return finalRecords;
  }

  /// Get all deleted records
  Future<List<SmRecord>> getAllDeletedRecords() async {
    TagMappingDao tagMappingDao = TagMappingDao(db);
    TagsDao tagsDao = TagsDao(db);

    List<SitemarkerRecord> records = await (select(
      sitemarkerRecords,
    )..where((rec) => rec.isDeleted.equals(true))).get();
    List<SmRecord> finalRecords = [];

    for (SitemarkerRecord record in records) {
      List<TagMapping> tagMapping = await tagMappingDao
          .getTagMappingByBookmarkId(record.id);

      List<String> tags = [];

      for (TagMapping mapping in tagMapping) {
        var tag = await tagsDao.getTagById(mapping.tagId);
        if (tag != null) tags.add(tag.name);
      }

      finalRecords.add(SmRecord.fromSitemarkerRecord(record, tags));
    }

    return finalRecords;
  }

  /// Get all non deleted records
  Future<List<SmRecord>> getAllNonDeletedRecords() async {
    TagMappingDao tagMappingDao = TagMappingDao(db);
    TagsDao tagsDao = TagsDao(db);

    List<SitemarkerRecord> records = await (select(
      sitemarkerRecords,
    )..where((rec) => rec.isDeleted.equals(false))).get();
    List<SmRecord> finalRecords = [];

    for (SitemarkerRecord record in records) {
      List<TagMapping> tagMapping = await tagMappingDao
          .getTagMappingByBookmarkId(record.id);

      List<String> tags = [];

      for (TagMapping mapping in tagMapping) {
        var tag = await tagsDao.getTagById(mapping.tagId);
        if (tag != null) tags.add(tag.name);
      }

      finalRecords.add(SmRecord.fromSitemarkerRecord(record, tags));
    }

    return finalRecords;
  }

  /// Get record by id
  Future<List<SmRecord>> getRecordById(int recordId) async {
    TagMappingDao tagMappingDao = TagMappingDao(db);
    TagsDao tagsDao = TagsDao(db);

    List<SitemarkerRecord> records = await (select(
      sitemarkerRecords,
    )..where((rec) => rec.id.equals(recordId))).get();
    List<SmRecord> finalRecords = [];

    for (SitemarkerRecord record in records) {
      List<TagMapping> tagMapping = await tagMappingDao
          .getTagMappingByBookmarkId(record.id);

      List<String> tags = [];

      for (TagMapping mapping in tagMapping) {
        var tag = await tagsDao.getTagById(mapping.tagId);
        if (tag != null) tags.add(tag.name);
      }

      finalRecords.add(SmRecord.fromSitemarkerRecord(record, tags));
    }

    return finalRecords;
  }

  /// Get record by name
  Future<List<SmRecord>> getRecordByName(String name) async {
    String lowerName = name.toLowerCase();
    TagMappingDao tagMappingDao = TagMappingDao(db);
    TagsDao tagsDao = TagsDao(db);

    List<SitemarkerRecord> records = await (select(
      sitemarkerRecords,
    )..where((rec) => rec.name.lower().contains(lowerName))).get();
    List<SmRecord> finalRecords = [];

    for (SitemarkerRecord record in records) {
      List<TagMapping> tagMapping = await tagMappingDao
          .getTagMappingByBookmarkId(record.id);

      List<String> tags = [];

      for (TagMapping mapping in tagMapping) {
        var tag = await tagsDao.getTagById(mapping.tagId);
        if (tag != null) tags.add(tag.name);
      }

      finalRecords.add(SmRecord.fromSitemarkerRecord(record, tags));
    }

    return finalRecords;
  }

  /// Get records by folderId
  Future<List<SmRecord>> getRecordByFolderId(int folderId) async {
    TagMappingDao tagMappingDao = TagMappingDao(db);
    TagsDao tagsDao = TagsDao(db);

    List<SitemarkerRecord> records = await (select(
      sitemarkerRecords,
    )..where((rec) => rec.folderId.equals(folderId))).get();
    List<SmRecord> finalRecords = [];

    for (SitemarkerRecord record in records) {
      List<TagMapping> tagMapping = await tagMappingDao
          .getTagMappingByBookmarkId(record.id);

      List<String> tags = [];

      for (TagMapping mapping in tagMapping) {
        var tag = await tagsDao.getTagById(mapping.tagId);
        if (tag != null) tags.add(tag.name);
      }

      finalRecords.add(SmRecord.fromSitemarkerRecord(record, tags));
    }

    return finalRecords;
  }

  /// Insert record
  Future<int> addRecord(SmRecord record) {
    return into(sitemarkerRecords).insert(
      SitemarkerRecordsCompanion(
        dateAdded: Value(record.dateAdded),
        dateModified: Value(record.dateModified),
        folderId: Value(record.folderId),
        isDeleted: Value(record.isDeleted),
        lastSynced: Value(record.lastSynced),
        name: Value(record.name),
        notes: Value(record.notes),
        url: Value(record.url),
      ),
    );
  }

  /// Edit record
  /// Throws `InvalidDataException` if record.id is null
  Future<bool> replaceRecordWithNew(SmRecord record) {
    if (record.id == null) {
      throw InvalidDataException(
        "The record cannot have an id of null for this operation",
      );
    }

    return update(sitemarkerRecords).replace(record.toSitemarkerRecord());
  }

  /// Toggle record deletion state
  /// Throws `InvalidDataException` if record.id is null
  Future<bool> toggleSoftDeleteStatus(SmRecord record) {
    if (record.id == null) {
      throw InvalidDataException(
        "The record cannot have id of null for this operation",
      );
    }

    return update(sitemarkerRecords).replace(
      record.toSitemarkerRecord().copyWith(isDeleted: !record.isDeleted),
    );
  }

  /// Permanently delete a record
  /// Throws `InvalidDataException` if record.id is null
  Future permaDeleteRecord(SmRecord record) async {
    if (record.id == null) {
      throw InvalidDataException(
        "The record cannot have id of null for this operation",
      );
    }

    return delete(sitemarkerRecords)..where((rec) => rec.id.equals(record.id!));
  }

  Future<void> purgeOldRecords() async {
    final sixtyDaysAgo = DateTime.now().subtract(const Duration(days: 60));

    // Hard delete anything flagged as deleted 60+ days ago
    await (delete(sitemarkerRecords)
          ..where((r) => r.isDeleted.equals(true))
          ..where((r) => r.dateModified.isSmallerThanValue(sixtyDaysAgo)))
        .go();
  }

  /// Search active records using FTS5
  Future<List<SmRecord>> searchActive(String query) async {
    // Append wildcard for partial word matching
    final records = await db.searchActiveRecords('$query*').get();

    TagMappingDao tagMappingDao = TagMappingDao(db);
    TagsDao tagsDao = TagsDao(db);
    List<SmRecord> finalRecords = [];

    for (var record in records) {
      List<TagMapping> tagMapping = await tagMappingDao
          .getTagMappingByBookmarkId(record.r.id);
      List<String> tags = [];
      for (var mapping in tagMapping) {
        var tag = await tagsDao.getTagById(mapping.tagId);
        if (tag != null) tags.add(tag.name);
      }
      finalRecords.add(SmRecord.fromSitemarkerRecord(record.r, tags));
    }
    return finalRecords;
  }

  /// Highly optimized advanced search supporting combined text OR fields,
  /// strictly filtered by Tags (AND), with O(1) tag hydration.
  Future<List<SmRecord>> advancedSearch({
    String? nameQuery,
    String? urlQuery,
    List<String>? tags,
    int? folderId,
  }) async {
    // 1. Initial base query and folder scoping
    var query = select(sitemarkerRecords)
      ..where((r) => r.isDeleted.equals(false));

    if (folderId != null && folderId != -1) {
      query.where((r) => r.folderId.equals(folderId));
    }

    final hasName = nameQuery != null && nameQuery.trim().isNotEmpty;
    final hasUrl = urlQuery != null && urlQuery.trim().isNotEmpty;
    final hasTags = tags != null && tags.isNotEmpty;

    // If all fields are empty, stop execution and return nothing
    if (!hasName && !hasUrl && !hasTags) return [];

    // 2. Group the text search conditions (Name OR URL)
    final textConditions = <Expression<bool>>[];

    if (hasName) {
      textConditions.add(
        sitemarkerRecords.name.lower().contains(
          nameQuery!.trim().toLowerCase(),
        ),
      );
    }

    if (hasUrl) {
      textConditions.add(
        sitemarkerRecords.url.lower().contains(urlQuery!.trim().toLowerCase()),
      );
    }

    Expression<bool>? combinedTextExpression;
    if (textConditions.isNotEmpty) {
      combinedTextExpression = textConditions.first;
      for (int i = 1; i < textConditions.length; i++) {
        combinedTextExpression = combinedTextExpression! | textConditions[i];
      }
    }

    // 3. Build the final conditions list (Text Group AND Tag Group)
    final finalConditions = <Expression<bool>>[];

    if (combinedTextExpression != null) {
      finalConditions.add(combinedTextExpression);
    }

    if (hasTags) {
      TagMappingDao tagMappingDao = TagMappingDao(db);
      TagsDao tagsDao = TagsDao(db);

      // Convert user's selected tags to lowercase for case-insensitive matching
      final lowerTags = tags!.map((t) => t.toLowerCase()).toList();

      final tagIdsSubquery = selectOnly(tagsDao.recordTags)
        ..addColumns([tagsDao.recordTags.id])
        ..where(tagsDao.recordTags.name.lower().isIn(lowerTags));

      final bookmarkIdsSubquery = selectOnly(tagMappingDao.tagMappings)
        ..addColumns([tagMappingDao.tagMappings.bookmarkId])
        ..where(tagMappingDao.tagMappings.tagId.isInQuery(tagIdsSubquery));

      finalConditions.add(sitemarkerRecords.id.isInQuery(bookmarkIdsSubquery));
    }

    // 4. Combine everything with SQL 'AND' logic
    if (finalConditions.isNotEmpty) {
      query.where((r) {
        Expression<bool> combined = finalConditions.first;
        for (int i = 1; i < finalConditions.length; i++) {
          combined = combined & finalConditions[i];
        }
        return combined;
      });
    }

    // Execute the query
    final matchingRecords = await query.get();
    if (matchingRecords.isEmpty) return [];

    // 5. Batch fetch tags to construct the SmRecord models
    final recordIds = matchingRecords.map((e) => e.id).toList();

    TagMappingDao tagMappingDao = TagMappingDao(db);
    TagsDao tagsDao = TagsDao(db);

    final tagQuery = select(tagMappingDao.tagMappings).join([
      innerJoin(
        tagsDao.recordTags,
        tagsDao.recordTags.id.equalsExp(tagMappingDao.tagMappings.tagId),
      ),
    ])..where(tagMappingDao.tagMappings.bookmarkId.isIn(recordIds));

    final tagRows = await tagQuery.get();

    final tagsByRecord = <int, List<String>>{};
    for (var row in tagRows) {
      final bookmarkId = row.readTable(tagMappingDao.tagMappings).bookmarkId;
      final tagName = row.readTable(tagsDao.recordTags).name;
      tagsByRecord.putIfAbsent(bookmarkId, () => []).add(tagName);
    }

    // 6. Construct the final models
    return matchingRecords.map((record) {
      return SmRecord.fromSitemarkerRecord(
        record,
        tagsByRecord[record.id] ?? [],
      );
    }).toList();
  }
}
