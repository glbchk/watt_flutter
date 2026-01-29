import 'package:flutter/material.dart';

const firstPrimaryColor = Color(0xFF1581FF);
const secondPrimaryColor = Color(0xFF0067E0);
const lightGreyColor = Color(0xFFF4F6F9);
const greyAppColor = Color(0xFF8692A9);
const borderTFColor = Color(0xFFDBDFE3);
const hintTextColor = Color(0xFFAEB8C8);

const wattBlackColor = Color(0xFF3D4B61);

const wattColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF1581FF), // Your main brand color
  onPrimary: Colors.white, // Color of text/icons on top of primary
  secondary: Color(0xFF0067E0), // Accent color
  onSecondary: Colors.black,
  error: Color(0xFFEB5757),
  onError: Colors.white,
  surface: Color(0xFFF4F6F9), // Background of cards/dialogs
  onSurface: Colors.black, // Text on background
);

const wattGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [firstPrimaryColor, secondPrimaryColor],
);

final logo = 'assets/images/watt_logo.png';
