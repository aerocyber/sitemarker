import 'dart:async';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

enum LogLevel { debug, info, warning, error, fatal }

class LogManager {
  static final LogManager instance = LogManager._internal();
  LogManager._internal();

  // Config
  LogLevel _currentLogLevel = LogLevel.info;
  final int _maxFileSizeBytes = 5 * 1024 * 1024; // 5MB deterministic limit

  late Directory _logsDir;
  late File _currentLog;
  late File _bkpLog;

  // Queue state
  final _logStreamController = StreamController<String>();
  final List<String> _writeBuffer = [];
  bool _isWriting = false;

  /// Timestamp format for the log entry (DD-MM-YYYY HH:mm:ss)
  String _getFormattedTimestamp(DateTime now) {
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year.toString().padLeft(4, '0');
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');

    return '$day-$month-$year $hour:$minute:$second';
  }

  /// Initialization & Startup Rotation
  Future<void> initialize(LogLevel savedUserSetting) async {
    _currentLogLevel = savedUserSetting;

    final supportDir = await getApplicationSupportDirectory();
    _logsDir = Directory(p.join(supportDir.path, 'sitemarker', 'logs'));

    if (!await _logsDir.exists()) {
      await _logsDir.create(recursive: true);
    }

    _currentLog = File('${_logsDir.path}/sitemarker.log');
    _bkpLog = File('${_logsDir.path}/sitemarker.log.bkp');

    // Startup rotation (keep exactly 2 files - current log and the previous log)
    await _rotateLogs();

    // Start listening to the UI-safe queue
    _logStreamController.stream.listen(_onLogReceived);
  }

  /// Updates the log level purely based on User Settings (ignores Release/Debug modes)
  void setLogLevel(LogLevel newLevel) {
    _currentLogLevel = newLevel;
  }

  /// The Deterministic Rotation Logic
  Future<void> _rotateLogs() async {
    if (await _currentLog.exists()) {
      // Overwrite the old backup with the current log
      if (await _bkpLog.exists()) {
        await _bkpLog.delete();
      }
      await _currentLog.rename(_bkpLog.path);
    }
    // Create a fresh current log
    await _currentLog.create();
  }

  /// The Public Logging API
  void log(LogLevel level, String message) {
    // Strict Settings Check: Drop logs below the user's configured threshold
    if (level.index < _currentLogLevel.index) return;

    final timestamp = _getFormattedTimestamp(DateTime.now());
    final levelStr = level.name.toUpperCase();

    // Exact format: [<timestamp in DD-MM-YYYY HH:MM:SS>]: [<log level>]: <event>
    final formattedMessage = '[$timestamp]: [$levelStr]: $message\n';

    // Drop into the async queue so the UI thread is never blocked
    if (!_logStreamController.isClosed) {
      _logStreamController.add(formattedMessage);
    }
  }

  /// The Non-Blocking Writer Loop
  Future<void> _onLogReceived(String message) async {
    _writeBuffer.add(message);
    _processBuffer();
  }

  Future<void> _processBuffer() async {
    if (_isWriting || _writeBuffer.isEmpty) return;
    _isWriting = true;

    try {
      final batch = _writeBuffer.join('');
      _writeBuffer.clear();

      // Enforce deterministic size during active sessions
      if (await _currentLog.exists() &&
          (await _currentLog.length()) >= _maxFileSizeBytes) {
        await _rotateLogs();
      }

      await _currentLog.writeAsString(
        batch,
        mode: FileMode.append,
        flush: true,
      );
    } catch (e) {
      print('Disk write failed: $e');
    } finally {
      _isWriting = false;
      // Flush anything that arrived while writing
      if (_writeBuffer.isNotEmpty) {
        _processBuffer();
      }
    }
  }

  /// UI Export Methods (Helper functions)

  /// Returns the actual File objects separately (e.g., for standard share sheets)
  Future<Map<String, File?>> exportSeparately() async {
    final Map<String, File?> availableLogs = {
      "Backup Log": null,
      "Current Log": null,
    };
    if (await _currentLog.exists()) availableLogs["Current Log"] = _currentLog;
    if (await _bkpLog.exists()) availableLogs["Backup Log"] = _bkpLog;
    return availableLogs;
  }

  /// Zips both logs into a single package for API upload or UI dumping
  Future<File?> exportAsZip() async {
    try {
      final zipPath = '${_logsDir.path}/sitemarker_logs_export.zip';
      final zipFile = File(zipPath);

      if (await zipFile.exists()) {
        await zipFile.delete();
      }

      final encoder = ZipFileEncoder();
      encoder.create(zipPath);

      if (await _currentLog.exists()) {
        encoder.addFile(_currentLog);
      }
      if (await _bkpLog.exists()) {
        encoder.addFile(_bkpLog);
      }

      encoder.close();
      return zipFile;
    } catch (e) {
      log(LogLevel.error, 'Failed to create zip export: $e');
      return null;
    }
  }

  void dispose() async {
    await _logStreamController.close();

    if (_writeBuffer.isNotEmpty) {
      final batch = _writeBuffer.join('');
      _writeBuffer.clear();
      if (await _currentLog.exists()) {
        await _currentLog.writeAsString(
          batch,
          mode: FileMode.append,
          flush: true,
        );
      }
    }
  }
}
