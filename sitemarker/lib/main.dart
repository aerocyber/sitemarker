import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sitemarker/core/db/sm_db.dart';
import 'package:sitemarker/core/repos/folders_repo.dart';
import 'package:sitemarker/core/repos/records_repo.dart';
import 'package:sitemarker/core/repos/tags_repo.dart';

import 'package:sitemarker/core/providers/folders_provier.dart';
import 'package:sitemarker/core/providers/records_provider.dart';
import 'package:sitemarker/core/providers/tags_provider.dart';

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
          create: (_) => FoldersProvier(foldersRepo)..loadRootFolders(),
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
    return MaterialApp(
      title: 'Sitemarker',
      home: const Scaffold(body: Center(child: Text('Sitemarker 4.0'))),
    );
  }
}
