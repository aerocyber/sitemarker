import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sitemarker/logging/logger_api.dart';
import 'package:sitemarker/pages/page_view_all.dart';
import 'package:sitemarker/settings/settings.dart';
import 'package:sitemarker/settings/themes/themes.dart';
import 'package:universal_io/io.dart';
import 'package:sitemarker/data/db_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitemarker/pages/page_view_omio.dart';
import 'package:sitemarker/settings/themes/default/theme.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  LoggerApi log = LoggerApi();
  log.log("Initialized logger", 'info', null);
  SharedPreferences sp = await SharedPreferences.getInstance();
  if (args.isNotEmpty) {
    log.log("Got command line argument: ${args[0]}", 'info', null);
    runApp(MultiProvider(
      providers: [
        Provider<DBRecordProvider>(
          create: (_) => DBRecordProvider(),
        ),
        Provider<ThemesProvider>(
          create: (_) => ThemesProvider(),
        ),
      ],
      child: SitemarkerApp(
        showOmio: true,
        path: args[0],
        logger: log,
        sp: sp,
      ),
    ));
  } else {
    log.log("No command line argument", 'info', null);
    runApp(SitemarkerApp(
      showOmio: false,
      path: null,
      logger: log,
      sp: sp,
    ));
  }
}

class SitemarkerApp extends StatefulWidget {
  const SitemarkerApp(
      {super.key,
      required this.showOmio,
      required this.path,
      required this.logger,
      required this.sp});

  final bool showOmio;
  final String? path;
  final LoggerApi logger;
  final SharedPreferences sp;

  @override
  State<SitemarkerApp> createState() => _SitemarkerAppState();
}

class _SitemarkerAppState extends State<SitemarkerApp> {
  late StreamSubscription intentSub;
  final sharedFiles = <SharedMediaFile>[];
  bool intentShow = false;
  late ThemeData light;
  late ThemeData dark;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      // Intent when app in memory
      intentSub =
          ReceiveSharingIntent.instance.getMediaStream().listen((value) {
        setState(() {
          sharedFiles.clear();
          sharedFiles.addAll(value);
          intentShow = true;
        });
      }, onError: (err) {
        widget.logger
            .log("getIntentDataStream Error encountered", 'error', err);
      });
      // Intent when app is closed
      ReceiveSharingIntent.instance.getInitialMedia().then((value) {
        setState(() {
          sharedFiles.clear();
          sharedFiles.addAll(value);
          ReceiveSharingIntent.instance.reset();
          intentShow = true;
        });
      });
    }
  }

  @override
  void dispose() {
    intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MaterialTheme mt = const MaterialTheme();
    if (!intentShow) {
      if (widget.showOmio == true) {
        if (widget.path != null) {
          return ChangeNotifierProvider(
            create: (context) => ThemesProvider(),
            child: Consumer<ThemesProvider>(builder: (context, state, child) {
              return ChangeNotifierProvider(
                create: (_) => DBRecordProvider(),
                child: MaterialApp(
                  title: 'Sitemarker',
                  debugShowCheckedModeBanner: false,
                  theme:
                      state.darkTheme ? dark = mt.dark() : light = mt.light(),
                  home: PageViewOmio(path: widget.path as String),
                ),
              );
            }),
          );
        } else {
          return ChangeNotifierProvider(
            create: (context) => ThemesProvider(),
            child: Consumer<ThemesProvider>(builder: (context, state, child) {
              return ChangeNotifierProvider<DBRecordProvider>(
                create: (_) => DBRecordProvider(),
                child: MaterialApp(
                  title: 'Sitemarker',
                  debugShowCheckedModeBanner: false,
                  theme:
                      state.darkTheme ? dark = mt.dark() : light = mt.light(),
                  home: const SitemarkerHomePage(),
                ),
              );
            }),
          );
        }
      } else {
        return ChangeNotifierProvider(
          create: (context) => ThemesProvider(),
          child: Consumer<ThemesProvider>(builder: (context, state, child) {
            return ChangeNotifierProvider<DBRecordProvider>(
              create: (_) => DBRecordProvider(),
              child: MaterialApp(
                title: 'Sitemarker',
                debugShowCheckedModeBanner: false,
                theme: state.darkTheme ? dark = mt.dark() : light = mt.light(),
                home: const SitemarkerHomePage(),
              ),
            );
          }),
        );
      }
    } else {
      return ChangeNotifierProvider(
        create: (context) => ThemesProvider(),
        child: Consumer<ThemesProvider>(builder: (context, state, child) {
          return ChangeNotifierProvider<DBRecordProvider>(
            create: (_) => DBRecordProvider(),
            child: MaterialApp(
              title: 'Sitemarker',
              debugShowCheckedModeBanner: false,
              theme: state.darkTheme ? dark = mt.dark() : light = mt.light(),
              home: PageViewOmio(
                path: sharedFiles[0].path,
              ),
            ),
          );
        }),
      );
    }
  }
}

class SitemarkerHomePage extends StatefulWidget {
  const SitemarkerHomePage({super.key});

  @override
  State<SitemarkerHomePage> createState() => _SitemarkerHomePageState();
}

class _SitemarkerHomePageState extends State<SitemarkerHomePage> {
  int currentPage = 0;

  void changePage(int newPageIndex) {
    setState(() {
      currentPage = newPageIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: <Widget>[
        const PageViewAll(),
        const PageSettings(),
      ][currentPage], // TODO: Fill in those widgets
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: currentPage,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        onDestinationSelected: (int index) {
          changePage(index);
        },
        destinations: <Widget>[
          NavigationDestination(
            icon: currentPage == 0
                ? Icon(
                    Icons.home,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : Icon(
                    Icons.home_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: currentPage == 1
                ? Icon(
                    Icons.settings,
                    color: Theme.of(context).colorScheme.primary,
                  )
                : Icon(
                    Icons.settings_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
