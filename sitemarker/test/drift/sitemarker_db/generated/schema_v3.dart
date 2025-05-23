// dart format width=80
// GENERATED CODE, DO NOT EDIT BY HAND.
// ignore_for_file: type=lint
import 'package:drift/drift.dart';

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
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
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
      defaultValue: const CustomExpression('1747938600'));
  late final GeneratedColumn<DateTime> dateModified = GeneratedColumn<DateTime>(
      'date_modified', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: const CustomExpression('1747938600'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, url, tags, isDeleted, dateAdded, dateModified];
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
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      isDeleted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_deleted'])!,
      dateAdded: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_added'])!,
      dateModified: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}date_modified'])!,
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
  final String tags;
  final bool isDeleted;
  final DateTime dateAdded;
  final DateTime dateModified;
  const SitemarkerRecordsData(
      {required this.id,
      required this.name,
      required this.url,
      required this.tags,
      required this.isDeleted,
      required this.dateAdded,
      required this.dateModified});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['url'] = Variable<String>(url);
    map['tags'] = Variable<String>(tags);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['date_added'] = Variable<DateTime>(dateAdded);
    map['date_modified'] = Variable<DateTime>(dateModified);
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
      dateModified: Value(dateModified),
    );
  }

  factory SitemarkerRecordsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SitemarkerRecordsData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      url: serializer.fromJson<String>(json['url']),
      tags: serializer.fromJson<String>(json['tags']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      dateAdded: serializer.fromJson<DateTime>(json['dateAdded']),
      dateModified: serializer.fromJson<DateTime>(json['dateModified']),
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
      'dateModified': serializer.toJson<DateTime>(dateModified),
    };
  }

  SitemarkerRecordsData copyWith(
          {int? id,
          String? name,
          String? url,
          String? tags,
          bool? isDeleted,
          DateTime? dateAdded,
          DateTime? dateModified}) =>
      SitemarkerRecordsData(
        id: id ?? this.id,
        name: name ?? this.name,
        url: url ?? this.url,
        tags: tags ?? this.tags,
        isDeleted: isDeleted ?? this.isDeleted,
        dateAdded: dateAdded ?? this.dateAdded,
        dateModified: dateModified ?? this.dateModified,
      );
  SitemarkerRecordsData copyWithCompanion(SitemarkerRecordsCompanion data) {
    return SitemarkerRecordsData(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      url: data.url.present ? data.url.value : this.url,
      tags: data.tags.present ? data.tags.value : this.tags,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      dateAdded: data.dateAdded.present ? data.dateAdded.value : this.dateAdded,
      dateModified: data.dateModified.present
          ? data.dateModified.value
          : this.dateModified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SitemarkerRecordsData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('url: $url, ')
          ..write('tags: $tags, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('dateAdded: $dateAdded, ')
          ..write('dateModified: $dateModified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, url, tags, isDeleted, dateAdded, dateModified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SitemarkerRecordsData &&
          other.id == this.id &&
          other.name == this.name &&
          other.url == this.url &&
          other.tags == this.tags &&
          other.isDeleted == this.isDeleted &&
          other.dateAdded == this.dateAdded &&
          other.dateModified == this.dateModified);
}

class SitemarkerRecordsCompanion
    extends UpdateCompanion<SitemarkerRecordsData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> url;
  final Value<String> tags;
  final Value<bool> isDeleted;
  final Value<DateTime> dateAdded;
  final Value<DateTime> dateModified;
  const SitemarkerRecordsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.url = const Value.absent(),
    this.tags = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.dateModified = const Value.absent(),
  });
  SitemarkerRecordsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String url,
    required String tags,
    this.isDeleted = const Value.absent(),
    this.dateAdded = const Value.absent(),
    this.dateModified = const Value.absent(),
  })  : name = Value(name),
        url = Value(url),
        tags = Value(tags);
  static Insertable<SitemarkerRecordsData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? url,
    Expression<String>? tags,
    Expression<bool>? isDeleted,
    Expression<DateTime>? dateAdded,
    Expression<DateTime>? dateModified,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (url != null) 'url': url,
      if (tags != null) 'tags': tags,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (dateAdded != null) 'date_added': dateAdded,
      if (dateModified != null) 'date_modified': dateModified,
    });
  }

  SitemarkerRecordsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String>? url,
      Value<String>? tags,
      Value<bool>? isDeleted,
      Value<DateTime>? dateAdded,
      Value<DateTime>? dateModified}) {
    return SitemarkerRecordsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      tags: tags ?? this.tags,
      isDeleted: isDeleted ?? this.isDeleted,
      dateAdded: dateAdded ?? this.dateAdded,
      dateModified: dateModified ?? this.dateModified,
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
    if (dateModified.present) {
      map['date_modified'] = Variable<DateTime>(dateModified.value);
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
          ..write('dateAdded: $dateAdded, ')
          ..write('dateModified: $dateModified')
          ..write(')'))
        .toString();
  }
}

class DatabaseAtV3 extends GeneratedDatabase {
  DatabaseAtV3(QueryExecutor e) : super(e);
  late final SitemarkerRecords sitemarkerRecords = SitemarkerRecords(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [sitemarkerRecords];
  @override
  int get schemaVersion => 3;
}
