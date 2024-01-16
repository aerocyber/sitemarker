import 'package:flutter/material.dart';
import 'package:sitemarker/pages/dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration:
                BoxDecoration(color: Color.fromARGB(255, 175, 188, 207)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.report),
            title: const Text(
              "Report Issue",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 157, 43, 43),
              ),
            ),
            onTap: _launchUrlIssue,
          ),
          GestureDetector(
            onTap: _launchUrlDocs,
            child: ListTile(
              leading: const Icon(Icons.description),
              title: Text(
                "Documentation",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
          GestureDetector(
            child: ListTile(
              leading: const Icon(Icons.favorite),
              title: Text(
                "Donate",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onTap: () {
                showAlertDialog(context);
              },
            ),
          ),
          AboutListTile(
            icon: const Icon(Icons.info),
            applicationIcon: Image.asset("assets/icons/sitemarker-logo.png"),
            applicationLegalese:
                '\u{a9} 2023 - present Aero\nLicensed under the MIT License',
            applicationName: 'Sitemarker',
            applicationVersion: '2.0.0-dev',
            aboutBoxChildren: <Widget>[
              const SizedBox(
                height: 25,
              ),
              RichText(
                  text: TextSpan(children: <TextSpan>[
                TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium!,
                    text:
                        'Sitemarker is an open source bookmark manager for easy bookmark management. Learn more at '),
                TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  text: 'https://aerocyber.github.io/sitemarker',
                ),
                TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium!, text: '.'),
              ]))
            ],
            child: ListTile(
                title: Text(
              "About",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            )),
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    AlertDialog ad = AlertDialog(
      title: const Text("Donate to the project"),
      content: const Text("How would you like to donate?"),
      actions: [
        TextButton(
          onPressed: _launchUrlBMC,
          child: const Text("Buy Me a Coffee"),
        ),
        TextButton(
            onPressed: _launchUrlGS, child: const Text("Github Sponsors")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ad;
        });
  }

  Future<void> _launchUrlBMC() async {
    if (!await launchUrl(Uri.parse('https://buymeacoffee.com/aerocyber'))) {
      const DialogInfo(
        alertTitle: "Error launching the browser",
        alertBody:
            "Could not launch URL. Type in https://buymeacoffee.com/aerocyber in your browser!",
      );
    }
  }

  Future<void> _launchUrlGS() async {
    if (!await launchUrl(Uri.parse('https://github.com/sponsors/aerocyber'))) {
      const DialogInfo(
        alertTitle: "Error launching the browser",
        alertBody:
            "Could not launch URL. Type in https://github.com/sponsors/aerocyber in your browser!",
      );
    }
  }

  Future<void> _launchUrlIssue() async {
    if (!await launchUrl(
        Uri.parse('https://github.com/aerocyber/sitemarker/issues'))) {
      const DialogInfo(
        alertTitle: "Error launching the browser",
        alertBody:
            "Could not launch URL. Type in https://github.com/aerocyber/sitemarker/issues in your browser!",
      );
    }
  }

  Future<void> _launchUrlDocs() async {
    if (!await launchUrl(
        Uri.parse('https://aerocyber.github.io/sitemarker/docs'))) {
      const DialogInfo(
        alertTitle: "Error launching the browser",
        alertBody:
            "Could not launch URL. Type in https://aerocyber.github.io/sitemarker/docs in your browser!",
      );
    }
  }
}
