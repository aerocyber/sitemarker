import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/size_config.dart';
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
        tooltip: 'Navigate to the settings page'),
  ];

  void updatePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().initSizes(context);
    if (widget.url == null || widget.url!.isEmpty) {
      return Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: pages,
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
