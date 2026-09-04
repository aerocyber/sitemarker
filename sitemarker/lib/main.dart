import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart' as loc;

import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/repos/folders_repo.dart';
import 'package:sitemarker/core/repos/records_repo.dart';
import 'package:sitemarker/core/repos/tags_repo.dart';

import 'package:sitemarker/core/providers/folders_provider.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/core/providers/tags_provider.dart';
import 'package:sitemarker/router.dart';

void main() async {
  // Required for asynchronous DB and platform channel setup
  WidgetsFlutterBinding.ensureInitialized();

  final database = SitemarkerDB();

  final folderDao = database.folderDao;
  final recordsDao = database.recordsDao;
  final tagsDao = database.tagsDao;
  final tagMappingDao = database.tagMappingDao;

  final foldersRepo = FoldersRepository(folderDao, recordsDao);
  final recordsRepo = RecordsRepository(recordsDao, folderDao);
  final tagsRepo = TagsRepository(tagsDao, tagMappingDao);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FoldersProvider(foldersRepo)..loadRootFolders(),
        ),
        ChangeNotifierProvider(create: (_) => RecordsProvider(recordsRepo)),
        ChangeNotifierProvider(
          create: (_) => TagsProvider(tagsRepo)..loadTags(),
        ),
      ],
      child: const SitemarkerApp(),
    ),
  );
}

class SitemarkerApp extends StatelessWidget {
  const SitemarkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFD0BCFF),
      brightness: Brightness.light,
    );

    final darkScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFFD0BCFF),
      brightness: Brightness.dark,
    );

    return MaterialApp.router(
      title: 'Sitemarker',

      // TODO: Make thememode respect user preference through settings (shared pref)
      themeMode: ThemeMode.system,

      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFD0BCFF),
        brightness: Brightness.light,
        useMaterial3: true,

        dialogTheme: DialogThemeData(
          backgroundColor: lightScheme.surface,
        ),

        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: lightScheme.surface,
        ),
      ),

      // Clean, unified Dark Theme
      darkTheme: ThemeData(
        colorSchemeSeed: const Color(0xFFD0BCFF),
        brightness: Brightness.dark, // This is the crucial missing piece
        useMaterial3: true,

        dialogTheme: DialogThemeData(
          backgroundColor: darkScheme.surface,
        ),

        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: darkScheme.surface,
        ),
      ),

      routerConfig: appRouter,
      localizationsDelegates: [
        loc.GlobalMaterialLocalizations.delegate,
        loc.GlobalWidgetsLocalizations.delegate,
        loc.GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US')],
      debugShowCheckedModeBanner: false,
    );
  }
}
