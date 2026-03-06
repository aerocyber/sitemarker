import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sitemarker/components/bouncy_button.dart';
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
    return Consumer<SettingsProvider>(
      builder: (context, value, child) {
        _themeMode = value.getCurrentThemeMode;

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildThemeSettings(value),
                  const SizedBox(
                      height:
                          30.0), // Increased spacing for visual breathing room
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
    return BouncyButton(
      onPressed: () {
        // Trigger your delete logic here
        debugPrint("Moving all records to trash...");
      },
      // Use a Container instead of an ElevatedButton to prevent tap conflicts
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
        decoration: BoxDecoration(
          color: Theme.of(context)
              .colorScheme
              .errorContainer, // Use Material 3 error theme
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Prevents row from taking full width
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            Text(
              "Move all records to Trash",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  int themeModeIndex(String themeMode) {
    int index = themes.map((t) => t.themeValue).toList().indexOf(themeMode);
    if (index != -1) {
      return index;
    }
    return themes.map((t) => t.themeValue).toList().indexOf('systemTheme');
  }

  Widget _buildThemeSettings(SettingsProvider p) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        const Text("Theme", style: TextStyle(fontSize: 16)),
        const Spacer(),
        DropdownMenu<SitemarkerTheme>(
          enableFilter: false,
          enableSearch: false,
          initialSelection: themes[themeModeIndex(_themeMode)],
          onSelected: (value) {
            if (value != null) {
              p.changeThemeMode(value);
              setState(() {
                _themeMode = value.themeValue;
              });
            }
          },
          dropdownMenuEntries: SitemarkerTheme.values
              .map<DropdownMenuEntry<SitemarkerTheme>>((theme) {
            return DropdownMenuEntry(value: theme, label: theme.themeName);
          }).toList(),
        ),
        const Spacer(),
      ],
    );
  }
}
