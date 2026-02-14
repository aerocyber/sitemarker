import 'package:flutter/material.dart';
import 'package:sitemarker/ui_desktop/home_screen.dart';
import 'package:sitemarker/ui_desktop/router.dart';

class DesktopApp extends StatefulWidget {
  const DesktopApp({super.key});

  @override
  State<DesktopApp> createState() => _DesktopAppState();
}

class _DesktopAppState extends State<DesktopApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Sitemarker",
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
