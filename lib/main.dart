import 'package:flutter/material.dart';
import 'package:sitemarker/components/card_add.dart';
import 'package:sitemarker/components/card_delete.dart';
import 'package:sitemarker/components/card_edit.dart';
import 'package:sitemarker/components/card_search.dart';
import 'package:sitemarker/components/nav_drawer.dart';
import 'package:sitemarker/components/card_view.dart';
import 'package:sitemarker/model.dart';
import 'package:sitemarker/objectbox_bind.dart';
import 'package:sitemarker/pages/dialog.dart';
import 'package:sitemarker/pages/page_add.dart';
import 'package:sitemarker/pages/page_view.dart';
import 'package:sitemarker/errors.dart';
import 'package:sitemarker/sitemarker_record.dart';

late ObjectBox objectbox;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
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
  final recordBox = objectbox.store.box<SitemarkerInternalRecord>();

  _SitemarkerHomeState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              child: const CardAdd(),
              onTap: () {
                _navigateGetData(context);
              },
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
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewPage(
                        ob: recordBox,
                      ),
                    ));
              },
              child: const CardView(),
            ),
          ],
        ),
      ),
      drawer: const NavDrawer(),
    );
  }

  Future<void> _navigateGetData(BuildContext context) async {
    try {
      final SitemarkerRecord result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PageAdd()),
      );

      if (!mounted) return;
      String tagString = '';
      for (int i = 0; i < result.tags.length; i++) {
        tagString = "$tagString ${result.tags[i]}";
        if (i != result.tags.length - 1) {
          tagString = '$tagString, ';
        }
      }
      SitemarkerInternalRecord smir =
          SitemarkerInternalRecord(result.name, result.url, tagString);
      recordBox.put(smir);
    } on InvalidUrlError {
      showAlertDialog(
        context,
        "Invalid URL",
        "Please enter a valid URL.",
      );
    } on DuplicateRecordException {
      showAlertDialog(context, "Duplicate Entry",
          "There is already an entry with the provided name/URL.");
    }
  }

  void showAlertDialog(
      BuildContext context, String dialogTitle, String bodyText) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return DialogInfo(
            alertTitle: dialogTitle,
            alertBody: bodyText,
          );
        });
  }
}
