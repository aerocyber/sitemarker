import "package:flutter/material.dart";

class MaterialTheme {
  // final TextTheme textTheme;

  const MaterialTheme();

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff35618e),
      surfaceTint: Color(0xff35618e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd1e4ff),
      onPrimaryContainer: Color(0xff001d36),
      secondary: Color(0xff535f70),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd6e4f7),
      onSecondaryContainer: Color(0xff0f1c2b),
      tertiary: Color(0xff006a6a),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9cf1f1),
      onTertiaryContainer: Color(0xff002020),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff42474e),
      outline: Color(0xff73777f),
      outlineVariant: Color(0xffc3c7cf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3135),
      inversePrimary: Color(0xffa0cafd),
      primaryFixed: Color(0xffd1e4ff),
      onPrimaryFixed: Color(0xff001d36),
      primaryFixedDim: Color(0xffa0cafd),
      onPrimaryFixedVariant: Color(0xff184974),
      secondaryFixed: Color(0xffd6e4f7),
      onSecondaryFixed: Color(0xff0f1c2b),
      secondaryFixedDim: Color(0xffbac8db),
      onSecondaryFixedVariant: Color(0xff3b4858),
      tertiaryFixed: Color(0xff9cf1f1),
      onTertiaryFixed: Color(0xff002020),
      tertiaryFixedDim: Color(0xff80d4d5),
      onTertiaryFixedVariant: Color(0xff004f50),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3f9),
      surfaceContainer: Color(0xffeceef4),
      surfaceContainerHigh: Color(0xffe6e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff124570),
      surfaceTint: Color(0xff35618e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4d77a6),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff374453),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff697687),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff004b4c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff238181),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff3f434a),
      outline: Color(0xff5b5f67),
      outlineVariant: Color(0xff767b83),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3135),
      inversePrimary: Color(0xffa0cafd),
      primaryFixed: Color(0xff4d77a6),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff325f8b),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff697687),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff505d6e),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff238181),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff006768),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3f9),
      surfaceContainer: Color(0xffeceef4),
      surfaceContainerHigh: Color(0xffe6e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002440),
      surfaceTint: Color(0xff35618e),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff124570),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff162332),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff374453),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002727),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff004b4c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff20242b),
      outline: Color(0xff3f434a),
      outlineVariant: Color(0xff3f434a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3135),
      inversePrimary: Color(0xffe1edff),
      primaryFixed: Color(0xff124570),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff002e51),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff374453),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff212e3c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff004b4c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff003333),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3f9),
      surfaceContainer: Color(0xffeceef4),
      surfaceContainerHigh: Color(0xffe6e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa0cafd),
      surfaceTint: Color(0xffa0cafd),
      onPrimary: Color(0xff003258),
      primaryContainer: Color(0xff184974),
      onPrimaryContainer: Color(0xffd1e4ff),
      secondary: Color(0xffbac8db),
      onSecondary: Color(0xff253140),
      secondaryContainer: Color(0xff3b4858),
      onSecondaryContainer: Color(0xffd6e4f7),
      tertiary: Color(0xff80d4d5),
      onTertiary: Color(0xff003737),
      tertiaryContainer: Color(0xff004f50),
      onTertiaryContainer: Color(0xff9cf1f1),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101418),
      onSurface: Color(0xffe1e2e8),
      onSurfaceVariant: Color(0xffc3c7cf),
      outline: Color(0xff8d9199),
      outlineVariant: Color(0xff42474e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff35618e),
      primaryFixed: Color(0xffd1e4ff),
      onPrimaryFixed: Color(0xff001d36),
      primaryFixedDim: Color(0xffa0cafd),
      onPrimaryFixedVariant: Color(0xff184974),
      secondaryFixed: Color(0xffd6e4f7),
      onSecondaryFixed: Color(0xff0f1c2b),
      secondaryFixedDim: Color(0xffbac8db),
      onSecondaryFixedVariant: Color(0xff3b4858),
      tertiaryFixed: Color(0xff9cf1f1),
      onTertiaryFixed: Color(0xff002020),
      tertiaryFixedDim: Color(0xff80d4d5),
      onTertiaryFixedVariant: Color(0xff004f50),
      surfaceDim: Color(0xff101418),
      surfaceBright: Color(0xff36393e),
      surfaceContainerLowest: Color(0xff0b0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa6ceff),
      surfaceTint: Color(0xffa0cafd),
      onPrimary: Color(0xff00172d),
      primaryContainer: Color(0xff6a94c4),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbfccdf),
      onSecondary: Color(0xff0a1725),
      secondaryContainer: Color(0xff8592a4),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xff84d9d9),
      onTertiary: Color(0xff001a1a),
      tertiaryContainer: Color(0xff479e9e),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101418),
      onSurface: Color(0xfffafaff),
      onSurfaceVariant: Color(0xffc7cbd3),
      outline: Color(0xff9fa3ab),
      outlineVariant: Color(0xff7f838b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff1a4a76),
      primaryFixed: Color(0xffd1e4ff),
      onPrimaryFixed: Color(0xff001225),
      primaryFixedDim: Color(0xffa0cafd),
      onPrimaryFixedVariant: Color(0xff003861),
      secondaryFixed: Color(0xffd6e4f7),
      onSecondaryFixed: Color(0xff051220),
      secondaryFixedDim: Color(0xffbac8db),
      onSecondaryFixedVariant: Color(0xff2b3746),
      tertiaryFixed: Color(0xff9cf1f1),
      onTertiaryFixed: Color(0xff001414),
      tertiaryFixedDim: Color(0xff80d4d5),
      onTertiaryFixedVariant: Color(0xff003d3e),
      surfaceDim: Color(0xff101418),
      surfaceBright: Color(0xff36393e),
      surfaceContainerLowest: Color(0xff0b0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffafaff),
      surfaceTint: Color(0xffa0cafd),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa6ceff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffafaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbfccdf),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffeafffe),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xff84d9d9),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101418),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffafaff),
      outline: Color(0xffc7cbd3),
      outlineVariant: Color(0xffc7cbd3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff002c4d),
      primaryFixed: Color(0xffd8e8ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa6ceff),
      onPrimaryFixedVariant: Color(0xff00172d),
      secondaryFixed: Color(0xffdbe8fc),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbfccdf),
      onSecondaryFixedVariant: Color(0xff0a1725),
      tertiaryFixed: Color(0xffa0f5f5),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xff84d9d9),
      onTertiaryFixedVariant: Color(0xff001a1a),
      surfaceDim: Color(0xff101418),
      surfaceBright: Color(0xff36393e),
      surfaceContainerLowest: Color(0xff0b0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
