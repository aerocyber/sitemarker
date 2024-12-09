import 'package:sitemarker/core/html_fns.dart';
import 'package:validators/validators.dart' as validators;
import 'package:http/http.dart' as http;

/// Class with methods aiding in various things related to data management
class DataHelper {
  /// Get the title of the HTML page which is pointed by the url
  static Future<String> getPageTitleFromURL(String url) async {
    if (!validators.isURL(url)) {
      throw Exception('Invalid URL');
    }

    String title = '';
    String respHttp = '';

    final Uri uri = Uri.parse(url);
    try {
      http.Response r = await http.get(uri);
      if (r.statusCode == 200) {
        respHttp = r.body;
        title = HtmlFns.getTitle(respHttp);
      } else if (r.statusCode >= 400 && r.statusCode < 500) {
        throw Exception('Client side request failed');
      }
    } on Exception {
      rethrow;
    }

    return title;
  }
}
