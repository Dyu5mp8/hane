import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_theme.dart';

enum AppThemeMode { light, dark, system }


class ThemeProvider extends ChangeNotifier with WidgetsBindingObserver {
  AppThemeMode _themeMode = AppThemeMode.light;

    @override
  void didChangePlatformBrightness() {
    if (_themeMode == AppThemeMode.system) {
      // Notify listeners to rebuild the UI with the new brightness
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }


  ThemeProvider() {
    WidgetsBinding.instance.addObserver(this);
    _loadTheme();
  }

  /// Returns the ThemeData based on the current mode.
  ThemeData get themeData {
    switch (_themeMode) {
      case AppThemeMode.dark:
        return darkAppTheme;
      case AppThemeMode.system:
        final brightness = WidgetsBinding.instance.window.platformBrightness;
        return brightness == Brightness.dark ? darkAppTheme : appTheme;
      case AppThemeMode.light:
      default:
        return appTheme;
    }
  }

  AppThemeMode get themeMode => _themeMode;

  

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('themeMode') ?? 'light';
    switch (themeString) {
      case 'dark':
        _themeMode = AppThemeMode.dark;
        break;
      case 'system':
        _themeMode = AppThemeMode.system;
        break;
      case 'light':
      default:
        _themeMode = AppThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String themeString;
    switch (_themeMode) {
      case AppThemeMode.dark:
        themeString = 'dark';
        break;
      case AppThemeMode.system:
        themeString = 'system';
        break;
      case AppThemeMode.light:
      default:
        themeString = 'light';
    }
    await prefs.setString('themeMode', themeString);
  }

  void setLightMode() {
    _themeMode = AppThemeMode.light;
    _saveTheme();
    notifyListeners();
  }

  void setDarkMode() {
    _themeMode = AppThemeMode.dark;
    _saveTheme();
    notifyListeners();
  }

  void setSystemTheme() {
    _themeMode = AppThemeMode.system;
    _saveTheme();
    notifyListeners();
  }
}