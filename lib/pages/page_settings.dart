import 'package:flutter/material.dart';

class PageSettings extends StatelessWidget {
  const PageSettings({super.key});

  final String version = '2.1.0'; // TODO: Update version here on release build.

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                        text: 'Sitemarker is an open source bookmark manager.\n'
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
    );
  }
}
