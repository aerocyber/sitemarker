import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/dbrecord_provider.dart';
import 'package:sitemarker/pages/page_settings.dart';
import 'package:sitemarker/pages/page_view.dart';
import 'package:sitemarker/color_schemes.dart';

void main() {
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
