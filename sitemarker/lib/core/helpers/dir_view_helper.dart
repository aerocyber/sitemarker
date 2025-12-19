import 'package:sitemarker/core/db/sm_db.dart';

class DirView {
  final List<SitemarkerRecord> records;
  final List<Folder> subdirs;

  const DirView({required this.records, required this.subdirs});
}
