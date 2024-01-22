import 'package:flutter/material.dart';

class PageSettings extends StatelessWidget {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AboutListTile(
              applicationLegalese: '\u{a9} 2023-present Aero',
              applicationName: 'Sitemarker',
              applicationVersion: '2.0.0-dev',
              icon: const Icon(Icons.info),
              applicationIcon: Image.asset("assets/icons/sitemarker-logo.png"),
              aboutBoxChildren: [
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    text: 'Sitemarker is an open source bookmark manager. '
                        'Management of bookmarks is made easy, simple and fun with Sitemarker.',
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
