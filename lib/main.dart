import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/dbrecord_provider.dart';
import 'package:sitemarker/pages/page_settings.dart';
import 'package:sitemarker/pages/page_view.dart';
import 'package:sitemarker/color_schemes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:universal_io/io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
  int showDonate = 40;
  int? randomness;

  String updateUrl =
      "https://api.github.com/repos/aerocyber/sitemarker/releases/latest";

  void _updateNotify() async {
    version = '2.1.0';

    final Uri url = Uri.parse(updateUrl);
    try {
      http.Response r = await http.get(url);
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

  Future<Directory> getAppDir() async {
    if (Platform.isLinux) {
      return Directory(Platform.environment["XDG_DATA_DIR"] ??
          "${Platform.environment["HOME"]}/.config/sitemarker");
    } else {
      return await getApplicationSupportDirectory();
    }
  }

  void _donateNotify() async {
    bool showDonate = true;
    if (!kIsWeb) {
      Directory dir = await getAppDir();
      File f = File("${dir.path.toString()}/donate_show.timestamp");
      if (!f.existsSync()) {
        f.createSync(recursive: true);
        f.writeAsStringSync(
            "${DateTime.timestamp().day}-${DateTime.timestamp().month}-${DateTime.timestamp().year}");
      } else {
        var timestamp = f.readAsStringSync();
        if (timestamp ==
            "${DateTime.timestamp().day}-${DateTime.timestamp().month}-${DateTime.timestamp().year}") {
          showDonate = false;
        } else {
          f.writeAsStringSync(
              "${DateTime.timestamp().day}-${DateTime.timestamp().month}-${DateTime.timestamp().year}");
        }
      }
    }
    String bmc = "https://buymeacoffee.com/aerocyber";
    String ghs = "https://github.com/sponsors/aerocyber";
    if (showDonate) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Support the project"),
              content: const Text(
                  "This project is powered by awesome folks like you! Please donate to support the project's development! We support 2 ways of donations! Choose either of these."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse(bmc));
                  },
                  child: const Text("Buy Me a Coffee"),
                ),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse(ghs));
                  },
                  child: const Text("Github Sponsors"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("Remind me later"),
                )
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _updateNotify();
      _donateNotify();
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
