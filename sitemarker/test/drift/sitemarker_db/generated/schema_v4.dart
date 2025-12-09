// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

class Folders extends Table with TableInfo<Folders, FoldersData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Folders(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES folders (id)'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, parentId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'folders';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoldersData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoldersData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  Folders createAlias(String alias) {
    return Folders(attachedDatabase, alias);
  }

  @override
  List<String> get customConstraints => const ['UNIQUE(parent_id, name)'];
}

class FoldersData extends DataClass implements Insertable<FoldersData> {
  final int id;
  final int? parentId;
  final String name;
  const FoldersData({required this.id, this.parentId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<int>(parentId);
    }
    map['name'] = Variable<String>(name);
    return map;
  }

  FoldersCompanion toCompanion(bool nullToAbsent) {
    return FoldersCompanion(
      id: Value(id),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      name: Value(name),
    );
  }

  factory FoldersData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoldersData(
      id: serializer.fromJson<int>(json['id']),
      parentId: serializer.fromJson<int?>(json['parentId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'parentId': serializer.toJson<int?>(parentId),
      'name': serializer.toJson<String>(name),
    };
  }

  FoldersData copyWith(
          {int? id,
          Value<int?> parentId = const Value.absent(),
          String? name}) =>
      FoldersData(
        id: id ?? this.id,
        parentId: parentId.present ? parentId.value : this.parentId,
        name: name ?? this.name,
      );
  FoldersData copyWithCompanion(FoldersCompanion data) {
    return FoldersData(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoldersData(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, parentId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoldersData &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.name == this.name);
}

class FoldersCompanion extends UpdateCompanion<FoldersData> {
  final Value<int> id;
  final Value<int?> parentId;
  final Value<String> name;
  const FoldersCompanion({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    this.name = const Value.absent(),
  });
  FoldersCompanion.insert({
    this.id = const Value.absent(),
    this.parentId = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<FoldersData> custom({
    Expression<int>? id,
    Expression<int>? parentId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (parentId != null) 'parent_id': parentId,
      if (name != null) 'name': name,
    });
  }

  FoldersCompanion copyWith(
      {Value<int>? id, Value<int?>? parentId, Value<String>? name}) {
    return FoldersCompanion(
      id: id ?? this.id,
      parentId: parentId ?? this.parentId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<int>(parentId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoldersCompanion(')
          ..write('id: $id, ')
          ..write('parentId: $parentId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class SitemarkerRecords extends Table
    with TableInfo<SitemarkerRecords, SitemarkerRecordsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  SitemarkerRecords(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const CustomExpression('0'));
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
      'date_added', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('1765132200'));
  late final GeneratedColumn<DateTime> dateModified = GeneratedColumn<DateTime>(
      'date_modified', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('1765132200'));
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  late final GeneratedColumn<int> folderId = GeneratedColumn<int>(
      'folder_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES folders (id)'),
      defaultValue: const CustomExpression('1'));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        url,
        isDeleted,
        dateAdded,
        dateModified,
        lastSynced,
        notes,
        folderId
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sitemarker_records';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SitemarkerRecordsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SitemarkerRecordsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      dateAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_added'])!,
      dateModified: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_modified'])!,
      lastSynced: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_synced']),
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      folderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}folder_id'])!,
    );
  }

  @override
  SitemarkerRecords createAlias(String alias) {
    return SitemarkerRecords(attachedDatabase, alias);
  }
}

class SitemarkerRecordsData extends DataClass
    implements Insertable<SitemarkerRecordsData> {
  final int id;
  final String name;
  final String url;
  final bool isDeleted;
  final DateTime dateAdded;
  final DateTime dateModified;
  final DateTime? lastSynced;
  final String? notes;
  final int folderId;
  const SitemarkerRecordsData(
      {required this.id,
      required this.name,
      required this.url,
      required this.isDeleted,
      required this.dateAdded,
      required this.dateModified,
      this.lastSynced,
      this.notes,
      required this.folderId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['date_added'] = Variable<DateTime>(dateAdded);
    map['date_modified'] = Variable<DateTime>(dateModified);
    if (!nullToAbsent || lastSynced != null) {
      map['last_synced'] = Variable<DateTime>(lastSynced);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['folder_id'] = Variable<int>(folderId);
    return map;
  }

  SitemarkerRecordsCompanion toCompanion(bool nullToAbsent) {
    return SitemarkerRecordsCompanion(
      id: Value(id),
      name: Value(name),
      url: Value(url),
      isDeleted: Value(isDeleted),
      dateAdded: Value(dateAdded),
      dateModified: Value(dateModified),
      lastSynced: lastSynced == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSynced),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      folderId: Value(folderId),
    );
  }

  factory SitemarkerRecordsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SitemarkerRecordsData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      dateModified: serializer.fromJson<DateTime>(json['dateModified']),
      lastSynced: serializer.fromJson<DateTime?>(json['lastSynced']),
      notes: serializer.fromJson<String?>(json['notes']),
      folderId: serializer.fromJson<int>(json['folderId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
      'dateModified': serializer.toJson<DateTime>(dateModified),
      'lastSynced': serializer.toJson<DateTime?>(lastSynced),
      'notes': serializer.toJson<String?>(notes),
      'folderId': serializer.toJson<int>(folderId),
    };
  }

  SitemarkerRecordsData copyWith(
          {int? id,
          String? name,
          String? url,
          bool? isDeleted,
          DateTime? dateAdded,
          DateTime? dateModified,
          Value<DateTime?> lastSynced = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          int? folderId}) =>
      SitemarkerRecordsData(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        isDeleted: isDeleted ?? this.isDeleted,
        dateAdded: dateAdded ?? this.dateAdded,
        dateModified: dateModified ?? this.dateModified,
        lastSynced: lastSynced.present ? lastSynced.value : this.lastSynced,
        notes: notes.present ? notes.value : this.notes,
        folderId: folderId ?? this.folderId,
      );
  SitemarkerRecordsData copyWithCompanion(SitemarkerRecordsCompanion data) {
    return SitemarkerRecordsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      dateModified: data.dateModified.present
          ? data.dateModified.value
          : this.dateModified,
      lastSynced:
          data.lastSynced.present ? data.lastSynced.value : this.lastSynced,
      notes: data.notes.present ? data.notes.value : this.notes,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SitemarkerRecordsData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('dateModified: $dateModified, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('notes: $notes, ')
          ..write('folderId: $folderId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, url, isDeleted, dateAdded,
      dateModified, lastSynced, notes, folderId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SitemarkerRecordsData &&
          other.id == this.id &&
          other.name == this.name &&
          other.url == this.url &&
          other.isDeleted == this.isDeleted &&
          other.dateAdded == this.dateAdded &&
          other.dateModified == this.dateModified &&
          other.lastSynced == this.lastSynced &&
          other.notes == this.notes &&
          other.folderId == this.folderId);
}

class SitemarkerRecordsCompanion
    extends UpdateCompanion<SitemarkerRecordsData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> url;
  final Value<bool> isDeleted;
  final Value<DateTime> dateAdded;
  final Value<DateTime> dateModified;
  final Value<DateTime?> lastSynced;
  final Value<String?> notes;
  final Value<int> folderId;
  const SitemarkerRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.dateModified = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.notes = const Value.absent(),
    this.folderId = const Value.absent(),
  });
  SitemarkerRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String url,
    this.isDeleted = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.dateModified = const Value.absent(),
    this.lastSynced = const Value.absent(),
    this.notes = const Value.absent(),
    this.folderId = const Value.absent(),
  })  : name = Value(name),
        url = Value(url);
  static Insertable<SitemarkerRecordsData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? url,
    Expression<bool>? isDeleted,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? dateModified,
    Expression<DateTime>? lastSynced,
    Expression<String>? notes,
    Expression<int>? folderId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (dateAdded != null) 'date_added': dateAdded,
      if (dateModified != null) 'date_modified': dateModified,
      if (lastSynced != null) 'last_synced': lastSynced,
      if (notes != null) 'notes': notes,
      if (folderId != null) 'folder_id': folderId,
    });
  }

  SitemarkerRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? url,
      Value<bool>? isDeleted,
      Value<DateTime>? dateAdded,
      Value<DateTime>? dateModified,
      Value<DateTime?>? lastSynced,
      Value<String?>? notes,
      Value<int>? folderId}) {
    return SitemarkerRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      isDeleted: isDeleted ?? this.isDeleted,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
      lastSynced: lastSynced ?? this.lastSynced,
      notes: notes ?? this.notes,
      folderId: folderId ?? this.folderId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    if (dateModified.present) {
      map['date_modified'] = Variable<DateTime>(dateModified.value);
    }
    if (lastSynced.present) {
      map['last_synced'] = Variable<DateTime>(lastSynced.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SitemarkerRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('dateModified: $dateModified, ')
          ..write('lastSynced: $lastSynced, ')
          ..write('notes: $notes, ')
          ..write('folderId: $folderId')
          ..write(')'))
        .toString();
  }
}

class RecordTags extends Table with TableInfo<RecordTags, RecordTagsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  RecordTags(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'record_tags';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordTagsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordTagsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  RecordTags createAlias(String alias) {
    return RecordTags(attachedDatabase, alias);
  }
}

class RecordTagsData extends DataClass implements Insertable<RecordTagsData> {
  final int id;
  final String name;
  const RecordTagsData({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  RecordTagsCompanion toCompanion(bool nullToAbsent) {
    return RecordTagsCompanion(
      id: Value(id),
      name: Value(name),
    );
  }

  factory RecordTagsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordTagsData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  RecordTagsData copyWith({int? id, String? name}) => RecordTagsData(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  RecordTagsData copyWithCompanion(RecordTagsCompanion data) {
    return RecordTagsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordTagsData(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecordTagsData &&
          other.id == this.id &&
          other.name == this.name);
}

class RecordTagsCompanion extends UpdateCompanion<RecordTagsData> {
  final Value<int> id;
  final Value<String> name;
  const RecordTagsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
  });
  RecordTagsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
  }) : name = Value(name);
  static Insertable<RecordTagsData> custom({
    Expression<int>? id,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
    });
  }

  RecordTagsCompanion copyWith({Value<int>? id, Value<String>? name}) {
    return RecordTagsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordTagsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class TagMappings extends Table with TableInfo<TagMappings, TagMappingsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TagMappings(this.attachedDatabase, [this._alias]);
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  late final GeneratedColumn<int> bookmarkId = GeneratedColumn<int>(
      'bookmark_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES sitemarker_records (id) ON DELETE CASCADE'));
  late final GeneratedColumn<int> tagId = GeneratedColumn<int>(
      'tag_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES record_tags (id) ON DELETE CASCADE'));
  @override
  List<GeneratedColumn> get $columns => [id, bookmarkId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tag_mappings';
  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagMappingsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagMappingsData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookmarkId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bookmark_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  TagMappings createAlias(String alias) {
    return TagMappings(attachedDatabase, alias);
  }
}

class TagMappingsData extends DataClass implements Insertable<TagMappingsData> {
  final int id;
  final int bookmarkId;
  final int tagId;
  const TagMappingsData(
      {required this.id, required this.bookmarkId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['bookmark_id'] = Variable<int>(bookmarkId);
    map['tag_id'] = Variable<int>(tagId);
    return map;
  }

  TagMappingsCompanion toCompanion(bool nullToAbsent) {
    return TagMappingsCompanion(
      id: Value(id),
      bookmarkId: Value(bookmarkId),
      tagId: Value(tagId),
    );
  }

  factory TagMappingsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagMappingsData(
      id: serializer.fromJson<int>(json['id']),
      bookmarkId: serializer.fromJson<int>(json['bookmarkId']),
      tagId: serializer.fromJson<int>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'bookmarkId': serializer.toJson<int>(bookmarkId),
      'tagId': serializer.toJson<int>(tagId),
    };
  }

  TagMappingsData copyWith({int? id, int? bookmarkId, int? tagId}) =>
      TagMappingsData(
        id: id ?? this.id,
        bookmarkId: bookmarkId ?? this.bookmarkId,
        tagId: tagId ?? this.tagId,
      );
  TagMappingsData copyWithCompanion(TagMappingsCompanion data) {
    return TagMappingsData(
      id: data.id.present ? data.id.value : this.id,
      bookmarkId:
          data.bookmarkId.present ? data.bookmarkId.value : this.bookmarkId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagMappingsData(')
          ..write('id: $id, ')
          ..write('bookmarkId: $bookmarkId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, bookmarkId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TagMappingsData &&
          other.id == this.id &&
          other.bookmarkId == this.bookmarkId &&
          other.tagId == this.tagId);
}

class TagMappingsCompanion extends UpdateCompanion<TagMappingsData> {
  final Value<int> id;
  final Value<int> bookmarkId;
  final Value<int> tagId;
  const TagMappingsCompanion({
    this.id = const Value.absent(),
    this.bookmarkId = const Value.absent(),
    this.tagId = const Value.absent(),
  });
  TagMappingsCompanion.insert({
    this.id = const Value.absent(),
    required int bookmarkId,
    required int tagId,
  })  : bookmarkId = Value(bookmarkId),
        tagId = Value(tagId);
  static Insertable<TagMappingsData> custom({
    Expression<int>? id,
    Expression<int>? bookmarkId,
    Expression<int>? tagId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (bookmarkId != null) 'bookmark_id': bookmarkId,
      if (tagId != null) 'tag_id': tagId,
    });
  }

  TagMappingsCompanion copyWith(
      {Value<int>? id, Value<int>? bookmarkId, Value<int>? tagId}) {
    return TagMappingsCompanion(
      id: id ?? this.id,
      bookmarkId: bookmarkId ?? this.bookmarkId,
      tagId: tagId ?? this.tagId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (bookmarkId.present) {
      map['bookmark_id'] = Variable<int>(bookmarkId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<int>(tagId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagMappingsCompanion(')
          ..write('id: $id, ')
          ..write('bookmarkId: $bookmarkId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV4 extends GeneratedDatabase {
  DatabaseAtV4(QueryExecutor e) : super(e);
  late final Folders folders = Folders(this);
  late final SitemarkerRecords sitemarkerRecords = SitemarkerRecords(this);
  late final RecordTags recordTags = RecordTags(this);
  late final TagMappings tagMappings = TagMappings(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [folders, sitemarkerRecords, recordTags, tagMappings];
  @override
  int get schemaVersion => 4;
}
