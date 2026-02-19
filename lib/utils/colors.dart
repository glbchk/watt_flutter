import 'package:flutter/material.dart';

// abstract class AppPalette {
//   // Red
//   static const red = Colors.red;
//   static const imperialRed = Color(0xFFE54B4B);
//
//   // White
//   static const seashell = Color(0xFFF7EBE8);
//
//   // Grey
//   static const grey = _GreyColors();
// }
//
// /// Alternative way to group colors in the palette.
// ///
// /// The downside is that you won't be able
// /// to use them as constructor default values,
// /// because they are not constants.
// ///
// /// Usage example: `AppPalette.grey.grey50`.
// class _GreyColors {
//   const _GreyColors();
//
//   final grey1 = const Color(0xFF8692A9);
//   final grey100 = const Color(0xFFF5F5F5);
//   // 0xFF8692A9
// }

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color error;
  final Color onError;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  //Grey colors
  final Color grey1;
  final Color grey2;
  final Color grey3;
  final Color grey4;
  //Specific colors
  final Color success;
  //Special
  final Color transparent;

  AppColorsExtension({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.error,
    required this.onError,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.grey1,
    required this.grey2,
    required this.grey3,
    required this.grey4,
    required this.success,
    required this.transparent,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? error,
    Color? onError,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? grey1,
    Color? grey2,
    Color? grey3,
    Color? grey4,
    Color? success,
    Color? transparent,
  }) {
    return AppColorsExtension(
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      grey1: grey1 ?? this.grey1,
      grey2: grey2 ?? this.grey2,
      grey3: grey3 ?? this.grey3,
      grey4: grey4 ?? this.grey4,
      success: success ?? this.success,
      transparent: transparent ?? this.transparent,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
    covariant ThemeExtension<AppColorsExtension>? other,
    double t,
  ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      secondary: Color.lerp(secondary, other.secondary, t)!,
      onSecondary: Color.lerp(onSecondary, other.onSecondary, t)!,
      error: Color.lerp(error, other.error, t)!,
      onError: Color.lerp(onError, other.onError, t)!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      grey1: Color.lerp(grey1, other.grey1, t)!,
      grey2: Color.lerp(grey2, other.grey2, t)!,
      grey3: Color.lerp(grey3, other.grey3, t)!,
      grey4: Color.lerp(grey4, other.grey4, t)!,
      success: Color.lerp(success, other.success, t)!,
      transparent: Color.lerp(transparent, other.transparent, t)!,
    );
  }
}

class AppTheme {
  //
  // Light theme
  //

  static final light = ThemeData.light().copyWith(
    extensions: [
      _lightAppColors,
    ],
  );

  static final _lightAppColors = AppColorsExtension(
    ///Usage: App bars, large "Call to Action" buttons (like "Sign Up"),
    ///and active states for checkboxes or radio buttons.
    primary: const Color(0xFF1581FF),

    ///Usage: The text or icon color sitting inside a Primary-colored button or App bar.
    ///Usually white or black.
    onPrimary: Colors.white,

    ///Usage: Floating Action Buttons (FABs), filter chips, or highlighting selected text.
    secondary: Color(0xFF0067E0),

    ///Usage: The text/icon color inside a Secondary-colored component.
    onSecondary: Colors.black,

    ///Usage: The border of a text field when the input is wrong, "Delete" buttons, or error icons.
    error: const Color(0xFFEB5757),

    ///Usage: The white text sitting on top of a red "Delete" button or inside an error snackbar.
    onError: Colors.white,

    ///Usage: The Scaffold background. It’s usually a very subtle off-white or deep charcoal.
    background: Colors.white,

    ///Usage: Main body text and headlines that sit directly on the screen's background.
    onBackground: Colors.black,

    ///Usage: Cards, Dialog boxes, Bottom Sheets, and Navigation Drawers. It helps create depth.
    surface: Color(0xFFF4F6F9),

    ///Usage: Text and icons inside a Card or a Modal.
    onSurface: const Color(0xFF3D4B61),

    ///Usage: Some titles with medium dark grey color
    grey1: const Color(0xFF8692A9),

    ///Usage: Text hint color
    grey2: const Color(0xFFAEB8C8),

    ///Usage: Color for border of textfields
    grey3: const Color(0xFFDBDFE3),

    ///Usage: Background under some icons
    grey4: const Color(0xFFF4F6F9),

    ///Usage: Color for success accent color (Green)
    success: const Color(0xFF37C750),

    ///Usage: Transparent color
    transparent: const Color(0x00000000),
  );

  //
  // Dark theme
  //

  static final dark = ThemeData.dark().copyWith(
    extensions: [
      _darkAppColors,
    ],
  );

  static final _darkAppColors = AppColorsExtension(
    primary: const Color(0xFF1581FF),
    onPrimary: Colors.black,
    secondary: const Color(0xff03dac6),
    onSecondary: Colors.black,
    error: const Color(0xFFEB5757),
    onError: Colors.white,
    background: const Color(0xFF3D4B61),
    onBackground: Colors.white,
    surface: const Color(0xff121212),
    onSurface: Colors.white,
    //Need to adjust grey1 for darkTheme
    grey1: const Color(0xFF8692A9),
    grey2: const Color(0xFFAEB8C8),
    grey3: const Color(0xFFDBDFE3),
    grey4: const Color(0xFFF4F6F9),
    success: const Color(0xFF37C750),
    transparent: const Color(0x00000000),
  );
}

extension AppThemeExtension on ThemeData {
  /// Usage example: Theme.of(context).appColors;
  AppColorsExtension get appColors =>
      extension<AppColorsExtension>() ?? AppTheme._lightAppColors;
}

extension ThemeGetter on BuildContext {
  // Usage example: `context.theme`
  ThemeData get theme => Theme.of(this);
}

// const firstPrimaryColor = Color(0xFF1581FF);
// const secondPrimaryColor = Color(0xFF0067E0);
// const lightGreyColor = Color(0xFFF4F6F9);
// const greyAppColor = Color(0xFF8692A9);
// const borderTFColor = Color(0xFFDBDFE3);
// const hintTextColor = Color(0xFFAEB8C8);
// const successColor = Color(0xFF37C750);
// // const anotherGreyColor = Color(0xFF4B545A);
//
// const wattBlackColor = Color(0xFF3D4B61);
//
// const wattColorScheme = ColorScheme(
//   brightness: Brightness.light,
//   primary: Color(0xFF1581FF), // Your main brand color
//   onPrimary: Colors.white, // Color of text/icons on top of primary
//   secondary: Color(0xFF0067E0), // Accent color
//   onSecondary: Colors.black,
//   error: Color(0xFFEB5757),
//   onError: Colors.white,
//   surface: Color(0xFFF4F6F9), // Background of cards/dialogs
//   onSurface: Colors.black, // Text on background
// );

final wattGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    AppTheme._lightAppColors.primary,
    AppTheme._lightAppColors.secondary,
  ],
);

final logo = 'assets/images/watt_logo.png';
