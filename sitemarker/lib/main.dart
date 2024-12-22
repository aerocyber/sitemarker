import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sitemarker/ui/pages/home_screen.dart';
import 'package:sitemarker/core/data_types/settings/sm_theme.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:sitemarker/core/settings_provider.dart';

late SmTheme the;

/// The main function!
void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  the = SmTheme();
  if (args.isNotEmpty) {
    if (args.contains('--url')) {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SmdbProvider>(
              create: (_) => SmdbProvider(),
            ),
            ChangeNotifierProvider<SMSettingsProvider>(
              create: (_) => SMSettingsProvider(),
            ),
          ],
          child: SMApp(url: args[args.indexOf('--url') + 1]),
        ),
      );
    } else {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<SmdbProvider>(
              create: (_) => SmdbProvider(),
            ),
            ChangeNotifierProvider<SMSettingsProvider>(
              create: (_) => SMSettingsProvider(),
            ),
          ],
          child: const SMApp(),
        ),
      );
    }
  } else {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<SmdbProvider>(
            create: (_) => SmdbProvider(),
          ),
          ChangeNotifierProvider<SMSettingsProvider>(
            create: (_) => SMSettingsProvider(),
          ),
        ],
        child: const SMApp(),
      ),
    );
  }
}

/// The app thing
class SMApp extends StatefulWidget {
  const SMApp({super.key, this.url});
  final String? url;

  @override
  State<SMApp> createState() => _SMAppState();
}

class _SMAppState extends State<SMApp> {
  late StreamSubscription _intentSub;
  final _sharedItems = <SharedMediaFile>[];
  String? url_;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      // Listen to media sharing coming from outside the app while the app is in the memory.
      _intentSub =
          ReceiveSharingIntent.instance.getMediaStream().listen((value) {
        setState(() {
          _sharedItems.clear();
          _sharedItems.addAll(value);
        });
      }, onError: (err) {
        // TODO: log error
      });

      // Get the media sharing coming from outside the app while the app is closed.
      ReceiveSharingIntent.instance.getInitialMedia().then((value) {
        setState(() {
          _sharedItems.clear();
          _sharedItems.addAll(value);

          // If the app is closed and the user shares a URL, open the app and navigate to the PageAdd screen.
          if (_sharedItems.isNotEmpty) {
            url_ = _sharedItems[0].path;
          }

          // Tell the library that we are done processing the intent.
          ReceiveSharingIntent.instance.reset();
        });
      });
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid) url_ = widget.url;
    return Consumer<SMSettingsProvider>(builder: (context, value, child) {
      ThemeMode themeMode = ThemeMode.system;
      String theme = value.getCurrentThemeMode();
      switch (theme) {
        case 'system':
          themeMode = ThemeMode.system;
          break;
        case 'light':
          themeMode = ThemeMode.light;
          break;
        case 'dark':
          themeMode = ThemeMode.dark;
          break;
      }
      return MaterialApp(
        title: 'Sitemarker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        themeMode: themeMode,
        darkTheme: ThemeData(brightness: Brightness.dark),
        home: SMHomeScreen(
          url: url_,
        ),
      );
    });
  }
}
