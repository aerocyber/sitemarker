import 'package:sitemarker/operations/errors.dart';

class SitemarkerRecord {
  /// Each record in Sitemarker is represented as a SitemarkerRecord object.
  late String name;
  late String url;
  late List<String> tags;

  SitemarkerRecord();

  void setRecord(String name, String url, List<String> tags) {
    if (isValidUrl(url)) {
      this.name = name;
      this.url = url;
      this.tags = tags;
    } else {
      throw InvalidUrlError(url);
    }
  }

  bool isValidUrl(String url) {
    /// Check if URL is valid.
    return Uri.parse(url).isAbsolute;
  }
}
