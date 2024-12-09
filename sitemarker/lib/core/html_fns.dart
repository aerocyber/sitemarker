import 'package:html/dom.dart';
import 'package:html/parser.dart' show parse;
import 'package:sitemarker/core/data_types/userdata/sm_record.dart';

class HtmlFns {
  static List<SmRecord> fromHtml(String htmlString) {
    List<SmRecord> ret = [];
    List<String> data = [];
    Document document = parse(htmlString);

    // Get the inner html of dt elements
    for (int i = 0; i < document.getElementsByTagName('dt').length; i++) {
      data.add(document.getElementsByTagName('dt')[i].innerHtml);
    }

    // Get each item
    for (int i = 0; i < data.length; i++) {
      Document aElement = parse(data[i]);
      int len = aElement.getElementsByTagName('a').length;
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
}

// TODO: To remove the following driver code for testing
int main() {
  return 0;
}
