import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/animations/bouncy_button.dart';
import 'package:sitemarker/core/data_types/settings/sitemarker_theme.dart';
import 'package:sitemarker/core/providers/settings_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _themeMode = 'systemTheme';
  List<SitemarkerTheme> themes = SitemarkerTheme.values;

  @override
  Widget build(BuildContext context) {
    // Set theme mode
    return Consumer<SettingsProvider>(
      builder: (context, value, child) {
        // Set theme mode
        _themeMode = value.getCurrentThemeMode;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildThemeSettings(value),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildDeleteGroup(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeleteGroup() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BouncyButton(
              onPressed: () {},
              child: ElevatedButton(
                  style: ButtonStyle(
                    elevation: WidgetStatePropertyAll<double>(2.5),
                    shape: WidgetStatePropertyAll<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.all(
                          Radius.circular(5.0),
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Move all records to Trash")
                    ],
                  )),
            ),
          ],
        )
      ],
    );
  }

  void handleThemeDropDown(
      SitemarkerTheme newTheme, SettingsProvider provider) {
    provider.changeThemeMode(newTheme);
    setState(() {
      _themeMode = newTheme.themeValue;
    });
  }

  int themeModeIndex(String themeMode) {
    int index = themes.map((t) => t.themeValue).toList().indexOf(themeMode);
    if (index != -1) {
      return index;
    }
    return themes.map((t) => t.themeValue).toList().indexOf('systemTheme');
  }

  Widget _buildThemeSettings(SettingsProvider p) {
    // TODO: Theme switch functionality

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Spacer(),
        Text("Theme"),
        Spacer(),
        DropdownMenu<SitemarkerTheme>(
          enableFilter: false,
          enableSearch: false,
          initialSelection: themes[themeModeIndex(_themeMode)],
          onSelected: (value) {
            value ??= themes[themeModeIndex(_themeMode)];
            p.changeThemeMode(value);
            setState(() {
              _themeMode = value!.themeValue;
            });
          },
          dropdownMenuEntries: SitemarkerTheme.values
              .map<DropdownMenuEntry<SitemarkerTheme>>((theme) {
            return DropdownMenuEntry(value: theme, label: theme.themeName);
          }).toList(),
        ),
        Spacer(),
      ],
    );
  }
}
