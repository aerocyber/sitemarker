import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/operations/dbrecord_provider.dart';
import 'package:sitemarker/pages/page_settings.dart';
import 'package:sitemarker/pages/page_view.dart';

void main() {
  runApp(const SitemarkerApp());
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 134, 39, 250)),
          useMaterial3: true,
        ),
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
      // appBar: AppBar(
      //   shape: const RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(8.0))),
      //   centerTitle: true,
      //   elevation: 2.0,
      //   backgroundColor: Theme.of(context).colorScheme.background,
      //   title: Text(
      //     'Sitemarker',
      //     style: TextStyle(
      //       color: Theme.of(context).colorScheme.secondary,
      //     ),
      //   ),
      // ),
      bottomNavigationBar: NavigationBar(
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
