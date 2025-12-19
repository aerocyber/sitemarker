import 'package:sitemarker/core/data_types/userdata/sm_record.dart';
import 'package:sitemarker/core/db/sqlitedb/sm_db.dart';
import 'package:flutter/material.dart';

class DataProvider extends ChangeNotifier {
  // Database (source of truth)
  late SitemarkerDB db;

  // Records with isDeleted = false
  List<SitemarkerRecord> _records = [];
  // Getter for records which are not deleted
  List<SitemarkerRecord> get records => _records;

}
