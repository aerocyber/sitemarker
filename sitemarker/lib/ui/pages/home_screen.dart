import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:sitemarker/ui/pages/page_add.dart';
import 'package:sitemarker/ui/pages/page_settings.dart';
import 'package:sitemarker/ui/pages/page_view.dart';
import 'dart:async';
import 'package:flutter/services.dart';

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


  final List<PersistentBottomNavBarItem> navList = <PersistentBottomNavBarItem>[
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.view_comfy_rounded),
      title: 'View',
      textStyle: const TextStyle(fontSize: 40),
    ),
    PersistentBottomNavBarItem(
      icon: const Icon(Icons.settings),
      title: 'Settings',
      textStyle: const TextStyle(fontSize: 40),
    ),
  ];

  void updatePage(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.url == null) {
      return PersistentTabView(
        context,
        screens: pages,
        items: navList,
        navBarStyle: NavBarStyle.style1,
      );
    } else {
      print(widget.url);
      return Scaffold(
        body: PageAdd(
          receivingData: widget.url,
        ),
      );
    }
  }
}
