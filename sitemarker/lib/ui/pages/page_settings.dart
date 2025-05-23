import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_helper.dart';
import 'package:sitemarker/core/data_types/settings/sitemarker_theme.dart';
import 'dart:io';
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/db/smdb_provider.dart';
import 'package:sitemarker/core/settings_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});
  final bmcUrl = 'https://buymeacoffee.com/aerocyber';
  final ghSpUrl = 'https://github.com/sponsors/aerocyber';

  @override
  State<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  final TextEditingController _DropDownThemeModeController =
      TextEditingController();

  late SitemarkerTheme theme;
  final String version = '3.0.0'; // TODO: Update version

  handleDropdown(SitemarkerTheme? selection) {
    if (selection == null) {
      _DropDownThemeModeController.text = theme.name;
      selection = theme;
    }
    theme = selection;
    String themeMode = 'system';
    switch (theme) {
      case SitemarkerTheme.lightTheme:
        themeMode = 'light';
        break;
      case SitemarkerTheme.darkTheme:
        themeMode = 'dark';
        break;
      default:
        themeMode = 'system';
    }

    setState(() {
      Provider.of<SMSettingsProvider>(context, listen: false)
          .changeThemeMode(themeMode);
    });
  }

  @override
  Widget build(BuildContext context) {
    //? TODO: implement build
    SizeConfig().initSizes(context);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     // Consumer<SmdbProvider>(
          //     //   builder: (context, value, child) => ElevatedButton(
          //     //     style: ButtonStyle(
          //     //       shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          //     //         RoundedRectangleBorder(
          //     //           borderRadius: BorderRadius.circular(7.0),
          //     //         ),
          //     //       ),
          //     //     ),
          //     //     onPressed: () {
          //     //       for (int i = 0; i < value.allRecords.length; i++) {
          //     //         value.deleteRecord(SmRecord(
          //     //           id: value.allRecords[i].id,
          //     //           name: value.allRecords[i].name,
          //     //           url: value.allRecords[i].url,
          //     //           tags: value.allRecords[i].tags,
          //     //           isDeleted: value.allRecords[i].isDeleted,
          //     //           dt: value.allRecords[i].dateAdded,
          //     //         ));
          //     //       }
          //     //     },
          //     //     child: const Row(
          //     //       children: <Widget>[
          //     //         Icon(Icons.delete),
          //     //         SizedBox(width: 15, height: 15),
          //     //         Text('Clear all records'),
          //     //       ],
          //     //     ),
          //     //   ),
          //     // ),
          //     // const SizedBox(width: 10, height: 10),
          //     ElevatedButton(
          //       style: ButtonStyle(
          //         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          //           RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(7.0),
          //           ),
          //         ),
          //       ),
          //       child: const Row(
          //         children: <Widget>[
          //           Icon(Icons.upload),
          //           SizedBox(width: 15, height: 15),
          //           Text('Export'),
          //         ],
          //       ),
          //       onPressed: () {}, // TODO: Implement export
          //     ),
          //     const SizedBox(width: 10, height: 10),
          //     ElevatedButton(
          //       style: ButtonStyle(
          //         shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          //           RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(7.0),
          //           ),
          //         ),
          //       ),
          //       child: const Row(
          //         children: <Widget>[
          //           Icon(Icons.download),
          //           SizedBox(width: 15, height: 15),
          //           Text('Import'),
          //         ],
          //       ),
          //       onPressed: () {}, // TODO: Implement import
          //     ),
          //     const SizedBox(width: 10, height: 10),
          //   ],
          // ),
          // const SizedBox(height: 20),
          // TODO: Implement Themes

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text('Theme'),
                  const SizedBox(height: 10, width: 10),
                  DropdownMenu<SitemarkerTheme>(
                    enableSearch: true,
                    initialSelection: getInitialValueThemeMode(),
                    onSelected: handleDropdown,
                    dropdownMenuEntries: SitemarkerTheme.values
                        .map<DropdownMenuEntry<SitemarkerTheme>>((theme) {
                      return DropdownMenuEntry(
                        value: theme,
                        label: theme.themeName,
                      );
                    }).toList(),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          Divider(
            color: Theme.of(context).disabledColor,
            thickness: 3,
            height: 20,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<SmdbProvider>(builder: (context, value, child) {
                return ElevatedButton(
                  onPressed: () async {
                    String? fpath = await FilePicker.platform.saveFile(
                      dialogTitle: 'Save as',
                      fileName: 'sitemarker.omio',
                      type: FileType.custom,
                      allowedExtensions: ['omio'],
                    );
                    if (fpath == null) {
                      // Show error dialog and return
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Error'),
                            content: const Text('File path is null'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                      return;
                    }
                    File file = File(fpath);
                    file.writeAsStringSync(
                        DataHelper.convertToOmio(
                            value.getAllUndeletedRecords()),
                        mode: FileMode.write);
                    if (context.mounted) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Success'),
                          content: const Text('File exported successfully'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(7.0),
                      ),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.upload),
                      Text("Export records as omio file")
                    ],
                  ),
                );
              }),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Divider(
            color: Theme.of(context).disabledColor,
            thickness: 3,
            height: 20,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                ),
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.info),
                    SizedBox(height: 10, width: 10),
                    Text('About Sitemarker')
                  ],
                ),
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationIcon: Image.asset(
                      'assets/io.github.aerocyber.sitemarker.png',
                      width: 150,
                      height: 150,
                    ),
                    applicationLegalese:
                        '\u{a9} 2023-present Aero\nLicensed under the terms of Apache-2.0 License',
                    applicationName: 'Sitemarker',
                    applicationVersion: version,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                ),
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Support the project'),
                      content: Text(
                          'If you like Sitemarker, consider supporting the project by buying me a coffee or sponsoring me on GitHub.'),
                      actions: [
                        ElevatedButton(
                            onPressed: () async {
                              if (await canLaunchUrl(
                                  Uri.parse(widget.bmcUrl))) {
                                await launchUrl(Uri.parse(widget.bmcUrl));
                              } else {
                                throw 'Could not launch ${widget.bmcUrl}';
                              }
                            },
                            child: const Text('Buy me a coffee')),
                        ElevatedButton(
                          onPressed: () async {
                            if (await canLaunchUrl(Uri.parse(widget.ghSpUrl))) {
                              await launchUrl(Uri.parse(widget.ghSpUrl));
                            } else {
                              throw 'Could not launch ${widget.ghSpUrl}';
                            }
                          },
                          child: const Text('GitHub Sponsor'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Row(
                  children: <Widget>[
                    Icon(Icons.coffee),
                    SizedBox(height: 10, width: 10),
                    Text('Support the project'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sitemarker $version',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () async {
                  Uri url = Uri.parse(
                      'https://api.github.com/repos/aerocyber/sitemarker/releases/latest');
                  try {
                    http.Response r = await http.get(url);
                    if (r.statusCode == 200) {
                      Map<dynamic, dynamic> data = json.decode(r.body);
                      if (version.compareTo(data["tag_name"]) == -1 &&
                          data['prerelease'] == false) {
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Update Available"),
                              content: Text(
                                "A new version of Sitemarker is available.",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    launchUrl(Uri.parse(data["html_url"]));
                                  },
                                  child: const Text("Visit release page"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        }
                      } else {
                        if (!kReleaseMode) {
                          print('Latest version is already installed');
                          print(data["tag_name"]);
                        }
                      }
                    }
                  } catch (e) {
                    return;
                  }
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if (Platform.isAndroid) _adBox()
        ],
      ),
    );
  }

  Widget _adBox() {
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical * 10,
        ),
        Container(), // TODO: Replace with the ad banner
      ],
    );
  }

  SitemarkerTheme getInitialValueThemeMode() {
    String defaultTheme =
        Provider.of<SMSettingsProvider>(context, listen: false)
            .getCurrentThemeMode();
    switch (defaultTheme) {
      case 'light':
        return SitemarkerTheme.lightTheme;
      case 'dark':
        return SitemarkerTheme.darkTheme;
      default:
        return SitemarkerTheme.systemTheme;
    }
  }
}
