import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/settings/sitemarker_theme.dart';

class PageSettings extends StatelessWidget {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    //? TODO: implement build

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
                    Icon(Icons.upload),
                    SizedBox(width: 15, height: 15),
                    Text('Export'),
                  ],
                ),
                onPressed: () {}, // TODO: Implement export
              ),
              const SizedBox(width: 10, height: 10),
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
                    Icon(Icons.download),
                    SizedBox(width: 15, height: 15),
                    Text('Import'),
                  ],
                ),
                onPressed: () {}, // TODO: Implement import
              ),
              const SizedBox(width: 10, height: 10),
            ],
          ),
          const SizedBox(height: 20),
          // TODO: Implement Themes
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const Text('Theme'),
                  const SizedBox(height: 10, width: 10),
                  DropdownMenu<SitemarkerTheme>(
                    initialSelection: SitemarkerTheme.systemTheme,
                    dropdownMenuEntries: SitemarkerTheme.values
                        .map<DropdownMenuEntry<SitemarkerTheme>>(
                            (theme) {
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
                    // applicationIcon: Image.asset() // TODO: Create an app icon and update assets
                    applicationLegalese:
                        '\u{a9} 2023-present Aero\nLicensed under the terms of MIT License',
                    applicationName: 'Sitemarker',
                    applicationVersion: '3.0.0-dev',
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
                'Sitemarker 3.0.0-dev',
                style: TextStyle(
                  color: Colors.grey,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
