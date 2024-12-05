import 'package:flutter/material.dart';
import 'package:sitemarker/core/data_types/settings/sitemarker_theme.dart';
import 'package:sitemarker/ui/pages/page_view.dart';

class PageSettings extends StatelessWidget {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    //? TODO: implement build

    return Scaffold(
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.minWidth >= 880) {
            // laptops/desktops
            return Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    height: 75,
                    width: 500,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SitemarkerPageView(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.home),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PageSettings(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    height: 75,
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const SitemarkerPageView(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.home),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PageSettings(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
                child: const Row(
                  children: [
                    Icon(Icons.upload),
                    SizedBox(width: 15, height: 15),
                    Text("Export"),
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
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 15, height: 15),
                    Text("Import"),
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
            children: [
              Row(
                children: [
                  const Text("Select Theme"),
                  const SizedBox(height: 10, width: 10),
                  DropdownMenu<SitemarkerTheme>(
                    initialSelection: SitemarkerTheme.systemTheme,
                    dropdownMenuEntries: SitemarkerTheme.values
                        .map<DropdownMenuEntry<SitemarkerTheme>>(
                            (SitemarkerTheme theme) {
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
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(height: 10, width: 10),
                    Text("About Sitemarker")
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
            children: [
              Text(
                "Sitemarker 3.0.0-dev",
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
