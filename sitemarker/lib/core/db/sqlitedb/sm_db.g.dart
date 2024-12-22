// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sm_db.dart';

// ignore_for_file: type=lint
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
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
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
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, url, tags, isDeleted, dateAdded];
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
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(_isDeletedMeta,
          isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta));
    }
    if (data.containsKey('date_added')) {
      context.handle(_dateAddedMeta,
          dateAdded.isAcceptableOrUnknown(data['date_added']!, _dateAddedMeta));
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
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      dateAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_added'])!,
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
  final String tags;
  final bool isDeleted;
  final DateTime dateAdded;
  const SitemarkerRecord(
      {required this.id,
      required this.name,
      required this.url,
      required this.tags,
      required this.isDeleted,
      required this.dateAdded});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    map['tags'] = Variable<String>(tags);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['date_added'] = Variable<DateTime>(dateAdded);
    return map;
  }

  SitemarkerRecordsCompanion toCompanion(bool nullToAbsent) {
    return SitemarkerRecordsCompanion(
      id: Value(id),
      name: Value(name),
      url: Value(url),
      tags: Value(tags),
      isDeleted: Value(isDeleted),
      dateAdded: Value(dateAdded),
    );
  }

  factory SitemarkerRecord.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SitemarkerRecord(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      tags: serializer.fromJson<String>(json['tags']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'url': serializer.toJson<String>(url),
      'tags': serializer.toJson<String>(tags),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'dateAdded': serializer.toJson<DateTime>(dateAdded),
    };
  }

  SitemarkerRecord copyWith(
          {int? id,
          String? name,
          String? url,
          String? tags,
          bool? isDeleted,
          DateTime? dateAdded}) =>
      SitemarkerRecord(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        tags: tags ?? this.tags,
        isDeleted: isDeleted ?? this.isDeleted,
        dateAdded: dateAdded ?? this.dateAdded,
      );
  SitemarkerRecord copyWithCompanion(SitemarkerRecordsCompanion data) {
    return SitemarkerRecord(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      tags: data.tags.present ? data.tags.value : this.tags,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SitemarkerRecord(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('tags: $tags, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dateAdded: $dateAdded')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, url, tags, isDeleted, dateAdded);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SitemarkerRecord &&
          other.id == this.id &&
          other.name == this.name &&
          other.url == this.url &&
          other.tags == this.tags &&
          other.isDeleted == this.isDeleted &&
          other.dateAdded == this.dateAdded);
}

class SitemarkerRecordsCompanion extends UpdateCompanion<SitemarkerRecord> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> url;
  final Value<String> tags;
  final Value<bool> isDeleted;
  final Value<DateTime> dateAdded;
  const SitemarkerRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.tags = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.dateAdded = const Value.absent(),
  });
  SitemarkerRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String url,
    required String tags,
    this.isDeleted = const Value.absent(),
    this.dateAdded = const Value.absent(),
  })  : name = Value(name),
        url = Value(url),
        tags = Value(tags);
  static Insertable<SitemarkerRecord> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? url,
    Expression<String>? tags,
    Expression<bool>? isDeleted,
    Expression<DateTime>? dateAdded,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (tags != null) 'tags': tags,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (dateAdded != null) 'date_added': dateAdded,
    });
  }

  SitemarkerRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? url,
      Value<String>? tags,
      Value<bool>? isDeleted,
      Value<DateTime>? dateAdded}) {
    return SitemarkerRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      tags: tags ?? this.tags,
      isDeleted: isDeleted ?? this.isDeleted,
      dateAdded: dateAdded ?? this.dateAdded,
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
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (dateAdded.present) {
      map['date_added'] = Variable<DateTime>(dateAdded.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SitemarkerRecordsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('tags: $tags, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dateAdded: $dateAdded')
          ..write(')'))
        .toString();
  }
}

abstract class _$SitemarkerDB extends GeneratedDatabase {
  _$SitemarkerDB(QueryExecutor e) : super(e);
  $SitemarkerDBManager get managers => $SitemarkerDBManager(this);
  late final $SitemarkerRecordsTable sitemarkerRecords =
      $SitemarkerRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sitemarkerRecords];
}

typedef $$SitemarkerRecordsTableCreateCompanionBuilder
    = SitemarkerRecordsCompanion Function({
  Value<int> id,
  required String name,
  required String url,
  required String tags,
  Value<bool> isDeleted,
  Value<DateTime> dateAdded,
});
typedef $$SitemarkerRecordsTableUpdateCompanionBuilder
    = SitemarkerRecordsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> url,
  Value<String> tags,
  Value<bool> isDeleted,
  Value<DateTime> dateAdded,
});

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

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get dateAdded => $composableBuilder(
      column: $table.dateAdded, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
      column: $table.isDeleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get dateAdded => $composableBuilder(
      column: $table.dateAdded, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<DateTime> get dateAdded =>
      $composableBuilder(column: $table.dateAdded, builder: (column) => column);
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
    (
      SitemarkerRecord,
      BaseReferences<_$SitemarkerDB, $SitemarkerRecordsTable, SitemarkerRecord>
    ),
    SitemarkerRecord,
    PrefetchHooks Function()> {
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
            Value<String> tags = const Value.absent(),
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> dateAdded = const Value.absent(),
          }) =>
              SitemarkerRecordsCompanion(
            id: id,
            name: name,
            url: url,
            tags: tags,
            isDeleted: isDeleted,
            dateAdded: dateAdded,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required String url,
            required String tags,
            Value<bool> isDeleted = const Value.absent(),
            Value<DateTime> dateAdded = const Value.absent(),
          }) =>
              SitemarkerRecordsCompanion.insert(
            id: id,
            name: name,
            url: url,
            tags: tags,
            isDeleted: isDeleted,
            dateAdded: dateAdded,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
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
    (
      SitemarkerRecord,
      BaseReferences<_$SitemarkerDB, $SitemarkerRecordsTable, SitemarkerRecord>
    ),
    SitemarkerRecord,
    PrefetchHooks Function()>;

class $SitemarkerDBManager {
  final _$SitemarkerDB _db;
  $SitemarkerDBManager(this._db);
  $$SitemarkerRecordsTableTableManager get sitemarkerRecords =>
      $$SitemarkerRecordsTableTableManager(_db, _db.sitemarkerRecords);
}
