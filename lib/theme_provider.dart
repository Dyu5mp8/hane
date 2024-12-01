import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {

  ThemeProvider() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool('isDarkMode') == null) {
        _themeData = appTheme;
        return;
      }
      _themeData = prefs.getBool('isDarkMode')! ? darkAppTheme : appTheme;
      notifyListeners();
    });
  }

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
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('isDarkMode', isDarkMode);
    });
    notifyListeners();
  }
}