import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/providers/data_provider.dart';
import 'package:sitemarker/core/providers/settings_provider.dart';
import 'package:sitemarker/desktop_app.dart';
import 'package:sitemarker/desktop_cli_app.dart';
import 'package:sitemarker/mobile_app.dart';
import 'package:universal_io/io.dart';

Future<void> legacyPermissionHandler() async {
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }
}

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  late final StatefulWidget app;

  if (Platform.isAndroid || Platform.isIOS) {
    app = MobileApp();
  } else if (Platform.isLinux || Platform.isWindows) {
    if (args.isNotEmpty) {
      app = DesktopCliApp(
        args: args,
      );
    }
    app = DesktopApp();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DataProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: app,
    ),
  );
}
