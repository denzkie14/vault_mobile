import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  // Keys and instance of GetStorage
  static const _key = 'isDarkMode';
  final _box = GetStorage();

  // Theme mode notifier to rebuild the UI on theme change
  ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  ThemeService() {
    // Set initial theme mode based on stored preference
    themeNotifier.value = _loadThemeMode();
  }

  // Load theme mode from GetStorage
  ThemeMode _loadThemeMode() {
    bool isDarkMode = _box.read(_key) ?? false;
    return isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // Save the theme mode to storage and notify listeners
  void switchTheme() {
    bool isDarkMode = themeNotifier.value == ThemeMode.dark;
    themeNotifier.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    _box.write(_key, !isDarkMode);
  }

  // Define light and dark themes
  static final ThemeData lightTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
  );
}
