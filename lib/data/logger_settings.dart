import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:universal_io/io.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class LoggerOutput extends LogOutput {
  String filename;
  LoggerOutput({required this.filename});

  Future<String> get _localPath async {
    if (kIsWeb) {
      return "_console";
    }
    final dir = await getApplicationSupportDirectory();
    return dir.path;
  }

  Future<File> _localFile() async {
    if (kIsWeb) {
      throw UnsupportedError("Files not supported on Web.");
    }
    final path = await _localPath;
    return File('$path/$filename');
  }

  @override
  void output(OutputEvent event) async {
    FileWrite out;
    if (kIsWeb) {
      out = FileWrite(file: null, isConsole: true);
    } else {
      File file = await _localFile();
      out = FileWrite(file: file, isConsole: false);
    }
    for (var line in event.lines) {
      out.write(line);
    }
  }
}

class FileWrite {
  File? file;
  bool isConsole;
  FileWrite({required this.file, required this.isConsole});
  void write(String text) {
    if (isConsole) {
      print(text);
    } else {
      if (file == null) {
        throw Exception("The logger is set to file. But no file peovided.");
      } else {
        if (!file!.existsSync()) {
          file!.createSync(recursive: true, exclusive: false);
        }
        file!.writeAsStringSync(text, mode: FileMode.append);
      }
    }
  }
}
