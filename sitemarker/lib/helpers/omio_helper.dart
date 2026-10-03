import 'dart:convert';
import 'package:crypto/crypto.dart';

class SmOmioItem {
  final int id;
  final String type; // 'folder' or 'record'
  final int parentId;
  final String name;
  final String? url;
  final DateTime? dateAdded;
  final List<String> tags;
  final String? notes;

  SmOmioItem({
    required this.id,
    required this.type,
    required this.parentId,
    required this.name,
    this.url,
    this.dateAdded,
    this.tags = const [],
    this.notes,
  });
}

class OmioHelper {
  OmioHelper._();

  static const String _currentVersion = "4.3";

  /// EXPORT TO: Generates a strict .omio v4.3 file with relational IDs.
  static String exportTo(List<SmOmioItem> items) {
    final dataSection = <String, dynamic>{};

    for (final item in items) {
      String jsonKey = item.name;
      int counter = 1;
      while (dataSection.containsKey(jsonKey)) {
        jsonKey = '${item.name} ($counter)';
        counter++;
      }

      final payload = <String, dynamic>{
        "ID": item.id,
        "Type": item.type,
        "Parent ID": item.parentId,
      };

      if (item.type == 'record') {
        payload["URL"] = item.url ?? '';
        payload["Added On"] = (item.dateAdded ?? DateTime.now())
            .toIso8601String();
        if (item.tags.isNotEmpty) {
          payload["Categories"] = item.tags.join(', ');
        }
        if (item.notes != null && item.notes!.trim().isNotEmpty) {
          payload["Notes"] = item.notes!.trim();
        }
      }

      dataSection[jsonKey] = payload;
    }

    final dataJsonString = jsonEncode(dataSection);
    final dataHash = sha256.convert(utf8.encode(dataJsonString)).toString();

    final headerSection = {
      "Omio Version": _currentVersion,
      "Data Hash": dataHash,
      "Record Count": items.length,
      "Created On": DateTime.now().toIso8601String(),
    };

    final headerHash = sha256
        .convert(utf8.encode(jsonEncode(headerSection)))
        .toString();

    return const JsonEncoder.withIndent('  ').convert({
      "Header": headerSection,
      "Data": dataSection,
      "Omio Info": {"Header Hash": headerHash},
    });
  }

  /// VALIDATE: Checks structural integrity and hashes. Returns version string if valid, else null.
  static String? validate(String fileContent) {
    try {
      if (fileContent.trim().isEmpty) return null;
      final parsed = jsonDecode(fileContent) as Map<String, dynamic>;

      if (!parsed.containsKey('Header') ||
          !parsed.containsKey('Data') ||
          !parsed.containsKey('Omio Info')) {
        return null;
      }

      final header = parsed['Header'] as Map<String, dynamic>;
      final data = parsed['Data'] as Map<String, dynamic>;
      final omioInfo = parsed['Omio Info'] as Map<String, dynamic>;

      final version = header['Omio Version']?.toString();
      if (version != "4.2" && version != "4.3") return null;

      if (header['Data Hash'] !=
          sha256.convert(utf8.encode(jsonEncode(data))).toString()) {
        return null;
      }
      if (omioInfo['Header Hash'] !=
          sha256.convert(utf8.encode(jsonEncode(header))).toString()) {
        return null;
      }

      return version;
    } catch (_) {
      return null;
    }
  }

  /// IMPORT FROM: Parses both 4.2 (flat records) and 4.3 (relational folders/records).
  static List<SmOmioItem> importFrom(String fileContent) {
    final version = validate(fileContent);
    if (version == null) {
      // TODO: Logging
      throw const FormatException('Invalid or unsupported Omio file or corrupted hashes.');
    }

    final parsed = jsonDecode(fileContent) as Map<String, dynamic>;
    final data = parsed['Data'] as Map<String, dynamic>;
    final List<SmOmioItem> extracted = [];

    int legacyIdCounter = 1; // Used to generate IDs for 4.2 records

    data.forEach((name, details) {
      try {
        final Map<String, dynamic> itemData = details;
        final originalName = name.replaceFirst(RegExp(r'\s\(\d+\)$'), '');

        if (version == "4.2") {
          // 4.2 fallback: Treat everything as a record in the root folder (Parent ID 0)
          final tags = (itemData['Categories']?.toString() ?? '')
              .split(',')
              .map((t) => t.trim())
              .where((t) => t.isNotEmpty)
              .toList();
          final addedOnStr = itemData['Added On']?.toString();

          extracted.add(
            SmOmioItem(
              id: legacyIdCounter++,
              type: 'record',
              parentId: 0,
              name: originalName,
              url: itemData['URL']?.toString() ?? '',
              dateAdded: addedOnStr != null
                  ? DateTime.tryParse(addedOnStr)
                  : DateTime.now(),
              tags: tags,
              notes: itemData['Notes']?.toString(),
            ),
          );
        } else {
          // 4.3 standard parsing
          final type = itemData['Type']?.toString() ?? 'record';
          final tags = (itemData['Categories']?.toString() ?? '')
              .split(',')
              .map((t) => t.trim())
              .where((t) => t.isNotEmpty)
              .toList();
          final addedOnStr = itemData['Added On']?.toString();

          extracted.add(
            SmOmioItem(
              id: itemData['ID'] as int,
              type: type,
              parentId: itemData['Parent ID'] as int,
              name: originalName,
              url: itemData['URL']?.toString(),
              dateAdded: addedOnStr != null
                  ? DateTime.tryParse(addedOnStr)
                  : null,
              tags: tags,
              notes: itemData['Notes']?.toString(),
            ),
          );
        }
      } catch (_) {} // Skip malformed nodes
    });

    return extracted;
  }
}
