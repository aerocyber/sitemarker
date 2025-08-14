import 'package:flutter/material.dart';
import 'package:sitemarker/ui/pages/page_add.dart';
import 'package:sitemarker/ui/pages/page_settings.dart';
import 'package:sitemarker/ui/pages/page_view.dart';
import 'package:sitemarker/ui/components/bottom_nav_bar_btn.dart';

class SMHomeScreen extends StatefulWidget {
  const SMHomeScreen({super.key, required this.url});
  final String? url;

  @override
  State<SMHomeScreen> createState() => _SMHomeScreenState();
}

class _SMHomeScreenState extends State<SMHomeScreen> {
  int selectedIndex = 0;
  int previousIndex = 0;
  // No longer need refreshHome flag directly here,
  // it will be managed by recreating the page.

  // The list of pages will now be a getter that can rebuild
  List<Widget> get _pages {
    return <Widget>[
      // Pass refresh: true if we just came from a different tab (i.e., previousIndex was not 0)
      SitemarkerPageView(
        refresh: selectedIndex == 0 &&
            previousIndex !=
                0, // Only refresh if navigating TO Home FROM another tab
      ),
      SafeArea(child: const PageSettings()),
    ];
  }

  final List<BottomNavigationBarItem> navList = <BottomNavigationBarItem>[
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
      tooltip: 'Navigate to the home page',
    ),
    const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
        tooltip: 'Navigate to the settings page'),
  ];

  void updatePage(int index) {
    setState(() {
      previousIndex = selectedIndex; // Store the current index as previous
      selectedIndex = index; // Set the new selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url == null || widget.url!.isEmpty) {
      return Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: _pages, // Use the dynamic _pages getter here
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BottomNavBarBtn(
                icon: Icons.home,
                index: 0,
                onPressed: (val) => updatePage(val),
                currentIndex: selectedIndex,
                toolTip: 'Navigate to the home page',
              ),
              BottomNavBarBtn(
                icon: Icons.settings,
                index: 1,
                onPressed: (val) => updatePage(val),
                currentIndex: selectedIndex,
                toolTip: 'Navigate to the settings page',
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: PageAdd(receivingData: widget.url),
    );
  }
}
