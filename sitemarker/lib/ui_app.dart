import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/providers/settings_provider.dart';
import 'package:sitemarker/router.dart';

class UIApp extends StatefulWidget {
  const UIApp({super.key});

  @override
  State<UIApp> createState() => _UIAppState();
}

class _UIAppState extends State<UIApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, value, child) {
        return MaterialApp.router(
          title: "Sitemarker",
          debugShowCheckedModeBanner: false,
          routerConfig: router,
          darkTheme: ThemeData.dark(useMaterial3: true),
          theme: ThemeData(useMaterial3: true),
          themeMode: _getThemeMode(value.themeModeValue),
        );
      },
    );
  }

  ThemeMode _getThemeMode(String value) {
    switch (value) {
      case 'lightTheme':
        return ThemeMode.light;
      case 'darkTheme':
        return ThemeMode.dark;
      case 'systemTheme':
        return ThemeMode.system;
      default:
        return ThemeMode.system;
    }
  }
}
