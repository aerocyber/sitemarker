import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/dbrecord_provider.dart';
import 'package:sitemarker/pages/page_settings.dart';
import 'package:sitemarker/pages/page_view.dart';
import 'package:sitemarker/color_schemes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:window_manager/window_manager.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WindowManager.instance.ensureInitialized();
  windowManager.waitUntilReadyToShow().then((_) async {
    await windowManager.setTitle("Sitemarker");
  });

  runApp(ChangeNotifierProvider(
    create: (context) => DBRecordProvider(),
    child: const SitemarkerApp(),
  ));
}

class SitemarkerApp extends StatelessWidget {
  const SitemarkerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DBRecordProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sitemarker',
        theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
        darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        themeMode: ThemeMode.system,
        home: const SitemarkerHome(title: 'Sitemarker'),
      ),
    );
  }
}

class SitemarkerHome extends StatefulWidget {
  const SitemarkerHome({super.key, required this.title});

  final String title;

  @override
  State<SitemarkerHome> createState() => _SitemarkerHomeState();
}

class _SitemarkerHomeState extends State<SitemarkerHome> {
  _SitemarkerHomeState();
  int currentPageIndex = 0;
  late String version;

  String updateUrl =
      "https://api.github.com/repos/aerocyber/sitemarker/releases/latest";

  void _updateNotify() async {
    PackageInfo pkg = await PackageInfo.fromPlatform();
    version = pkg.version;

    final Uri url = Uri.parse(updateUrl);
    http.Response r = await http.get(url);
    try {
      if (r.statusCode == 200) {
        Map<dynamic, dynamic> upd = json.decode(r.body);
        if (upd["tag_name"] != "1.2.3-fix" &&
            version.compareTo(upd["tag_name"]) == -1 &&
            upd["prerelease"] == false &&
            upd["draft"] == false) {
          showUpdateNotification(
            version,
            upd["tag_name"],
            upd["html_url"],
          );
        }
      }
    } catch (e) {
      return;
    }
  }

  void showUpdateNotification(
      String versionNow, String versionNext, String url) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Available"),
          content: Text(
              "You are using version: $versionNow. Latest version is: $versionNext. Update for more awesomeness!"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                launchUrl(Uri.parse(url));
              },
              child: const Text("Visit release page"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _updateNotify();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: currentPageIndex,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: <Widget>[
        const ViewPage(),
        const PageSettings(),
      ][currentPageIndex],
    );
  }
}
