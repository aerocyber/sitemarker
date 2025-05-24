import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sitemarker/core/data_types/settings/sm_theme.dart';

/// `SMSettingsProvider` is used by provider state management system for
/// managing the settings used by the app.
/// It has funtion calls to change the settings.
class SMSettingsProvider extends ChangeNotifier {
  /// Theme Settings
  final String themeNameKey = "THEME_COLOR";
  String themeNameValue = "io.github.aerocyber.sitemarker.colors.default";
  final String themeModeKey = "THEME_MODE";
  String themeModeValue = "system";
  late String themeDir;
  bool customThemeDirFound = true;

  /// Settings DB
  late final SharedPreferencesAsync settingsStore;

  SMSettingsProvider() {
    init();
  }

  /// Initialize the settings. If no value is found for a key, provide a default
  /// value. Also, populate the secure store with defaults if they're not populated
  /// already. This function is called from the constructor of this class.
  init() async {
    settingsStore = SharedPreferencesAsync();
    themeNameValue =
        (await settingsStore.getString(themeNameKey)) ?? themeNameValue;
    if ((await settingsStore.getString(themeNameKey)) == null) {
      settingsStore.setString(themeNameKey, themeNameValue);
    }
    themeModeValue =
        (await settingsStore.getString(themeModeKey)) ?? themeModeValue;
    if ((await settingsStore.getString(themeModeKey)) == null) {
      settingsStore.setString(themeModeKey, themeModeValue);
    }
    SmTheme st = SmTheme();
    themeDir = await st.getThemePath();
    if (themeDir == '') {
      customThemeDirFound = false;
    }
    notifyListeners();
  }

  /// Get the currently set theme
  String getCurrentTheme() => themeNameValue;

  /// Get the currently set theme mode
  String getCurrentThemeMode() => themeModeValue;

  /// Change the theme mode. Allowed values are `system`, `light` and `dark`
  changeThemeMode(String newMode) async {
    newMode = newMode.toLowerCase();
    if (!['system', 'light', 'dark'].contains(newMode)) {
      throw Exception('Invalid Theme Mode');
    }
    await settingsStore.setString(themeModeKey, newMode);
    themeModeValue = newMode;
    notifyListeners();
  }

  /// Get all available themes from SmTheme class.
  Map<String, String> getThemes() {
    SmTheme st = SmTheme();
    List<String> themeStore = st.getThemeStore();
    Map<String, String> themeList = {};

    for (int i = 0; i < themeStore.length; i++) {
      Map jsonDec = json.decode(themeStore[i]);
      themeList.addAll({jsonDec["name"]: jsonDec["id"]});
    }

    return themeList;
  }

  /// Change the theme. The required parameter is a theme id. Theme Ids can be
  /// obtained from the `geThemes()` function
  changeTheme(String newThemeId) async {
    if (newThemeId == themeNameValue) {
      return;
    }
    if (newThemeId.isEmpty) {
      throw Exception('Theme ID cannot be empty');
    }
    if (customThemeDirFound == false) {
      throw Exception('Custom theme directory not found');
    }
    Map<String, String> themes = getThemes();
    List<String> themeIds = themes.values as List<String>;
    if (!themeIds.contains(newThemeId)) {
      throw Exception('Theme with ID $newThemeId was not found.');
    }
    await settingsStore.setString(themeNameKey, newThemeId);
    themeNameValue = newThemeId;
    notifyListeners();
  }
}
