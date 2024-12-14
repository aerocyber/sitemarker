import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sitemarker/core/data_types/settings/theme.dart';

/// `SmTheme` class is used for managing the themes
/// Palettes are not supported yet though it is requried in colorsfile so as
/// not to break the file when it is introduced.
class SmTheme {
  late final List<String> themeStore;

  SmTheme() {
    init();
  }

  /// Initialize the themes. Packages themes are manually added to this list.
  /// For loading custom themes, see [loadCustomThemes] function
  init() async {
    themeStore = [
      await rootBundle.loadString('assets/themes/default.colorsfile'),
    ];
    loadCustomThemes();
  }

  /// Load custom themes from user directories. Custom themes are not supported
  /// on web. Note: Web is **_NOT_** supported.
  loadCustomThemes() async {
    Directory themeDir = Directory(await getThemePath());
    // Get the themes
    List<FileSystemEntity> themesInDir = await themeDir.list().toList();
    for (int i = 0; i < themesInDir.length; i++) {
      // Add the theme after reading it
      themeStore.add(await File(themesInDir[i].path).readAsString());
    }
  }

  /// Get the colorscheme from theme parameters.
  /// - `themeId` is the Id of the theme
  /// - `themeScheme` is the scheme to be used. Allowed values are one among `light`, `light-medium-contrast`,
  ///   `light-high-contrast`, `dark`, `dark-medium-contrast` and `dark-high-contrast`.
  ColorScheme getColorScheme(
      String themeId, String themeScheme, Brightness themeBrightness) {
    String? themeStr;
    List<String> allowedSchemes = [
      'light',
      'light-medium-contrast',
      'light-high-contrast',
      'dark',
      'dark-medium-contrast',
      'dark-high-contrast'
    ];
    if (!allowedSchemes.contains(themeScheme)) {
      throw Exception('Invalid scheme');
    }

    for (String i in themeStore) {
      if (json.decode(i)['id'] == themeId) {
        themeStr = i;
      }
    }

    if (themeStr == null) {
      throw Exception('Theme with Id $themeId was not found.');
    }

    try {
      return SMThemeBuilder.colorSchemeFromJSON(
          themeStr, themeScheme, themeBrightness);
    } catch (e) {
      rethrow;
    }
  }

  /// Get the loaded themes
  List<String> getThemeStore() => themeStore;

  /// Get the path to the themes dir.
  /// Default path is one among:
  ///   - $XDG_DATA_HOME/themes
  ///   - $SNAP_USER_COMMON/themes
  ///   - (Default application support directory as goven by `path_provider`)/themes
  Future<String> getThemePath() async {
    if (Platform.environment["XDG_DATA_HOME"] != null) {
      return File("${Platform.environment["XDG_DATA_HOME"]}/themes/")
          .parent
          .path;
    } else if (Platform.environment['SNAP_USER_COMMON'] != null) {
      return File("${Platform.environment["SNAP_USER_COMMON"]}/themes/")
          .parent
          .path;
    } else {
      return File("${(await getApplicationSupportDirectory()).path}/themes/")
          .parent
          .path;
    }
  }
}
