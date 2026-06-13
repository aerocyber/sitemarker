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
}
