import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/data/db_provider.dart';
import 'package:sitemarker/features/ui/pages/view_records_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => DbProvider(),
      child: SitemarkerApp(),
    ),
  );
}

class SitemarkerApp extends StatelessWidget {
  const SitemarkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sitemarker',
      // TODO: Themes
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 168, 93, 255),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 168, 93, 255),
          brightness: Brightness.dark,
        ),
      ),
      home: SitemarkerHome(),
    );
  }
}

class SitemarkerHome extends StatefulWidget {
  const SitemarkerHome({super.key});

  @override
  State<SitemarkerHome> createState() => _SitemarkerHomeState();
}

class _SitemarkerHomeState extends State<SitemarkerHome> {
  int current_page_index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: current_page_index,
        indicatorColor: Theme.of(context).colorScheme.inversePrimary,
        onDestinationSelected: (int index) {
          setState(() {
            current_page_index = index;
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
        const ViewRecordsPage(),
      ][current_page_index],
    );
  }
}
