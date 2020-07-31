import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme;
  Typography defaultTypography;
  SharedPreferences prefs;
  bool _isDark;
  ThemeData dark = ThemeData.dark().copyWith();

  ThemeData light = ThemeData.light().copyWith();

  ThemeProvider(bool darkThemeOn) {
    _selectedTheme = darkThemeOn ? dark : light;
  }

  bool get isDark => _isDark;

  Future<void> swapTheme() async {
    // prefs = await SharedPreferences.getInstance();

    if (_selectedTheme == dark) {
      _selectedTheme = light;
      _isDark = false;
      // await prefs.setBool("darkTheme", false);
    } else {
      _selectedTheme = dark;
      _isDark = true;
      // await prefs.setBool("darkTheme", true);
    }

    notifyListeners();
  }

  ThemeData getTheme() => _selectedTheme;
}