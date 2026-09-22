import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xffA6FFA1),
      surfaceTint: Color(0xffBFFFBC),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffBFFFBC),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffB5D2CB),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffb6e3ff),
      onSecondaryContainer: Color(0xff39667e),
      tertiary: Color(0xff8142a3),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffdc97ff),
      onTertiaryContainer: Color(0xff652587),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff93000a),
      surface: Color(0xffffffff),
      onSurface: Color(0xff161c20),
      onSurfaceVariant: Color(0xff3d4850),
      outline: Color(0xff6d7981),
      outlineVariant: Color(0xffbcc8d1),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3135),
      inversePrimary: Color(0xff7ad0ff),
      primaryFixed: Color(0xffc3e8ff),
      onPrimaryFixed: Color(0xff001e2c),
      primaryFixedDim: Color(0xff7ad0ff),
      onPrimaryFixedVariant: Color(0xff004c69),
      secondaryFixed: Color(0xffc3e8ff),
      onSecondaryFixed: Color(0xff001e2c),
      secondaryFixedDim: Color(0xff9fcde8),
      onSecondaryFixedVariant: Color(0xff1b4c63),
      tertiaryFixed: Color(0xfff6d9ff),
      onTertiaryFixed: Color(0xff310049),
      tertiaryFixedDim: Color(0xffe7b3ff),
      onTertiaryFixedVariant: Color(0xff672889),
      surfaceDim: Color(0xffd5dbe0),
      surfaceBright: Color(0xfff5faff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff4fa),
      surfaceContainer: Color(0xffe9eef4),
      surfaceContainerHigh: Color(0xffe3e9ee),
      surfaceContainerHighest: Color(0xffdee3e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003b51),
      surfaceTint: Color(0xff00668a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff00759e),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003b51),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff46728b),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff551277),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff9151b3),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff740006),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffcf2c27),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5faff),
      onSurface: Color(0xff0c1216),
      onSurfaceVariant: Color(0xff2c383f),
      outline: Color(0xff49545c),
      outlineVariant: Color(0xff636f77),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3135),
      inversePrimary: Color(0xff7ad0ff),
      primaryFixed: Color(0xff00759e),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff005b7c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff46728b),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff2c5a72),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff9151b3),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff773899),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffc1c7cc),
      surfaceBright: Color(0xfff5faff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffeff4fa),
      surfaceContainer: Color(0xffe3e9ee),
      surfaceContainerHigh: Color(0xffd8dde3),
      surfaceContainerHighest: Color(0xffcdd2d7),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff003043),
      surfaceTint: Color(0xff00668a),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004f6c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff003043),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff1e4e65),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff49006c),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff6a2b8c),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff600004),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff98000a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff5faff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff000000),
      outline: Color(0xff222e34),
      outlineVariant: Color(0xff3f4b52),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2b3135),
      inversePrimary: Color(0xff7ad0ff),
      primaryFixed: Color(0xff004f6c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff00374c),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff1e4e65),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00374c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff6a2b8c),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff510c73),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffb4b9bf),
      surfaceBright: Color(0xfff5faff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xffecf1f7),
      surfaceContainer: Color(0xffdee3e8),
      surfaceContainerHigh: Color(0xffcfd5da),
      surfaceContainerHighest: Color(0xffc1c7cc),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff8fd6ff),
      surfaceTint: Color(0xff7ad0ff),
      onPrimary: Color(0xff003549),
      primaryContainer: Color(0xff00bfff),
      onPrimaryContainer: Color(0xff004a65),
      secondary: Color(0xff9fcde8),
      onSecondary: Color(0xff003549),
      secondaryContainer: Color(0xff1e4e65),
      onSecondaryContainer: Color(0xff92beda),
      tertiary: Color(0xffebbdff),
      onTertiary: Color(0xff4e0871),
      tertiaryContainer: Color(0xffdc97ff),
      onTertiaryContainer: Color(0xff652587),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0e1418),
      onSurface: Color(0xffdee3e8),
      onSurfaceVariant: Color(0xffbcc8d1),
      outline: Color(0xff87929b),
      outlineVariant: Color(0xff3d4850),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e8),
      inversePrimary: Color(0xff00668a),
      primaryFixed: Color(0xffc3e8ff),
      onPrimaryFixed: Color(0xff001e2c),
      primaryFixedDim: Color(0xff7ad0ff),
      onPrimaryFixedVariant: Color(0xff004c69),
      secondaryFixed: Color(0xffc3e8ff),
      onSecondaryFixed: Color(0xff001e2c),
      secondaryFixedDim: Color(0xff9fcde8),
      onSecondaryFixedVariant: Color(0xff1b4c63),
      tertiaryFixed: Color(0xfff6d9ff),
      onTertiaryFixed: Color(0xff310049),
      tertiaryFixedDim: Color(0xffe7b3ff),
      onTertiaryFixedVariant: Color(0xff672889),
      surfaceDim: Color(0xff0e1418),
      surfaceBright: Color(0xff343a3e),
      surfaceContainerLowest: Color(0xff090f13),
      surfaceContainerLow: Color(0xff161c20),
      surfaceContainer: Color(0xff1a2024),
      surfaceContainerHigh: Color(0xff252b2f),
      surfaceContainerHighest: Color(0xff30363a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffb5e3ff),
      surfaceTint: Color(0xff7ad0ff),
      onPrimary: Color(0xff00293a),
      primaryContainer: Color(0xff00bfff),
      onPrimaryContainer: Color(0xff002a3c),
      secondary: Color(0xffb5e2ff),
      onSecondary: Color(0xff00293a),
      secondaryContainer: Color(0xff6a96b0),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfff3d1ff),
      onTertiary: Color(0xff40005f),
      tertiaryContainer: Color(0xffdc97ff),
      onTertiaryContainer: Color(0xff410061),
      error: Color(0xffffd2cc),
      onError: Color(0xff540003),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff0e1418),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffd2dee7),
      outline: Color(0xffa8b3bc),
      outlineVariant: Color(0xff86929a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e8),
      inversePrimary: Color(0xff004e6a),
      primaryFixed: Color(0xffc3e8ff),
      onPrimaryFixed: Color(0xff00131d),
      primaryFixedDim: Color(0xff7ad0ff),
      onPrimaryFixedVariant: Color(0xff003b51),
      secondaryFixed: Color(0xffc3e8ff),
      onSecondaryFixed: Color(0xff00131d),
      secondaryFixedDim: Color(0xff9fcde8),
      onSecondaryFixedVariant: Color(0xff003b51),
      tertiaryFixed: Color(0xfff6d9ff),
      onTertiaryFixed: Color(0xff210033),
      tertiaryFixedDim: Color(0xffe7b3ff),
      onTertiaryFixedVariant: Color(0xff551277),
      surfaceDim: Color(0xff0e1418),
      surfaceBright: Color(0xff3f454a),
      surfaceContainerLowest: Color(0xff04080b),
      surfaceContainerLow: Color(0xff181e22),
      surfaceContainer: Color(0xff23292d),
      surfaceContainerHigh: Color(0xff2d3338),
      surfaceContainerHighest: Color(0xff383e43),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffe1f2ff),
      surfaceTint: Color(0xff7ad0ff),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff6dcdff),
      onPrimaryContainer: Color(0xff000d15),
      secondary: Color(0xffe1f2ff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff9cc9e4),
      onSecondaryContainer: Color(0xff000d15),
      tertiary: Color(0xfffceaff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffe5aeff),
      onTertiaryContainer: Color(0xff180027),
      error: Color(0xffffece9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffaea4),
      onErrorContainer: Color(0xff220001),
      surface: Color(0xff0e1418),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xffffffff),
      outline: Color(0xffe6f2fb),
      outlineVariant: Color(0xffb8c4cd),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffdee3e8),
      inversePrimary: Color(0xff004e6a),
      primaryFixed: Color(0xffc3e8ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff7ad0ff),
      onPrimaryFixedVariant: Color(0xff00131d),
      secondaryFixed: Color(0xffc3e8ff),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff9fcde8),
      onSecondaryFixedVariant: Color(0xff00131d),
      tertiaryFixed: Color(0xfff6d9ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffe7b3ff),
      onTertiaryFixedVariant: Color(0xff210033),
      surfaceDim: Color(0xff0e1418),
      surfaceBright: Color(0xff4b5155),
      surfaceContainerLowest: Color(0xff000000),
      surfaceContainerLow: Color(0xff1a2024),
      surfaceContainer: Color(0xff2b3135),
      surfaceContainerHigh: Color(0xff363c40),
      surfaceContainerHighest: Color(0xff42484c),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
    useMaterial3: true,
    brightness: colorScheme.brightness,
    colorScheme: colorScheme,
    textTheme: textTheme.apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    ),
    scaffoldBackgroundColor: colorScheme.background,
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
