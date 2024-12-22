import 'package:flutter/material.dart';
import 'dart:convert';

/// The class used for colorscheme and related (theme related) functions.
/// This class parses the colorsfile content for appropriate stuff.
/// Used internally by Sitemarker's theming parser.
class SMThemeBuilder {
  final Color primary;
  final Color surfaceTint;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color secondary;
  final Color onSecondary;
  final Color secondaryContainer;
  final Color onSecondaryContainer;
  final Color tertiary;
  final Color onTertiary;
  final Color tertiaryContainer;
  final Color onTertiaryContainer;
  final Color error;
  final Color onError;
  final Color errorContainer;
  final Color onErrorContainer;
  final Color surface;
  final Color onSurface;
  final Color surfaceContainerHighest;
  final Color onSurfaceVariant;
  final Color outline;
  final Color outlineVariant;
  final Color shadow;
  final Color scrim;
  final Color inverseSurface;
  final Color inversePrimary;
  final Color primaryFixed;
  final Color onPrimaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixedVariant;
  final Color secondaryFixed;
  final Color onSecondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixedVariant;
  final Color tertiaryFixed;
  final Color onTertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixedVariant;
  final Color surfaceDim;
  final Color surfaceBright;
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  final Color surfaceContainerHigh;

  SMThemeBuilder({
    required this.primary,
    required this.surfaceTint,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.surface,
    required this.onSurface,
    required this.surfaceContainerHighest,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.inversePrimary,
    required this.primaryFixed,
    required this.onPrimaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.onSecondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.onTertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixedVariant,
    required this.surfaceDim,
    required this.surfaceBright,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
  });

  /// Get a `ColorScheme` from `jsonString`, `scheme` and `brightness`.
  /// Not to be used directly. Use it from [SmTheme.getColorScheme()]
  static ColorScheme colorSchemeFromJSON(
      String jsonString, String scheme, Brightness brightness) {
    Map<String, Color> themeSet = {};
    List<String> keys = [
      'primary',
      'surfaceTint',
      'onPrimary',
      'primaryContainer',
      'onPrimaryContainer',
      'secondary',
      'onSecondary',
      'secondaryContainer',
      'onSecondaryContainer',
      'tertiary',
      'onTertiary',
      'tertiaryContainer',
      'onTertiaryContainer',
      'error',
      'onError',
      'errorContainer',
      'onErrorContainer',
      'surface',
      'onSurface',
      'surfaceContainerHighest',
      'onSurfaceVariant',
      'outline',
      'outlineVariant',
      'shadow',
      'scrim',
      'inverseSurface',
      'inversePrimary',
      'primaryFixed',
      'onPrimaryFixed',
      'primaryFixedDim',
      'onPrimaryFixedVariant',
      'secondaryFixed',
      'onSecondaryFixed',
      'secondaryFixedDim',
      'onSecondaryFixedVariant',
      'tertiaryFixed',
      'onTertiaryFixed',
      'tertiaryFixedDim',
      'onTertiaryFixedVariant',
      'surfaceDim',
      'surfaceBright',
      'surfaceContainerLowest',
      'surfaceContainerLow',
      'surfaceContainer',
      'surfaceContainerHigh',
    ];

    Map<String, dynamic> conv = json.decode(jsonString);

    if (!conv.containsKey('schemes')) {
      throw Exception('Invalid colorsfile. No key named `scheme` was found.');
    }

    Map<String, Map<String, String>> convertedSchemes = conv['schemes'];

    if (!convertedSchemes.containsKey(scheme)) {
      throw Exception('Invalid colorsfile. No scheme named $scheme was found.');
    }

    Map<String, String> colorScheme = convertedSchemes[scheme]!;
    Color colorCode;

    for (int i = 0; i < keys.length; i++) {
      if (!colorScheme.keys.contains(keys[i])) {
        throw Exception(
            'Invalid colorsfile. No required key: ${keys[i]} was found.');
      }
      colorCode = getColorCode(colorScheme[keys[i]]!);

      themeSet.addAll({keys[i]: colorCode});
    }

    return ColorScheme(
      brightness: brightness,
      primary: themeSet['primary']!,
      surfaceTint: themeSet['surfaceTint']!,
      onPrimary: themeSet['onPrimary']!,
      primaryContainer: themeSet['primaryContainer']!,
      onPrimaryContainer: themeSet['onPrimaryContainer']!,
      secondary: themeSet['secondary']!,
      onSecondary: themeSet['onSecondary']!,
      secondaryContainer: themeSet['secondaryContainer']!,
      onSecondaryContainer: themeSet['onSecondaryContainer']!,
      tertiary: themeSet['tertiary']!,
      onTertiary: themeSet['onTertiary']!,
      tertiaryContainer: themeSet['tertiaryContainer']!,
      onTertiaryContainer: themeSet['onTertiaryContainer']!,
      error: themeSet['error']!,
      onError: themeSet['onError']!,
      errorContainer: themeSet['errorContainer']!,
      onErrorContainer: themeSet['onErrorContainer']!,
      surface: themeSet['surface']!,
      onSurface: themeSet['onSurface']!,
      surfaceContainerHighest: themeSet['surfaceVariant']!,
      onSurfaceVariant: themeSet['onSurfaceVariant']!,
      outline: themeSet['outline']!,
      outlineVariant: themeSet['outlineVariant']!,
      shadow: themeSet['shadow']!,
      scrim: themeSet['scrim']!,
      inverseSurface: themeSet['inverseSurface']!,
      inversePrimary: themeSet['inversePrimary']!,
      primaryFixed: themeSet['primaryFixed']!,
      onPrimaryFixed: themeSet['onPrimaryFixed']!,
      primaryFixedDim: themeSet['primaryFixedDim']!,
      onPrimaryFixedVariant: themeSet['onPrimaryFixedVariant']!,
      secondaryFixed: themeSet['secondaryFixed']!,
      onSecondaryFixed: themeSet['onSecondaryFixed']!,
      secondaryFixedDim: themeSet['secondaryFixedDim']!,
      onSecondaryFixedVariant: themeSet['onSecondaryFixedVariant']!,
      tertiaryFixed: themeSet['tertiaryFixed']!,
      onTertiaryFixed: themeSet['onTertiaryFixed']!,
      tertiaryFixedDim: themeSet['tertiaryFixedDim']!,
      onTertiaryFixedVariant: themeSet['onTertiaryFixedVariant']!,
      surfaceDim: themeSet['surfaceDim']!,
      surfaceBright: themeSet['surfaceBright']!,
      surfaceContainerLowest: themeSet['surfaceContainerLowest']!,
      surfaceContainerLow: themeSet['surfaceContainerLow']!,
      surfaceContainer: themeSet['surfaceContainer']!,
      surfaceContainerHigh: themeSet['surfaceContainerHigh']!,
    );
  }

  /// Get `Color` from a hex string prefixed with #
  static Color getColorCode(String hexString) {
    String colorStr = "";
    colorStr += hexString.split('#').last;
    return Color(int.parse(colorStr, radix: 16));
  }
}
