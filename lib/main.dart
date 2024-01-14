import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sitemarker/components/card_add.dart';
import 'package:sitemarker/components/card_delete.dart';
import 'package:sitemarker/components/card_edit.dart';
import 'package:sitemarker/components/card_search.dart';
import 'package:sitemarker/components/nav_drawer.dart';
import 'package:sitemarker/components/card_view.dart';
import 'package:sitemarker/errors.dart';
import 'package:sitemarker/sitemarker_data.dart';
import 'package:sitemarker/omio_file.dart';

void main() {
  runApp(const SitemarkerApp());
}

class SitemarkerApp extends StatelessWidget {
  const SitemarkerApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sitemarker',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 137, 70, 252)),
        useMaterial3: true,
      ),
      home: const SitemarkerHome(title: 'Sitemarker'),
    );
  }
}

class SitemarkerHome extends StatefulWidget {
  const SitemarkerHome({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SitemarkerHome> createState() => _SitemarkerHomeState();
}

class _SitemarkerHomeState extends State<SitemarkerHome> {
  late SitemarkerRecords smr;
  late File omioFileLocation;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: const CardAdd(),
              onTap: () =>
                  {}, // TODO: Implement adding record via page navigation
            ),
            GestureDetector(
              onTap: () =>
                  {}, // TODO: Implement editing record via page navigation
              child: const CardEdit(),
            ),
            GestureDetector(
              onTap: () =>
                  {}, // TODO: Implement deleting record via page navigation
              child: const CardDelete(),
            ),
            GestureDetector(
              onTap: () =>
                  {}, // TODO: Implement searching record via page navigation
              child: const CardSearch(),
            ),
            GestureDetector(
              onTap: () =>
                  {}, // TODO: Implement viewing record via page navigation
              child: const CardView(),
            ),
          ],
        ),
      ),
      drawer: const NavDrawer(),
    );
  }
}
