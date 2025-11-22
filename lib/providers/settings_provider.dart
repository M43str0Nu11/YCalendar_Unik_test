import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _timezone = DateTime.now().timeZoneName;

  ThemeMode get themeMode => _themeMode;
  String get timezone => _timezone;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setTimezone(String tz) {
    _timezone = tz;
    notifyListeners();
  }
}
