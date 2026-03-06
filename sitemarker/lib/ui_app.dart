import 'package:flutter/material.dart';
import 'package:sitemarker/router.dart';

class UIApp extends StatefulWidget {
  const UIApp({super.key});

  @override
  State<UIApp> createState() => _UIAppState();
}

class _UIAppState extends State<UIApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Sitemarker",
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
