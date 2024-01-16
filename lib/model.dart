import 'package:objectbox/objectbox.dart';

@Entity()
class SitemarkerInternalRecord {
  @Id()
  int entryNo = 0;

  final String name;
  final String validUrl;
  final String tagString;

  SitemarkerInternalRecord(this.name, this.validUrl, this.tagString);
}
