import 'package:html/parser.dart' as html_parser;
import 'package:sitemarker/core/logging/logger.dart';

class HtmlParser {
  HtmlParser._();

  /// Parses the HTML string into a DOM tree and extracts the <title> text.
  /// Returns null if no title exists or the parsing fails.
  static String? fetchTitleFromHtml(String? htmlContent) {
    if (htmlContent == null || htmlContent.trim().isEmpty) return null;

    try {
      // Parses the string into a full DOM Document
      final document = html_parser.parse(htmlContent);

      final titleElement = document.querySelector('title');

      if (titleElement != null && titleElement.text.trim().isNotEmpty) {
        // The .text property automatically decodes HTML entities (like &amp;)
        // and strips out any nested tags if they somehow exist.
        LogManager.instance.log(LogLevel.info, "Found non empty html title");
        return titleElement.text.trim();
      }

      LogManager.instance.log(
        LogLevel.warning,
        "No title or empty title found in html content passed",
      );
      return null;
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'HtmlParser: Failed to parse DOM -> $e\n$stack',
      );
      return null;
    }
  }
}
