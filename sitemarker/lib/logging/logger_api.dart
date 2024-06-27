import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

class FileLogger extends LogOutput {
  late File file;

  FileLogger() {
    file = File("${getLogFileLocation()}/${getLogFileName()}");
  }

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      file.writeAsStringSync(
        line,
        mode: FileMode.append,
      );
    }
  }

  Future<String> getLogFileLocation() async {
    Directory dir = await getApplicationSupportDirectory();
    return dir.path;
  }

  String getLogFileName() {
    if (kDebugMode) {
      return 'sitemarker-log-DEBUG.log';
    }
    return 'sitemarker-log.log';
  }
}

class LoggerApi {
  Logger loggerObj = Logger(
    filter: null,
    printer: PrettyPrinter(
      methodCount: 5,
      errorMethodCount: 10,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    output: FileLogger(),
  );

  void log(String msg, String level, String? errMsg) {
    if (level.toLowerCase() == 'warn') {
      loggerObj.w(msg, time: DateTime.now());
    } else if (level.toLowerCase() == 'info') {
      loggerObj.i(msg, time: DateTime.now());
    } else if (level.toLowerCase() == 'error') {
      String errmsg;
      if (errMsg == null) {
        errmsg = msg;
      } else {
        errmsg = errMsg;
      }
      loggerObj.e(msg, time: DateTime.now(), error: errmsg);
    }
  }
}
