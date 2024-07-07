import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/data/data_model.dart';
import 'package:sitemarker/data/dbrecord_provider.dart';
import 'package:sitemarker/operations/omio_file.dart';
import 'package:sitemarker/operations/sitemarker_data.dart' as smd;
import 'package:intl/intl.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  State<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  final String version = '2.2.0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Consumer<DBRecordProvider>(builder: (context, value, child) {
                return TextButton(
                  onPressed: () async {
                    final List<SitemarkerRecord> smrecords = value.records;
                    final outPath = await getDownloadsDirectory();
                    if (outPath == null) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to export records'),
                          ),
                        );
                        return;
                      }
                    }
                    final outputFile =
                        "${outPath!.path}/export-${DateFormat('yyyy-MM-dd-Hms').format(DateTime.now())}-omio.omio";
                    final OmioFile omf = OmioFile(outputFile);
                    smd.SitemarkerRecords smrs = smd.SitemarkerRecords();
                    for (int i = 0; i < smrecords.length; i++) {
                      smrs.addRecord(smrecords[i].name, smrecords[i].url,
                          smrecords[i].tags.split(','));
                    }
                    omf.writeToOmioFile(smrs);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Exported to $outputFile  '),
                        ),
                      );
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center ,
                    children: [
                      Icon(Icons.upload),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Export to Downloads'),
                    ],
                  ),
                );
              }),
              TextButton(
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationIcon:
                        Image.asset("assets/icons/sitemarker-logo.png"),
                    applicationLegalese:
                        '\u{a9} 2023-present Aero\nLicensed under the terms of MIT License',
                    applicationName: 'Sitemarker',
                    applicationVersion: version,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium,
                          text:
                              'Sitemarker is an open source bookmark manager.\n'
                              'Sitemarker enables management of bookmarks a simple, fun and easy experience.',
                        ),
                      ),
                    ],
                  );
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.info),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'About Sitemarker',
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text('Version: $version'),
            ],
          ),
        ),
      ),
    );
  }
}
