import 'package:flutter/material.dart';

class AppTheme with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  // ...
}
