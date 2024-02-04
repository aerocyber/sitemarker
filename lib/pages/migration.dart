// Migration Screen is supported ONLY on Linux.
// This is done so because version 1.x of Sitemarker had supported ONLY Linux.
// And the new version is migrating away from storing records in .omio file to
// storing them inside database.
// To facilitate users who update from 1.x, Sitemarker provides this migration page.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:sitemarker/data/dbrecord_provider.dart';
import 'package:sitemarker/operations/errors.dart';
import 'package:sitemarker/operations/omio_file.dart';
import 'package:sitemarker/operations/sitemarker_record.dart';
import 'package:universal_io/io.dart';

class MigratingScreen extends StatelessWidget {
  const MigratingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String path = '';
    String path1 =
        '${Platform.environment['HOME']}/.local/share/sitemarker'; // Path where Sitemarker 1.x stored data if not installed with flatpak.
    String? path2 = Platform.environment[
        'XDG_DATA_HOME']; // Sitemarker 1.x stored data here if installed with flapak.
    List<SitemarkerRecord> smrs;

    if (Directory(path1).existsSync()) {
      if (File('$path1/internal.omio').existsSync()) {
        path = '$path1/internal.omio';
      }
    } else if (path2 != null) {
      if (Directory(path2).existsSync()) {
        if (File('$path2/internal.omio').existsSync()) {
          path = '$path2/internal.omio';
        }
      }
    }

    if (path != '') {
      OmioFile omf = OmioFile(path);
      try {
        bool _ = omf.readOmioFile();
      } on InvalidOmioFileExcepion {
        // Delete the dir
        Directory(File(path).parent.path).deleteSync();
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: const Text(
              'Invalid .omio file. Removing them for a cleaner experience',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
      smrs = omf.getSmr();
      for (int i = 0; i < smrs.length; i++) {
        DBRecord record = DBRecord(
            name: smrs[i].name,
            url: smrs[i].url,
            tags: smrs[i].tags.toString());
        Provider.of<DBRecordProvider>(context).insertRecord(record);
        // TODO: Test this
      }
      // Delete the file
      File(path).deleteSync(recursive: true);
    }

    return const Center(
      child: Column(
        children: [
          Text(
            'Welcome, to the new Sitemarker!',
          ),
          Text(
            'We migrated your data to the newer format!',
          ),
          Text(
            'Have fun!',
          ),
        ],
      ),
    );
  }
}
