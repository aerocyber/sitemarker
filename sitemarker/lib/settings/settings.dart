import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/settings/themes/themes.dart';

class PageSettings extends StatefulWidget {
  const PageSettings({super.key});

  @override
  State<PageSettings> createState() => _PageSettingsState();
}

class _PageSettingsState extends State<PageSettings> {
  final WidgetStateProperty<Icon?> themeIcon =
      WidgetStateProperty.resolveWith<Icon?>((Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return const Icon(Icons.dark_mode);
    }
    return const Icon(Icons.light_mode);
  });

  @override
  Widget build(BuildContext context) {
    late bool isLightTheme;
    // late bool enableShadows;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Dark Theme"),
              const SizedBox(
                width: 15,
              ),
              Consumer<ThemesProvider>(
                builder: (context, value, child) {
                  isLightTheme = !value.darkTheme;
                  return Switch(
                    value: value.darkTheme,
                    onChanged: (bool isLight) {
                      setState(() {
                        isLightTheme = isLight;
                        if (isLightTheme) {
                          value.switchThemeDark();
                        } else {
                          value.switchThemeLight();
                        }
                      });
                    },
                    inactiveThumbColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    inactiveTrackColor: Theme.of(context).colorScheme.primary,
                    thumbIcon: themeIcon,
                    activeColor: Theme.of(context).colorScheme.inversePrimary,
                    activeTrackColor: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enable shadows'),
              const SizedBox(
                width: 15,
              ),
              Consumer<ThemesProvider>(builder: (context, value, child) {
                // enableShadows = value.shadows; 
                return Switch(
                  value: value.shadows,
                  onChanged: (bool shadows) {
                    setState(() {
                      // enableShadows = shadows;
                      value.switchShadows();
                    });
                  },
                  inactiveThumbColor:
                      Theme.of(context).colorScheme.inversePrimary,
                  inactiveTrackColor: Theme.of(context).colorScheme.primary,
                  activeColor: Theme.of(context).colorScheme.inversePrimary,
                  activeTrackColor: Theme.of(context).colorScheme.primary,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
