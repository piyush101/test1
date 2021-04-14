import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme;

  ThemeData light = ThemeData.light();
  ThemeData dark = ThemeData.dark();
  bool isDarkMode;
  SharedPreferences sharedPreferences;

  DarkThemeProvider(bool isDarkMode) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  ThemeData get getTheme => _selectedTheme;

  Future<void> swapTheme() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      isDarkMode = false;
      sharedPreferences.setBool("isDarkTheme", false);
    } else {
      _selectedTheme = dark;
      isDarkMode = true;
      sharedPreferences.setBool("isDarkTheme", true);
    }
    notifyListeners();
    // notifyListeners();
  }
}
