import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitemarker/core/data_types/settings/sitemarker_theme.dart';

/// `SMSettingsProvider` is used by provider state management system for
/// managing the settings used by the app.
/// It has funtion calls to change the settings.
class SettingsProvider extends ChangeNotifier {
  /// Theme Settings
  final String themeModeKey = "THEME_MODE";
  String themeModeValue = SitemarkerTheme.systemTheme.themeValue;
  bool customThemeDirFound = true;

  /// Settings DB
  late final SharedPreferencesAsync settingsStore;

  SettingsProvider() {
    init();
  }

  /// Initialize the settings. If no value is found for a key, provide a default
  /// value. Also, populate the secure store with defaults if they're not populated
  /// already. This function is called from the constructor of this class.
  Future<void> init() async {
    settingsStore = SharedPreferencesAsync();

    themeModeValue =
        (await settingsStore.getString(themeModeKey)) ?? themeModeValue;

    notifyListeners();
  }

  /// Change the theme mode. Allowed values are `system`, `light` and `dark`
  Future<void> changeThemeMode(SitemarkerTheme newMode) async {
    String themeMode = newMode.themeValue;

    await settingsStore.setString(themeModeKey, themeMode);
    themeModeValue = themeMode;
    notifyListeners();
  }

  setTheme() {}
}
