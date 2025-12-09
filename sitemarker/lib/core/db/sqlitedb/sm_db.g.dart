// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sm_db.dart';

// ignore_for_file: type=lint
class $FoldersTable extends Folders with TableInfo<$FoldersTable, Folder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoldersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _parentIdMeta =
      const VerificationMeta('parentId');
  @override
  late final GeneratedColumn<int> parentId = GeneratedColumn<int>(
      'parent_id', aliasedName, true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES folders (id)'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
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
  VerificationContext validateIntegrity(Insertable<Folder> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('parent_id')) {
      context.handle(_parentIdMeta,
          parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Folder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Folder(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      parentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}parent_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $FoldersTable createAlias(String alias) {
    return $FoldersTable(attachedDatabase, alias);
  }
}

class Folder extends DataClass implements Insertable<Folder> {
  final int id;
  final int? parentId;
  final String name;
  const Folder({required this.id, this.parentId, required this.name});
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

  factory Folder.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Folder(
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

  Folder copyWith(
          {int? id,
          Value<int?> parentId = const Value.absent(),
          String? name}) =>
      Folder(
        id: id ?? this.id,
        parentId: parentId.present ? parentId.value : this.parentId,
        name: name ?? this.name,
      );
  Folder copyWithCompanion(FoldersCompanion data) {
    return Folder(
      id: data.id.present ? data.id.value : this.id,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Folder(')
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
      (other is Folder &&
          other.id == this.id &&
          other.parentId == this.parentId &&
          other.name == this.name);
}

class FoldersCompanion extends UpdateCompanion<Folder> {
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
  static Insertable<Folder> custom({
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

class $SitemarkerRecordsTable extends SitemarkerRecords
    with TableInfo<$SitemarkerRecordsTable, SitemarkerRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SitemarkerRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDeletedMeta =
      const VerificationMeta('isDeleted');
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
      'is_deleted', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_deleted" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _dateAddedMeta =
      const VerificationMeta('dateAdded');
  @override
  late final GeneratedColumn<DateTime> dateAdded = GeneratedColumn<DateTime>(
      'date_added', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day)));
  static const VerificationMeta _dateModifiedMeta =
      const VerificationMeta('dateModified');
  @override
  late final GeneratedColumn<DateTime> dateModified = GeneratedColumn<DateTime>(
      'date_modified', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: Constant(DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day)));
  static const VerificationMeta _lastSyncedMeta =
      const VerificationMeta('lastSynced');
  @override
  late final GeneratedColumn<DateTime> lastSynced = GeneratedColumn<DateTime>(
      'last_synced', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _folderIdMeta =
      const VerificationMeta('folderId');
  @override
  late final GeneratedColumn<int> folderId = GeneratedColumn<int>(
      'folder_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES folders (id)'),
      defaultValue: const Constant(1));
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
  VerificationContext validateIntegrity(Insertable<SitemarkerRecord> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('date_added')) {
      context.handle(_dateAddedMeta,
          dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta));
    }
    if (data.containsKey('date_modified')) {
      context.handle(
          _dateModifiedMeta,
          dateModified.isAcceptableOrUnknown(
              data['date_modified']!, _dateModifiedMeta));
    }
    if (data.containsKey('last_synced')) {
      context.handle(
          _lastSyncedMeta,
          lastSynced.isAcceptableOrUnknown(
              data['last_synced']!, _lastSyncedMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('folder_id')) {
      context.handle(_folderIdMeta,
          folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SitemarkerRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SitemarkerRecord(
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
  $SitemarkerRecordsTable createAlias(String alias) {
    return $SitemarkerRecordsTable(attachedDatabase, alias);
  }
}

class SitemarkerRecord extends DataClass
    implements Insertable<SitemarkerRecord> {
  final int id;
  final String name;
  final String url;
  final bool isDeleted;
  final DateTime dateAdded;
  final DateTime dateModified;
  final DateTime? lastSynced;
  final String? notes;
  final int folderId;
  const SitemarkerRecord(
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

  factory SitemarkerRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SitemarkerRecord(
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

  SitemarkerRecord copyWith(
          {int? id,
          String? name,
          String? url,
          bool? isDeleted,
          DateTime? dateAdded,
          DateTime? dateModified,
          Value<DateTime?> lastSynced = const Value.absent(),
          Value<String?> notes = const Value.absent(),
          int? folderId}) =>
      SitemarkerRecord(
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
  SitemarkerRecord copyWithCompanion(SitemarkerRecordsCompanion data) {
    return SitemarkerRecord(
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
    return (StringBuffer('SitemarkerRecord(')
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
      (other is SitemarkerRecord &&
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

class SitemarkerRecordsCompanion extends UpdateCompanion<SitemarkerRecord> {
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
  static Insertable<SitemarkerRecord> custom({
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

class $RecordTagsTable extends RecordTags
    with TableInfo<$RecordTagsTable, RecordTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecordTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
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
  VerificationContext validateIntegrity(Insertable<RecordTag> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecordTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecordTag(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $RecordTagsTable createAlias(String alias) {
    return $RecordTagsTable(attachedDatabase, alias);
  }
}

class RecordTag extends DataClass implements Insertable<RecordTag> {
  final int id;
  final String name;
  const RecordTag({required this.id, required this.name});
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

  factory RecordTag.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecordTag(
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

  RecordTag copyWith({int? id, String? name}) => RecordTag(
        id: id ?? this.id,
        name: name ?? this.name,
      );
  RecordTag copyWithCompanion(RecordTagsCompanion data) {
    return RecordTag(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecordTag(')
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
      (other is RecordTag && other.id == this.id && other.name == this.name);
}

class RecordTagsCompanion extends UpdateCompanion<RecordTag> {
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
  static Insertable<RecordTag> custom({
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

class $TagMappingsTable extends TagMappings
    with TableInfo<$TagMappingsTable, TagMapping> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagMappingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _bookmarkIdMeta =
      const VerificationMeta('bookmarkId');
  @override
  late final GeneratedColumn<int> bookmarkId = GeneratedColumn<int>(
      'bookmark_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES sitemarker_records (id) ON DELETE CASCADE'));
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
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
  VerificationContext validateIntegrity(Insertable<TagMapping> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('bookmark_id')) {
      context.handle(
          _bookmarkIdMeta,
          bookmarkId.isAcceptableOrUnknown(
              data['bookmark_id']!, _bookmarkIdMeta));
    } else if (isInserting) {
      context.missing(_bookmarkIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
          _tagIdMeta, tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta));
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TagMapping map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TagMapping(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      bookmarkId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}bookmark_id'])!,
      tagId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}tag_id'])!,
    );
  }

  @override
  $TagMappingsTable createAlias(String alias) {
    return $TagMappingsTable(attachedDatabase, alias);
  }
}

class TagMapping extends DataClass implements Insertable<TagMapping> {
  final int id;
  final int bookmarkId;
  final int tagId;
  const TagMapping(
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

  factory TagMapping.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TagMapping(
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

  TagMapping copyWith({int? id, int? bookmarkId, int? tagId}) => TagMapping(
        id: id ?? this.id,
        bookmarkId: bookmarkId ?? this.bookmarkId,
        tagId: tagId ?? this.tagId,
      );
  TagMapping copyWithCompanion(TagMappingsCompanion data) {
    return TagMapping(
      id: data.id.present ? data.id.value : this.id,
      bookmarkId:
          data.bookmarkId.present ? data.bookmarkId.value : this.bookmarkId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TagMapping(')
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
      (other is TagMapping &&
          other.id == this.id &&
          other.bookmarkId == this.bookmarkId &&
          other.tagId == this.tagId);
}

class TagMappingsCompanion extends UpdateCompanion<TagMapping> {
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
  static Insertable<TagMapping> custom({
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

abstract class _$SitemarkerDB extends GeneratedDatabase {
  _$SitemarkerDB(QueryExecutor e) : super(e);
  $SitemarkerDBManager get managers => $SitemarkerDBManager(this);
  late final $FoldersTable folders = $FoldersTable(this);
  late final $SitemarkerRecordsTable sitemarkerRecords =
      $SitemarkerRecordsTable(this);
  late final $RecordTagsTable recordTags = $RecordTagsTable(this);
  late final $TagMappingsTable tagMappings = $TagMappingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [folders, sitemarkerRecords, recordTags, tagMappings];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('sitemarker_records',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('tag_mappings', kind: UpdateKind.delete),
            ],
          ),
          WritePropagation(
            on: TableUpdateQuery.onTableName('record_tags',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('tag_mappings', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$FoldersTableCreateCompanionBuilder = FoldersCompanion Function({
  Value<int> id,
  Value<int?> parentId,
  required String name,
});
typedef $$FoldersTableUpdateCompanionBuilder = FoldersCompanion Function({
  Value<int> id,
  Value<int?> parentId,
  Value<String> name,
});

final class $$FoldersTableReferences
    extends BaseReferences<_$SitemarkerDB, $FoldersTable, Folder> {
  $$FoldersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FoldersTable _parentIdTable(_$SitemarkerDB db) => db.folders
      .createAlias($_aliasNameGenerator(db.folders.parentId, db.folders.id));

  $$FoldersTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<int>('parent_id');
    if ($_column == null) return null;
    final manager = $$FoldersTableTableManager($_db, $_db.folders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$SitemarkerRecordsTable, List<SitemarkerRecord>>
      _sitemarkerRecordsRefsTable(_$SitemarkerDB db) =>
          MultiTypedResultKey.fromTable(db.sitemarkerRecords,
              aliasName: $_aliasNameGenerator(
                  db.folders.id, db.sitemarkerRecords.folderId));

  $$SitemarkerRecordsTableProcessedTableManager get sitemarkerRecordsRefs {
    final manager =
        $$SitemarkerRecordsTableTableManager($_db, $_db.sitemarkerRecords)
            .filter((f) => f.folderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache =
        $_typedResult.readTableOrNull(_sitemarkerRecordsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$FoldersTableFilterComposer
    extends Composer<_$SitemarkerDB, $FoldersTable> {
  $$FoldersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  $$FoldersTableFilterComposer get parentId {
    final $$FoldersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableFilterComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> sitemarkerRecordsRefs(
      Expression<bool> Function($$SitemarkerRecordsTableFilterComposer f) f) {
    final $$SitemarkerRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.sitemarkerRecords,
        getReferencedColumn: (t) => t.folderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SitemarkerRecordsTableFilterComposer(
              $db: $db,
              $table: $db.sitemarkerRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$FoldersTableOrderingComposer
    extends Composer<_$SitemarkerDB, $FoldersTable> {
  $$FoldersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  $$FoldersTableOrderingComposer get parentId {
    final $$FoldersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableOrderingComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$FoldersTableAnnotationComposer
    extends Composer<_$SitemarkerDB, $FoldersTable> {
  $$FoldersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  $$FoldersTableAnnotationComposer get parentId {
    final $$FoldersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.parentId,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableAnnotationComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> sitemarkerRecordsRefs<T extends Object>(
      Expression<T> Function($$SitemarkerRecordsTableAnnotationComposer a) f) {
    final $$SitemarkerRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.id,
            referencedTable: $db.sitemarkerRecords,
            getReferencedColumn: (t) => t.folderId,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SitemarkerRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sitemarkerRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return f(composer);
  }
}

class $$FoldersTableTableManager extends RootTableManager<
    _$SitemarkerDB,
    $FoldersTable,
    Folder,
    $$FoldersTableFilterComposer,
    $$FoldersTableOrderingComposer,
    $$FoldersTableAnnotationComposer,
    $$FoldersTableCreateCompanionBuilder,
    $$FoldersTableUpdateCompanionBuilder,
    (Folder, $$FoldersTableReferences),
    Folder,
    PrefetchHooks Function({bool parentId, bool sitemarkerRecordsRefs})> {
  $$FoldersTableTableManager(_$SitemarkerDB db, $FoldersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              FoldersCompanion(
            id: id,
            parentId: parentId,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int?> parentId = const Value.absent(),
            required String name,
          }) =>
              FoldersCompanion.insert(
            id: id,
            parentId: parentId,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$FoldersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: (
              {parentId = false, sitemarkerRecordsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (sitemarkerRecordsRefs) db.sitemarkerRecords
              ],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (parentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.parentId,
                    referencedTable:
                        $$FoldersTableReferences._parentIdTable(db),
                    referencedColumn:
                        $$FoldersTableReferences._parentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (sitemarkerRecordsRefs)
                    await $_getPrefetchedData<Folder, $FoldersTable,
                            SitemarkerRecord>(
                        currentTable: table,
                        referencedTable: $$FoldersTableReferences
                            ._sitemarkerRecordsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$FoldersTableReferences(db, table, p0)
                                .sitemarkerRecordsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.folderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$FoldersTableProcessedTableManager = ProcessedTableManager<
    _$SitemarkerDB,
    $FoldersTable,
    Folder,
    $$FoldersTableFilterComposer,
    $$FoldersTableOrderingComposer,
    $$FoldersTableAnnotationComposer,
    $$FoldersTableCreateCompanionBuilder,
    $$FoldersTableUpdateCompanionBuilder,
    (Folder, $$FoldersTableReferences),
    Folder,
    PrefetchHooks Function({bool parentId, bool sitemarkerRecordsRefs})>;
typedef $$SitemarkerRecordsTableCreateCompanionBuilder
    = SitemarkerRecordsCompanion Function({
  Value<int> id,
  required String name,
  required String url,
  Value<bool> isDeleted,
  Value<DateTime> dateAdded,
  Value<DateTime> dateModified,
  Value<DateTime?> lastSynced,
  Value<String?> notes,
  Value<int> folderId,
});
typedef $$SitemarkerRecordsTableUpdateCompanionBuilder
    = SitemarkerRecordsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> url,
  Value<bool> isDeleted,
  Value<DateTime> dateAdded,
  Value<DateTime> dateModified,
  Value<DateTime?> lastSynced,
  Value<String?> notes,
  Value<int> folderId,
});

final class $$SitemarkerRecordsTableReferences extends BaseReferences<
    _$SitemarkerDB, $SitemarkerRecordsTable, SitemarkerRecord> {
  $$SitemarkerRecordsTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static $FoldersTable _folderIdTable(_$SitemarkerDB db) =>
      db.folders.createAlias(
          $_aliasNameGenerator(db.sitemarkerRecords.folderId, db.folders.id));

  $$FoldersTableProcessedTableManager get folderId {
    final $_column = $_itemColumn<int>('folder_id')!;

    final manager = $$FoldersTableTableManager($_db, $_db.folders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static MultiTypedResultKey<$TagMappingsTable, List<TagMapping>>
      _tagMappingsRefsTable(_$SitemarkerDB db) =>
          MultiTypedResultKey.fromTable(db.tagMappings,
              aliasName: $_aliasNameGenerator(
                  db.sitemarkerRecords.id, db.tagMappings.bookmarkId));

  $$TagMappingsTableProcessedTableManager get tagMappingsRefs {
    final manager = $$TagMappingsTableTableManager($_db, $_db.tagMappings)
        .filter((f) => f.bookmarkId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tagMappingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SitemarkerRecordsTableFilterComposer
    extends Composer<_$SitemarkerDB, $SitemarkerRecordsTable> {
  $$SitemarkerRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
      column: $table.dateAdded, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateModified => $composableBuilder(
      column: $table.dateModified, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  $$FoldersTableFilterComposer get folderId {
    final $$FoldersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderId,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableFilterComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<bool> tagMappingsRefs(
      Expression<bool> Function($$TagMappingsTableFilterComposer f) f) {
    final $$TagMappingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tagMappings,
        getReferencedColumn: (t) => t.bookmarkId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagMappingsTableFilterComposer(
              $db: $db,
              $table: $db.tagMappings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SitemarkerRecordsTableOrderingComposer
    extends Composer<_$SitemarkerDB, $SitemarkerRecordsTable> {
  $$SitemarkerRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
      column: $table.dateAdded, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateModified => $composableBuilder(
      column: $table.dateModified,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  $$FoldersTableOrderingComposer get folderId {
    final $$FoldersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderId,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableOrderingComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$SitemarkerRecordsTableAnnotationComposer
    extends Composer<_$SitemarkerDB, $SitemarkerRecordsTable> {
  $$SitemarkerRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);

  GeneratedColumn<DateTime> get dateModified => $composableBuilder(
      column: $table.dateModified, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSynced => $composableBuilder(
      column: $table.lastSynced, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$FoldersTableAnnotationComposer get folderId {
    final $$FoldersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.folderId,
        referencedTable: $db.folders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$FoldersTableAnnotationComposer(
              $db: $db,
              $table: $db.folders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  Expression<T> tagMappingsRefs<T extends Object>(
      Expression<T> Function($$TagMappingsTableAnnotationComposer a) f) {
    final $$TagMappingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tagMappings,
        getReferencedColumn: (t) => t.bookmarkId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagMappingsTableAnnotationComposer(
              $db: $db,
              $table: $db.tagMappings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SitemarkerRecordsTableTableManager extends RootTableManager<
    _$SitemarkerDB,
    $SitemarkerRecordsTable,
    SitemarkerRecord,
    $$SitemarkerRecordsTableFilterComposer,
    $$SitemarkerRecordsTableOrderingComposer,
    $$SitemarkerRecordsTableAnnotationComposer,
    $$SitemarkerRecordsTableCreateCompanionBuilder,
    $$SitemarkerRecordsTableUpdateCompanionBuilder,
    (SitemarkerRecord, $$SitemarkerRecordsTableReferences),
    SitemarkerRecord,
    PrefetchHooks Function({bool folderId, bool tagMappingsRefs})> {
  $$SitemarkerRecordsTableTableManager(
      _$SitemarkerDB db, $SitemarkerRecordsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SitemarkerRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SitemarkerRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SitemarkerRecordsTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> dateAdded = const Value.absent(),
            Value<DateTime> dateModified = const Value.absent(),
            Value<DateTime?> lastSynced = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> folderId = const Value.absent(),
          }) =>
              SitemarkerRecordsCompanion(
            id: id,
            name: name,
            url: url,
            isDeleted: isDeleted,
            dateAdded: dateAdded,
            dateModified: dateModified,
            lastSynced: lastSynced,
            notes: notes,
            folderId: folderId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String url,
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> dateAdded = const Value.absent(),
            Value<DateTime> dateModified = const Value.absent(),
            Value<DateTime?> lastSynced = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> folderId = const Value.absent(),
          }) =>
              SitemarkerRecordsCompanion.insert(
            id: id,
            name: name,
            url: url,
            isDeleted: isDeleted,
            dateAdded: dateAdded,
            dateModified: dateModified,
            lastSynced: lastSynced,
            notes: notes,
            folderId: folderId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SitemarkerRecordsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({folderId = false, tagMappingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tagMappingsRefs) db.tagMappings],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (folderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.folderId,
                    referencedTable:
                        $$SitemarkerRecordsTableReferences._folderIdTable(db),
                    referencedColumn: $$SitemarkerRecordsTableReferences
                        ._folderIdTable(db)
                        .id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tagMappingsRefs)
                    await $_getPrefetchedData<SitemarkerRecord,
                            $SitemarkerRecordsTable, TagMapping>(
                        currentTable: table,
                        referencedTable: $$SitemarkerRecordsTableReferences
                            ._tagMappingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SitemarkerRecordsTableReferences(db, table, p0)
                                .tagMappingsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.bookmarkId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SitemarkerRecordsTableProcessedTableManager = ProcessedTableManager<
    _$SitemarkerDB,
    $SitemarkerRecordsTable,
    SitemarkerRecord,
    $$SitemarkerRecordsTableFilterComposer,
    $$SitemarkerRecordsTableOrderingComposer,
    $$SitemarkerRecordsTableAnnotationComposer,
    $$SitemarkerRecordsTableCreateCompanionBuilder,
    $$SitemarkerRecordsTableUpdateCompanionBuilder,
    (SitemarkerRecord, $$SitemarkerRecordsTableReferences),
    SitemarkerRecord,
    PrefetchHooks Function({bool folderId, bool tagMappingsRefs})>;
typedef $$RecordTagsTableCreateCompanionBuilder = RecordTagsCompanion Function({
  Value<int> id,
  required String name,
});
typedef $$RecordTagsTableUpdateCompanionBuilder = RecordTagsCompanion Function({
  Value<int> id,
  Value<String> name,
});

final class $$RecordTagsTableReferences
    extends BaseReferences<_$SitemarkerDB, $RecordTagsTable, RecordTag> {
  $$RecordTagsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$TagMappingsTable, List<TagMapping>>
      _tagMappingsRefsTable(_$SitemarkerDB db) =>
          MultiTypedResultKey.fromTable(db.tagMappings,
              aliasName:
                  $_aliasNameGenerator(db.recordTags.id, db.tagMappings.tagId));

  $$TagMappingsTableProcessedTableManager get tagMappingsRefs {
    final manager = $$TagMappingsTableTableManager($_db, $_db.tagMappings)
        .filter((f) => f.tagId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tagMappingsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$RecordTagsTableFilterComposer
    extends Composer<_$SitemarkerDB, $RecordTagsTable> {
  $$RecordTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  Expression<bool> tagMappingsRefs(
      Expression<bool> Function($$TagMappingsTableFilterComposer f) f) {
    final $$TagMappingsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tagMappings,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagMappingsTableFilterComposer(
              $db: $db,
              $table: $db.tagMappings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecordTagsTableOrderingComposer
    extends Composer<_$SitemarkerDB, $RecordTagsTable> {
  $$RecordTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));
}

class $$RecordTagsTableAnnotationComposer
    extends Composer<_$SitemarkerDB, $RecordTagsTable> {
  $$RecordTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  Expression<T> tagMappingsRefs<T extends Object>(
      Expression<T> Function($$TagMappingsTableAnnotationComposer a) f) {
    final $$TagMappingsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.tagMappings,
        getReferencedColumn: (t) => t.tagId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$TagMappingsTableAnnotationComposer(
              $db: $db,
              $table: $db.tagMappings,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$RecordTagsTableTableManager extends RootTableManager<
    _$SitemarkerDB,
    $RecordTagsTable,
    RecordTag,
    $$RecordTagsTableFilterComposer,
    $$RecordTagsTableOrderingComposer,
    $$RecordTagsTableAnnotationComposer,
    $$RecordTagsTableCreateCompanionBuilder,
    $$RecordTagsTableUpdateCompanionBuilder,
    (RecordTag, $$RecordTagsTableReferences),
    RecordTag,
    PrefetchHooks Function({bool tagMappingsRefs})> {
  $$RecordTagsTableTableManager(_$SitemarkerDB db, $RecordTagsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecordTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecordTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecordTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
          }) =>
              RecordTagsCompanion(
            id: id,
            name: name,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
          }) =>
              RecordTagsCompanion.insert(
            id: id,
            name: name,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$RecordTagsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({tagMappingsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tagMappingsRefs) db.tagMappings],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tagMappingsRefs)
                    await $_getPrefetchedData<RecordTag, $RecordTagsTable,
                            TagMapping>(
                        currentTable: table,
                        referencedTable: $$RecordTagsTableReferences
                            ._tagMappingsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$RecordTagsTableReferences(db, table, p0)
                                .tagMappingsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.tagId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$RecordTagsTableProcessedTableManager = ProcessedTableManager<
    _$SitemarkerDB,
    $RecordTagsTable,
    RecordTag,
    $$RecordTagsTableFilterComposer,
    $$RecordTagsTableOrderingComposer,
    $$RecordTagsTableAnnotationComposer,
    $$RecordTagsTableCreateCompanionBuilder,
    $$RecordTagsTableUpdateCompanionBuilder,
    (RecordTag, $$RecordTagsTableReferences),
    RecordTag,
    PrefetchHooks Function({bool tagMappingsRefs})>;
typedef $$TagMappingsTableCreateCompanionBuilder = TagMappingsCompanion
    Function({
  Value<int> id,
  required int bookmarkId,
  required int tagId,
});
typedef $$TagMappingsTableUpdateCompanionBuilder = TagMappingsCompanion
    Function({
  Value<int> id,
  Value<int> bookmarkId,
  Value<int> tagId,
});

final class $$TagMappingsTableReferences
    extends BaseReferences<_$SitemarkerDB, $TagMappingsTable, TagMapping> {
  $$TagMappingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SitemarkerRecordsTable _bookmarkIdTable(_$SitemarkerDB db) =>
      db.sitemarkerRecords.createAlias($_aliasNameGenerator(
          db.tagMappings.bookmarkId, db.sitemarkerRecords.id));

  $$SitemarkerRecordsTableProcessedTableManager get bookmarkId {
    final $_column = $_itemColumn<int>('bookmark_id')!;

    final manager =
        $$SitemarkerRecordsTableTableManager($_db, $_db.sitemarkerRecords)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bookmarkIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $RecordTagsTable _tagIdTable(_$SitemarkerDB db) =>
      db.recordTags.createAlias(
          $_aliasNameGenerator(db.tagMappings.tagId, db.recordTags.id));

  $$RecordTagsTableProcessedTableManager get tagId {
    final $_column = $_itemColumn<int>('tag_id')!;

    final manager = $$RecordTagsTableTableManager($_db, $_db.recordTags)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_tagIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$TagMappingsTableFilterComposer
    extends Composer<_$SitemarkerDB, $TagMappingsTable> {
  $$TagMappingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  $$SitemarkerRecordsTableFilterComposer get bookmarkId {
    final $$SitemarkerRecordsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookmarkId,
        referencedTable: $db.sitemarkerRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SitemarkerRecordsTableFilterComposer(
              $db: $db,
              $table: $db.sitemarkerRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecordTagsTableFilterComposer get tagId {
    final $$RecordTagsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.recordTags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecordTagsTableFilterComposer(
              $db: $db,
              $table: $db.recordTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TagMappingsTableOrderingComposer
    extends Composer<_$SitemarkerDB, $TagMappingsTable> {
  $$TagMappingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  $$SitemarkerRecordsTableOrderingComposer get bookmarkId {
    final $$SitemarkerRecordsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.bookmarkId,
        referencedTable: $db.sitemarkerRecords,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SitemarkerRecordsTableOrderingComposer(
              $db: $db,
              $table: $db.sitemarkerRecords,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$RecordTagsTableOrderingComposer get tagId {
    final $$RecordTagsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.recordTags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecordTagsTableOrderingComposer(
              $db: $db,
              $table: $db.recordTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TagMappingsTableAnnotationComposer
    extends Composer<_$SitemarkerDB, $TagMappingsTable> {
  $$TagMappingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  $$SitemarkerRecordsTableAnnotationComposer get bookmarkId {
    final $$SitemarkerRecordsTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.bookmarkId,
            referencedTable: $db.sitemarkerRecords,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SitemarkerRecordsTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sitemarkerRecords,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }

  $$RecordTagsTableAnnotationComposer get tagId {
    final $$RecordTagsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.tagId,
        referencedTable: $db.recordTags,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$RecordTagsTableAnnotationComposer(
              $db: $db,
              $table: $db.recordTags,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$TagMappingsTableTableManager extends RootTableManager<
    _$SitemarkerDB,
    $TagMappingsTable,
    TagMapping,
    $$TagMappingsTableFilterComposer,
    $$TagMappingsTableOrderingComposer,
    $$TagMappingsTableAnnotationComposer,
    $$TagMappingsTableCreateCompanionBuilder,
    $$TagMappingsTableUpdateCompanionBuilder,
    (TagMapping, $$TagMappingsTableReferences),
    TagMapping,
    PrefetchHooks Function({bool bookmarkId, bool tagId})> {
  $$TagMappingsTableTableManager(_$SitemarkerDB db, $TagMappingsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagMappingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagMappingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagMappingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> bookmarkId = const Value.absent(),
            Value<int> tagId = const Value.absent(),
          }) =>
              TagMappingsCompanion(
            id: id,
            bookmarkId: bookmarkId,
            tagId: tagId,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int bookmarkId,
            required int tagId,
          }) =>
              TagMappingsCompanion.insert(
            id: id,
            bookmarkId: bookmarkId,
            tagId: tagId,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$TagMappingsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({bookmarkId = false, tagId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (bookmarkId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.bookmarkId,
                    referencedTable:
                        $$TagMappingsTableReferences._bookmarkIdTable(db),
                    referencedColumn:
                        $$TagMappingsTableReferences._bookmarkIdTable(db).id,
                  ) as T;
                }
                if (tagId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.tagId,
                    referencedTable:
                        $$TagMappingsTableReferences._tagIdTable(db),
                    referencedColumn:
                        $$TagMappingsTableReferences._tagIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$TagMappingsTableProcessedTableManager = ProcessedTableManager<
    _$SitemarkerDB,
    $TagMappingsTable,
    TagMapping,
    $$TagMappingsTableFilterComposer,
    $$TagMappingsTableOrderingComposer,
    $$TagMappingsTableAnnotationComposer,
    $$TagMappingsTableCreateCompanionBuilder,
    $$TagMappingsTableUpdateCompanionBuilder,
    (TagMapping, $$TagMappingsTableReferences),
    TagMapping,
    PrefetchHooks Function({bool bookmarkId, bool tagId})>;

class $SitemarkerDBManager {
  final _$SitemarkerDB _db;
  $SitemarkerDBManager(this._db);
  $$FoldersTableTableManager get folders =>
      $$FoldersTableTableManager(_db, _db.folders);
  $$SitemarkerRecordsTableTableManager get sitemarkerRecords =>
      $$SitemarkerRecordsTableTableManager(_db, _db.sitemarkerRecords);
  $$RecordTagsTableTableManager get recordTags =>
      $$RecordTagsTableTableManager(_db, _db.recordTags);
  $$TagMappingsTableTableManager get tagMappings =>
      $$TagMappingsTableTableManager(_db, _db.tagMappings);
}
