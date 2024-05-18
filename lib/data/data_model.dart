import 'package:drift/drift.dart';
// import 'package:sitemarker/data/logger_settings.dart';
import 'package:sitemarker/data/shared_db.dart' as impl;
// import 'package:logger/logger.dart';

part 'data_model.g.dart';

@DriftDatabase(tables: [SitemarkerRecords])
class SitemarkerDB extends _$SitemarkerDB {
  SitemarkerDB() : super(impl.connect());
  // Logger debuglogger = Logger(
  //   printer: PrettyPrinter(),
  //   output: LoggerOutput(filename: "sitemarker-devel.log"),
  // );
  // Logger prodLogger = Logger(
  //   printer: PrettyPrinter(),
  //   output: LoggerOutput(filename: "sitemarker.log"),
  // );

  @override
  int get schemaVersion => 1;

  // SELECTs
  Future<List<SitemarkerRecord>> get allRecords =>
      select(sitemarkerRecords).get();

  Future<List<SitemarkerRecord>> getRecordsByName(String name) {
    return (select(sitemarkerRecords)..where((t) => t.name.equals(name))).get();
  }

  Future<List<SitemarkerRecord>> getRecordsByTags(List<String> tags) async {
    List<SitemarkerRecord> toRet = [];
    List<SitemarkerRecord> tmp = [];
    List<SitemarkerRecord> srl = await select(sitemarkerRecords).get();

    for (int i = 0; i < srl.length; i++) {
      List<String> s = srl[i].tags.split(",");
      for (int j = 0; i < s.length; j++) {
        String str = s[i].trim();
        s[i] = str;
      }
      tmp.add(SitemarkerRecord(
        id: srl[i].id,
        name: srl[i].name,
        url: srl[i].url,
        tags: s.join(","),
        isDeleted: false,
      ));
    }

    for (int i = 0; i < tmp.length; i++) {
      List<String> tmpTags = tmp[i].tags.split(',');
      bool ignoreIter = false;
      for (int t = 0; t < tags.length; t++) {
        if (!tmpTags.contains(tags[i])) {
          tmp.removeAt(i);
          ignoreIter = true;
        }
      }
      if (ignoreIter) {
        break;
      }
    }

    toRet = tmp;

    return toRet;
  }

  // INSERT
  Future<int> insertRecord(SitemarkerRecord record) =>
      into(sitemarkerRecords).insert(record);

  // UPDATE
  Future<bool> updateRecord(SitemarkerRecord record) =>
      update(sitemarkerRecords).replace(record);

  // DELETE
  Future<int> deleteRecord(SitemarkerRecord record) =>
      delete(sitemarkerRecords).delete(record);
}

class SitemarkerRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  TextColumn get url => text()();
  TextColumn get tags => text()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}
