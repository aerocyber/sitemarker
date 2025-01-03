import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/settings/sitemarker_theme.dart';
import 'dart:io';
import 'package:sitemarker/core/data_types/size_config.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/core/settings_provider.dart';
// import 'package:sitemarker/core/db/smdb_provider.dart';
// import 'package:sitemarker/core/data_types/userdata/sm_record.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  State<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  final TextEditingController _DropDownThemeModeController =
      TextEditingController();

  late SitemarkerTheme theme;

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
                    applicationVersion: '3.0.0',
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sitemarker 3.0.0',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
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
