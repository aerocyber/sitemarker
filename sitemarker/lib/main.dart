import 'dart:async';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sitemarker/logging/logger_api.dart';
import 'package:universal_io/io.dart';
import 'package:sitemarker/data/db_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitemarker/pages/page_view_omio.dart';

void main(List<String> args) async {
  LoggerApi log = LoggerApi();
  log.log("Initialized logger", 'info', null);
  SharedPreferences sp = await SharedPreferences.getInstance();
  if (args.isNotEmpty) {
    log.log("Got command line argument: ${args[0]}", 'info', null);
    runApp(SitemarkerApp(
      showOmio: true,
      path: args[0],
      logger: log,
      sp: sp,
    ));
  } else {
    log.log("No command line argument", 'info', null);
    runApp(SitemarkerApp(
      showOmio: false,
      path: null,
      logger: log,
      sp: sp,
    ));
  }
}

class SitemarkerApp extends StatefulWidget {
  const SitemarkerApp(
      {super.key,
      required this.showOmio,
      required this.path,
      required this.logger,
      required this.sp});

  final bool showOmio;
  final String? path;
  final LoggerApi logger;
  final SharedPreferences sp;

  @override
  State<SitemarkerApp> createState() => _SitemarkerAppState();
}

class _SitemarkerAppState extends State<SitemarkerApp> {
  late StreamSubscription intentSub;
  final sharedFiles = <SharedMediaFile>[];
  bool intentShow = false;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      // Intent when app in memory
      intentSub =
          ReceiveSharingIntent.instance.getMediaStream().listen((value) {
        setState(() {
          sharedFiles.clear();
          sharedFiles.addAll(value);
          intentShow = true;
        });
      }, onError: (err) {
        widget.logger
            .log("getIntentDataStream Error encountered", 'error', err);
      });
      // Intent when app is closed
      ReceiveSharingIntent.instance.getInitialMedia().then((value) {
        setState(() {
          sharedFiles.clear();
          sharedFiles.addAll(value);
          ReceiveSharingIntent.instance.reset();
          intentShow = true;
        });
      });
    }
  }

  @override
  void dispose() {
    intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!intentShow) {
      if (widget.showOmio == true) {
        if (widget.path != null) {
          return MaterialApp(
            title: 'Sitemarker',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: PageViewOmio(path: widget.path as String),
          );
        } else {
          return MaterialApp(
            title: 'Sitemarker',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            home: const SitemarkerHomePage(),
          );
        }
      } else {
        return MaterialApp(
          title: 'Sitemarker',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const SitemarkerHomePage(),
        );
      }
    } else {
      return MaterialApp(
        title: 'Sitemarker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: PageViewOmio(
          path: sharedFiles[0] as String,
        ),
      );
    }
  }
}

class SitemarkerHomePage extends StatefulWidget {
  const SitemarkerHomePage({super.key});

  @override
  State<SitemarkerHomePage> createState() => _SitemarkerHomePageState();
}

class _SitemarkerHomePageState extends State<SitemarkerHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
        // title: Text(widget.title),
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
