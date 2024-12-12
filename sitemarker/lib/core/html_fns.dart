import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';

class HtmlFns {
  static String getTitle(String htmlString) {
    Document d = parse(htmlString);
    return d.getElementsByTagName('title')[0].innerHtml;
  }

  static List<SmRecord> fromHtml(String htmlString) {
    if (!htmlString.startsWith('''<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
     It will be read and overwritten.
     DO NOT EDIT! -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<meta http-equiv="Content-Security-Policy"
      content="default-src 'self'; script-src 'none'; img-src data: *; object-src 'none'"></meta>
<TITLE>Bookmarks</TITLE>''')) {
      throw Exception('Invalid HTML Bookmark file');
    }

    List<SmRecord> ret = [];
    List<String> data = [];
    Document document = parse(htmlString);
    Document aElement;
    int len;

    // Get the inner html of dt elements
    for (int i = 0; i < document.getElementsByTagName('dt').length; i++) {
      data.add(document.getElementsByTagName('dt')[i].innerHtml);
    }

    // Get each item
    for (int i = 0; i < data.length; i++) {
      aElement = parse(data[i]);
      len = aElement.getElementsByTagName('a').length;
      for (int j = 0; j < len; j++) {
        // Add it
        ret.add(
          SmRecord(
            name: aElement.getElementsByTagName('a')[j].innerHtml,
            url: aElement.getElementsByTagName('a')[j].attributes['href']!,
            tags:
                'imported on ${DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).toString()}',
            dt: DateTime.fromMillisecondsSinceEpoch(
              int.parse(aElement
                  .getElementsByTagName('a')[j]
                  .attributes['add_date']!),
            ),
          ),
        );
      }
    }
    return ret;
  }

  static String toHtml(List<SmRecord> recordsToHTMLify) {
    String returner = '''
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<!-- This is an automatically generated file.
     It will be read and overwritten.
     DO NOT EDIT! -->
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<meta http-equiv="Content-Security-Policy"
      content="default-src 'self'; script-src 'none'; img-src data: *; object-src 'none'"></meta>
<TITLE>Bookmarks</TITLE>

<DL><p>
''';
    String convertTemp;

    // Get each record
    for (int i = 0; i < recordsToHTMLify.length; i++) {
      convertTemp =
          '<dt><a href="${recordsToHTMLify[i].url}" add_date="${recordsToHTMLify[i].dt.millisecondsSinceEpoch}" last_modified="${DateTime.timestamp().millisecondsSinceEpoch}">${recordsToHTMLify[i].name}</a>';
      returner += convertTemp;
    }

    returner += "</p></dl>";

    return returner;
  }
}
