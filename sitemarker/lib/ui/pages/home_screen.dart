import 'package:flutter/material.dart';
import 'package:sitemarker/ui/pages/page_add.dart';
import 'package:sitemarker/ui/pages/page_settings.dart';
import 'package:sitemarker/ui/pages/page_view.dart';

class SMHomeScreen extends StatefulWidget {
  const SMHomeScreen({super.key, required this.url});
  final String? url;

  @override
  State<SMHomeScreen> createState() => _SMHomeScreenState();
}

class _SMHomeScreenState extends State<SMHomeScreen> {
  int selectedIndex = 0;
  static const pages = <Widget>[
    SitemarkerPageView(),
    PageSettings(),
  ];

  final List<BottomNavigationBarItem> navList = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
      tooltip: 'Navigate to the home page',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
      tooltip: 'Navigate to the settings page'
    ),
  ];

  void updatePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (widget.url == null || widget.url!.isEmpty) {
      return Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: navList,
          currentIndex: selectedIndex,
          onTap: updatePage,
          elevation: 0,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedFontSize: 15,
          selectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),
          selectedItemColor: Theme.of(context).colorScheme.primary,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          unselectedItemColor: Theme.of(context).colorScheme.shadow,
          unselectedIconTheme: IconThemeData(color: Theme.of(context).colorScheme.inversePrimary),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
          
        ),
      );
    }
    return Scaffold(
      body: PageAdd(receivingData: widget.url),
    );
  }
}

