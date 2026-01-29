import 'package:flutter/material.dart';
import 'package:watt/utils/colors.dart';

final ThemeData lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: firstPrimaryColor,
    primary: firstPrimaryColor,
    secondary: secondPrimaryColor,
    brightness: Brightness.light,
  ),

  scaffoldBackgroundColor: lightGreyColor,

  appBarTheme: const AppBarTheme(
    backgroundColor: firstPrimaryColor,
    foregroundColor: Colors.white,
    elevation: 0,
  ),

  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: greyAppColor),
  ),

  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: borderTFColor),
    ),
    hintStyle: TextStyle(color: hintTextColor),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: firstPrimaryColor,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  ),
);
