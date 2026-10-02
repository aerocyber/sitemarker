// COPYRIGHT NOTICE
// THIS ENTIRE FILE IS WRITTEN WITH GEMINI 3.1 PRO
// NOTICE AS THE FILE FORMAT HAS NOT BEEN REVIEWED.

import 'package:sitemarker/core/data_types/sm_record.dart';

/// A pure data class representing a bookmark extracted from an HTML file
class SmHtmlBookmark {
  final String title;
  final String url;
  final DateTime? dateAdded;
  final List<String> tags;
  final List<String> folderPath;

  SmHtmlBookmark({
    required this.title,
    required this.url,
    this.dateAdded,
    this.tags = const [],
    this.folderPath = const [],
  });
}

/// A summary payload returned by the 'view' method
class BookmarkHtmlSummary {
  final bool isValid;
  final int totalBookmarks;
  final int totalFolders;
  final List<SmHtmlBookmark> preview;

  BookmarkHtmlSummary({
    required this.isValid,
    required this.totalBookmarks,
    required this.totalFolders,
    this.preview = const [],
  });
}

class BookmarkHtmlHelper {
  BookmarkHtmlHelper._();

  static const String _netscapeHeader = 'NETSCAPE-Bookmark-file-1';

  /// 1. VALIDATE: Checks if the file contains the universal Netscape bookmark signature
  static bool validate(String fileContent) {
    if (fileContent.trim().isEmpty) return false;
    return fileContent.contains(RegExp(_netscapeHeader, caseSensitive: false));
  }

  /// 2. IMPORT FROM: A highly robust, stack-based parser for Netscape HTML files.
  /// Supports Chromium, Firefox, Safari, and legacy formats dating back to 2015.
  static List<SmHtmlBookmark> importFrom(String fileContent) {
    if (!validate(fileContent)) {
      throw const FormatException(
        'Invalid or missing Netscape Bookmark header.',
      );
    }

    final List<SmHtmlBookmark> extracted = [];
    final List<String> folderStack = [];
    String nextFolderName = '';

    // Removed the unnecessary backslashes before the forward slashes (e.g., <\/h3> -> </h3>)
    final tokenScanner = RegExp(
      r'<(h3)[^>]*>(.*?)</h3>|<(dl)[^>]*>|</(dl)>|<(a)\s+([^>]+)>(.*?)</a>',
      caseSensitive: false,
      dotAll: true,
    );

    for (final match in tokenScanner.allMatches(fileContent)) {
      if (match.group(1) != null) {
        // Token is <H3> -> This is a folder name
        nextFolderName = _decodeHtmlEntities(match.group(2) ?? '').trim();
      } else if (match.group(3) != null) {
        // Token is <DL> -> Entering a new nested list (folder)
        folderStack.add(
          nextFolderName.isNotEmpty ? nextFolderName : 'Bookmarks Menu',
        );
        nextFolderName = ''; // Reset for the next folder
      } else if (match.group(4) != null) {
        // Token is </DL> -> Exiting the current folder
        if (folderStack.isNotEmpty) {
          folderStack.removeLast();
        }
      } else if (match.group(5) != null) {
        // Token is <A> -> This is a bookmark record
        final attrs = match.group(6) ?? '';
        final title = _decodeHtmlEntities(match.group(7) ?? '').trim();

        // Extract URL using backreferences to allow single quotes inside double quotes
        final urlMatch = RegExp(
          r'''href=(["'])(.*?)\1''',
          caseSensitive: false,
        ).firstMatch(attrs);
        final url = urlMatch?.group(2)?.trim() ?? '';

        if (url.isEmpty || (!url.startsWith('http') && !url.startsWith('ftp')))
          continue;

        // Extract ADD_DATE (Unix Timestamp)
        DateTime? dateAdded;
        final dateMatch = RegExp(
          r'''add_date=(["'])(\d+)\1''',
          caseSensitive: false,
        ).firstMatch(attrs);
        if (dateMatch != null && dateMatch.group(2) != null) {
          final seconds = int.tryParse(dateMatch.group(2)!);
          if (seconds != null) {
            dateAdded = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
          }
        }

        // Extract TAGS (Firefox specific, usually comma-separated)
        List<String> tags = [];
        final tagsMatch = RegExp(
          r'''tags=(["'])(.*?)\1''',
          caseSensitive: false,
        ).firstMatch(attrs);
        if (tagsMatch != null && tagsMatch.group(2) != null) {
          tags = tagsMatch
              .group(2)!
              .split(',')
              .map((t) => t.trim())
              .where((t) => t.isNotEmpty)
              .toList();
        }

        extracted.add(
          SmHtmlBookmark(
            title: title.isEmpty ? url : title,
            url: url,
            dateAdded: dateAdded,
            tags: tags,
            folderPath: List.from(folderStack),
          ),
        );
      }
    }

    return extracted;
  }

  /// 3. VIEW: Provides a metadata summary for previewing the file before a full import
  static BookmarkHtmlSummary view(String fileContent) {
    final isValid = validate(fileContent);
    if (!isValid) {
      return BookmarkHtmlSummary(
        isValid: false,
        totalBookmarks: 0,
        totalFolders: 0,
      );
    }

    final bookmarks = importFrom(fileContent);

    // Calculate unique folders found in the paths
    final Set<String> uniqueFolders = {};
    for (var b in bookmarks) {
      if (b.folderPath.isNotEmpty) {
        uniqueFolders.add(b.folderPath.join(' > '));
      }
    }

    return BookmarkHtmlSummary(
      isValid: true,
      totalBookmarks: bookmarks.length,
      totalFolders: uniqueFolders.length,
      preview: bookmarks.take(15).toList(),
    );
  }

  /// 4. EXPORT TO: Generates a strictly formatted Netscape Bookmark HTML string.
  static String exportTo(List<SmRecord> records) {
    final buffer = StringBuffer();

    buffer.writeln('<!DOCTYPE NETSCAPE-Bookmark-file-1>');
    buffer.writeln('<!-- This is an automatically generated file. -->');
    buffer.writeln(
      '<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">',
    );
    buffer.writeln('<TITLE>Bookmarks</TITLE>');
    buffer.writeln('<H1>Sitemarker Export</H1>');
    buffer.writeln('<DL><p>');

    for (final record in records) {
      final url = _escapeHtmlEntities(record.url);
      final title = _escapeHtmlEntities(record.name);
      final epoch = record.dateAdded.millisecondsSinceEpoch ~/ 1000;

      final tagsStr = record.tags
          .map((t) => _escapeHtmlEntities(t.name))
          .join(',');
      final tagsAttr = tagsStr.isNotEmpty ? ' TAGS="$tagsStr"' : '';

      buffer.writeln(
        '    <DT><A HREF="$url" ADD_DATE="$epoch"$tagsAttr>$title</A>',
      );
    }

    buffer.writeln('</DL><p>');

    return buffer.toString();
  }

  // --- Lightweight Internal Helpers ---

  static String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&#x27;', "'")
        .replaceAll('&nbsp;', ' ');
  }

  static String _escapeHtmlEntities(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;');
  }
}
