import 'package:http/http.dart' as http;
import 'package:sitemarker/core/logging/logger.dart';

class SMExternalConnection {
  SMExternalConnection._();

  /// Fetches the raw HTML string from a given URL.
  /// Returns null if the request fails, times out, or returns a non-200 status.
  static Future<String?> fetchHtmlPage(String urlString) async {
    try {
      final uri = Uri.tryParse(urlString);
      if (uri == null || !uri.hasScheme) {
        LogManager.instance.log(
          LogLevel.warning,
          'SMExternalConnection: Invalid URL format -> $urlString',
        );
        return null;
      }

      LogManager.instance.log(LogLevel.debug, 'Fetching HTML from: $urlString');

      // 10 seconds is a generous ceiling to prevent the UI from hanging on dead sites
      final response = await http
          .get(uri)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception('Request timed out after 10 seconds');
            },
          );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        LogManager.instance.log(
          LogLevel.warning,
          'SMExternalConnection: Failed with HTTP ${response.statusCode} -> $urlString',
        );
        return null;
      }
    } catch (e, stack) {
      LogManager.instance.log(
        LogLevel.error,
        'SMExternalConnection: Error fetching HTML -> $e\n$stack',
      );
      return null;
    }
  }
}
