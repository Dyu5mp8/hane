import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = appTheme;

  ThemeData get themeData => _themeData;

  get isDarkMode => _themeData == darkAppTheme;

  void setDarkMode() {
    setThemeData(darkAppTheme);
  } 

  void setLightMode() {
    setThemeData(appTheme);
  }

  void setThemeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }
}