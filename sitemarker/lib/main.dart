import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:sitemarker/ui/pages/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SMApp());
}

class SMApp extends StatefulWidget {
  const SMApp({super.key});

  @override
  State<SMApp> createState() => _SMAppState();
}

class _SMAppState extends State<SMApp> {
  late StreamSubscription _intentSub;
  final _sharedItems = <SharedMediaFile>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (Platform.isAndroid) {
      // Listen to media sharing coming from outside the app while the app is in the memory.
      _intentSub = ReceiveSharingIntent.instance.getMediaStream().listen((value) {
        setState(() {
          _sharedItems.clear();
          _sharedItems.addAll(value);

          print(_sharedItems.map((f) => f.toMap()));
        });
      }, onError: (err) {
        print("getIntentDataStream error: $err");
      });

      // Get the media sharing coming from outside the app while the app is closed.
      ReceiveSharingIntent.instance.getInitialMedia().then((value) {
        setState(() {
          _sharedItems.clear();
          _sharedItems.addAll(value);
          print(_sharedItems.map((f) => f.toMap()));

          // Tell the library that we are done processing the intent.
          ReceiveSharingIntent.instance.reset();
        });
      });
    }
  }

  @override
  void dispose() {
    if (Platform.isAndroid) _intentSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sitemarker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SMHomeScreen(url: _sharedItems.isNotEmpty ? _sharedItems[0].path : null,),
    );
  }
}
