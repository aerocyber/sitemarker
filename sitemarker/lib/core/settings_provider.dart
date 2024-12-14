import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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

  /// Settings DB
  late final FlutterSecureStorage settingsStore;

  SMSettingsProvider() {
    // Create the instance
    settingsStore = const FlutterSecureStorage();
    init();
  }

  /// Initialize the settings. If no value is found for a key, provide a default
  /// value. Also, populate the secure store with defaults if they're not populated
  /// already. This function is called from the constructor of this class.
  init() async {
    themeNameValue =
        (await settingsStore.read(key: themeNameKey)) ?? themeNameValue;
    if ((await settingsStore.read(key: themeNameKey)) == null) {
      settingsStore.write(key: themeNameKey, value: themeNameValue);
    }
    themeModeValue =
        (await settingsStore.read(key: themeModeKey)) ?? themeModeValue;
    if ((await settingsStore.read(key: themeModeKey)) == null) {
      settingsStore.write(key: themeModeKey, value: themeModeValue);
    }
    SmTheme st = SmTheme();
    themeDir = await st.getThemePath();
    notifyListeners();
  }

  /// Get the currently set theme
  String getCurrentTheme() => themeNameValue;

  /// Get the currently set theme mode
  String getCurrentThemeMode() => themeModeKey;

  /// Change the theme mode. Allowed values are `system`, `light` and `dark`
  changeThemeMode(String newMode) async {
    newMode = newMode.toLowerCase();
    if (!['system', 'light', 'dark'].contains(newMode)) {
      throw Exception('Invalid Theme Mode');
    }
    await settingsStore.write(key: themeModeKey, value: newMode);
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
    Map<String, String> themes = getThemes();
    List<String> themeIds = themes.values as List<String>;
    if (!themeIds.contains(newThemeId)) {
      throw Exception('Theme with ID $newThemeId was not found.');
    }
    await settingsStore.write(key: themeNameKey, value: newThemeId);
    themeNameValue = newThemeId;
    notifyListeners();
  }
}

