import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/providers/data_provider.dart';
import 'package:sitemarker/core/providers/settings_provider.dart';
import 'package:sitemarker/ui_app.dart';
import 'package:sitemarker/desktop_cli_app.dart';
import 'package:universal_io/io.dart';

Future<void> legacyPermissionHandler() async {
  if (await Permission.storage.isDenied) {
    await Permission.storage.request();
  }
}

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    if (args.isNotEmpty) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DataProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ],
          child: DesktopCliApp(args: args),
        ),
      );
    } else {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => DataProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ],
          child: UIApp(),
        ),
      );
    }
  } else {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => DataProvider()),
          ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ],
        child: UIApp(),
      ),
    );
  }
}
