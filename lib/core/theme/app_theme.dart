import 'package:flutter/material.dart';
import 'package:go_to_save_app/core/theme/app_palette.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData appTheme() {
  final palette = appPalette;

  final colorScheme = ColorScheme(
    brightness: Brightness.light,

    // Primary
    primary: palette.sky,
    onPrimary: palette.white,
    primaryContainer: palette.lavender,
    onPrimaryContainer: palette.text,

    // Secondary
    secondary: palette.mauve,
    onSecondary: palette.crust,
    secondaryContainer: palette.sapphire,
    onSecondaryContainer: palette.text,

    // Tertiary
    tertiary: palette.pink,
    onTertiary: palette.white,
    tertiaryContainer: palette.sky,
    onTertiaryContainer: palette.text,

    // Error
    error: palette.red,
    onError: palette.white,
    errorContainer: palette.maroon,
    onErrorContainer: palette.red,

    // Surfaces
    surface: palette.base,
    onSurface: palette.text,

    surfaceDim: palette.mantle,
    surfaceBright: palette.white,

    surfaceContainerLowest: palette.white,
    surfaceContainerLow: palette.base,
    surfaceContainer: palette.mantle,
    surfaceContainerHigh: palette.crust,
    surfaceContainerHighest: palette.surface0,

    // Outline
    outline: palette.surface1,
    outlineVariant: palette.surface0,

    // Other
    shadow: Colors.black,
    scrim: Colors.black,
  );

  final textTheme = GoogleFonts.poppinsTextTheme().copyWith(
    displayLarge: GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: palette.text,
    ),
    displayMedium: GoogleFonts.poppins(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: palette.text,
    ),
    displaySmall: GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: palette.text,
    ),

    headlineLarge: GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      color: palette.text,
    ),
    headlineMedium: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: palette.text,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: palette.text,
    ),

    titleLarge: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: palette.text,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: palette.text,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: palette.text,
    ),

    bodyLarge: GoogleFonts.poppins(fontSize: 16, color: palette.text),
    bodyMedium: GoogleFonts.poppins(fontSize: 14, color: palette.text),
    bodySmall: GoogleFonts.poppins(fontSize: 12, color: palette.subtext0),

    labelLarge: GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: palette.text,
    ),
    labelMedium: GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: palette.text,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: palette.subtext0,
    ),
  );

  return ThemeData(
    useMaterial3: true,

    colorScheme: colorScheme,

    scaffoldBackgroundColor: palette.base,

    textTheme: textTheme,

    // ------------------------------------------------------------
    // AppBar
    // ------------------------------------------------------------
    appBarTheme: AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: palette.base,
      foregroundColor: palette.text,
      surfaceTintColor: Colors.transparent,

      titleTextStyle: textTheme.titleLarge,

      iconTheme: IconThemeData(color: palette.text),
    ),

    // ------------------------------------------------------------
    // Cards
    // ------------------------------------------------------------
    cardTheme: CardThemeData(
      elevation: 0,
      color: palette.mantle,
      surfaceTintColor: Colors.transparent,
      margin: EdgeInsets.zero,

      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // ------------------------------------------------------------
    // Buttons
    // ------------------------------------------------------------
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        //elevation: 0,
        backgroundColor: palette.crust,
        foregroundColor: palette.sky,

        // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        textStyle: textTheme.labelLarge,
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: palette.sky,
        foregroundColor: palette.white,

        //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        textStyle: textTheme.labelLarge,
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.sky,
        side: BorderSide(color: palette.surface1),

        //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        textStyle: textTheme.labelLarge,
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: palette.sky,
        textStyle: textTheme.labelLarge,
      ),
    ),

    // ------------------------------------------------------------
    // Text fields
    // ------------------------------------------------------------
    inputDecorationTheme: InputDecorationTheme(
      // filled: true,
      // fillColor: palette.crust,

      //contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.surface1),
      ),

      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.surface1),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.sky, width: 2),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.red),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: palette.red, width: 2),
      ),

      hintStyle: TextStyle(color: palette.subtext0),

      labelStyle: TextStyle(color: palette.subtext1),

      floatingLabelStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.focused)) {
          return TextStyle(color: palette.sky);
        }
        return TextStyle(color: palette.text);
      }),

      errorStyle: TextStyle(color: palette.red),
    ),

    // ------------------------------------------------------------
    // Floating action button
    // ------------------------------------------------------------
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      elevation: 0,
      backgroundColor: palette.mauve,
      foregroundColor: palette.white,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    // ------------------------------------------------------------
    // Snackbars
    // ------------------------------------------------------------
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,

      backgroundColor: palette.text,
      contentTextStyle: TextStyle(color: palette.base, fontSize: 14),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // ------------------------------------------------------------
    // Dialogs
    // ------------------------------------------------------------
    dialogTheme: DialogThemeData(
      backgroundColor: palette.base,
      surfaceTintColor: Colors.transparent,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),

      titleTextStyle: textTheme.headlineSmall,
      contentTextStyle: textTheme.bodyMedium,
    ),

    // ------------------------------------------------------------
    // Divider
    // ------------------------------------------------------------
    dividerTheme: DividerThemeData(
      color: palette.surface1,
      thickness: 1,
      space: 1,
    ),

    // ------------------------------------------------------------
    // Checkbox
    // ------------------------------------------------------------
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),

      side: BorderSide(color: palette.surface1),

      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.mauve;
        }

        return palette.crust;
      }),

      checkColor: WidgetStateProperty.all(palette.white),
    ),

    // ------------------------------------------------------------
    // Switch
    // ------------------------------------------------------------
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.white;
        }

        return palette.surface2;
      }),

      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return palette.mauve;
        }

        return palette.crust;
      }),

      trackOutlineColor: WidgetStateProperty.all(palette.surface1),
    ),

    // ------------------------------------------------------------
    // Progress indicators
    // ------------------------------------------------------------
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: palette.mauve,
      linearTrackColor: palette.crust,
      circularTrackColor: palette.crust,
    ),

    // ------------------------------------------------------------
    // Bottom navigation
    // ------------------------------------------------------------
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: palette.mantle,
      surfaceTintColor: Colors.transparent,
      elevation: 0,

      indicatorColor: palette.crust,

      labelTextStyle: WidgetStateProperty.all(textTheme.labelMedium),

      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(color: palette.mauve);
        }

        return IconThemeData(color: palette.subtext0);
      }),
    ),
  );
}

// import 'package:flutter/material.dart';
// import 'package:go_to_save_app/core/theme/app_palette.dart';
// import 'package:google_fonts/google_fonts.dart';

// ThemeData appTheme() {
//   final palette = appPalette;
//   final primaryColor = palette.mauve;
//   final secondaryColor = palette.pink;

//   return ThemeData(
//     useMaterial3: true,
//     appBarTheme: AppBarTheme(
//       elevation: 0,
//       titleTextStyle: TextStyle(
//         color: palette.text,
//         fontSize: 20,
//         fontWeight: FontWeight.bold,
//       ),
//       backgroundColor: palette.base,
//       foregroundColor: palette.text,
//     ),
//     colorScheme: ColorScheme(
//       brightness: Brightness.light,
//       error: palette.red,
//       onError: palette.surface0,
//       onPrimary: primaryColor,
//       onSecondary: secondaryColor,
//       surface: palette.base,
//       onSurface: palette.text,
//       surfaceContainer: palette.surface0,
//       primary: palette.crust,
//       secondary: palette.mantle,
//     ),
//     textTheme: GoogleFonts.poppinsTextTheme().apply(
//       bodyColor: palette.text,
//       displayColor: primaryColor,
//     ),
//     floatingActionButtonTheme: const FloatingActionButtonThemeData(
//       elevation: 0,
//     ),
//   );
// }

// // abstract final class AppTheme {
// //   static final light = ThemeData(
// //     useMaterial3: true,
// //     textTheme: GoogleFonts.poppinsTextTheme(),
// //     // colorScheme: const ColorScheme.light(
// //     //   primary: AppPalette.primary,
// //     //   onPrimary: AppPalette.black,

// //     //   primaryContainer: AppPalette.primaryLight,
// //     //   onPrimaryContainer: AppPalette.black,

// //     //   secondary: AppPalette.black,
// //     //   onSecondary: AppPalette.white,

// //     //   surface: AppPalette.white,
// //     //   onSurface: AppPalette.black,

// //     //   outline: AppPalette.border,

// //     //   error: AppPalette.error,
// //     //   onError: AppPalette.white,

// //     //   surfaceContainerLowest: AppPalette.background,
// //     // ),

// //     // inputDecorationTheme: InputDecorationTheme(
// //     //   fillColor: AppPalette.background,

// //     //   border: OutlineInputBorder(
// //     //     borderRadius: BorderRadius.circular(12),
// //     //     borderSide: BorderSide.none,
// //     //   ),

// //     //   enabledBorder: OutlineInputBorder(
// //     //     borderRadius: BorderRadius.circular(12),
// //     //     borderSide: const BorderSide(color: AppPalette.black),
// //     //   ),

// //     //   focusedBorder: OutlineInputBorder(
// //     //     borderRadius: BorderRadius.circular(12),
// //     //     borderSide: const BorderSide(color: AppPalette.black, width: 2),
// //     //   ),
// //     // ),
// //     // colorScheme: const ColorScheme.light(
// //     //   primary: AppPalette.primary,
// //     //   onPrimary: AppPalette.black,

// //     //   primaryContainer: Color(0xFFDDF6FC),
// //     //   onPrimaryContainer: AppPalette.black,

// //     //   secondary: AppPalette.black,
// //     //   onSecondary: AppPalette.white,

// //     //   surface: AppPalette.white,
// //     //   onSurface: AppPalette.black,

// //     //   surfaceContainerLowest: AppPalette.background,

// //     //   error: Color(0xFFD32F2F),
// //     //   onError: AppPalette.white,
// //     // ),

// //     // scaffoldBackgroundColor: AppPalette.white,

// //     // appBarTheme: const AppBarTheme(
// //     //   backgroundColor: AppPalette.white,
// //     //   foregroundColor: AppPalette.black,
// //     //   elevation: 0,
// //     //   centerTitle: true,
// //     // ),

// //     // cardTheme: const CardThemeData(
// //     //   color: AppPalette.white,
// //     //   elevation: 0,
// //     //   margin: EdgeInsets.zero,
// //     // ),

// //     // elevatedButtonTheme: ElevatedButtonThemeData(
// //     //   style: ElevatedButton.styleFrom(
// //     //     backgroundColor: AppPalette.primary,
// //     //     foregroundColor: AppPalette.black,
// //     //     elevation: 0,
// //     //     minimumSize: const Size.fromHeight(48),
// //     //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //     //   ),
// //     // ),

// //     // outlinedButtonTheme: OutlinedButtonThemeData(
// //     //   style: OutlinedButton.styleFrom(
// //     //     foregroundColor: AppPalette.black,
// //     //     side: const BorderSide(color: AppPalette.black),
// //     //     minimumSize: const Size.fromHeight(48),
// //     //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //     //   ),
// //     // ),

// //     // inputDecorationTheme: InputDecorationTheme(
// //     //   filled: true,
// //     //   fillColor: AppPalette.white,

// //     //   border: OutlineInputBorder(
// //     //     borderRadius: BorderRadius.circular(12),
// //     //     borderSide: BorderSide.none,
// //     //   ),

// //     //   enabledBorder: OutlineInputBorder(
// //     //     borderRadius: BorderRadius.circular(12),
// //     //     borderSide: const BorderSide(color: AppPalette.black),
// //     //   ),

// //     //   focusedBorder: OutlineInputBorder(
// //     //     borderRadius: BorderRadius.circular(12),
// //     //     borderSide: const BorderSide(color: AppPalette.primary, width: 2),
// //     //   ),
// //     // ),
// //   );
// // }
