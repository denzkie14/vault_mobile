import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  // Observable for current theme mode
  var isDarkMode = false.obs;

  // Light and dark theme configurations
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    primaryColor: Color(0xFF0c6496), // Set the primary color for light theme
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
  );

  final GetStorage _storage = GetStorage();
  final String _themeKey = 'isDarkMode';

  @override
  void onInit() {
    super.onInit();
    // Load the saved theme mode on initialization
    isDarkMode.value = _storage.read(_themeKey) ?? false;
    Get.changeTheme(isDarkMode.value ? darkTheme : lightTheme);
  }

  // Method to toggle theme and save it
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? darkTheme : lightTheme);
    _saveThemeMode();
  }

  // Save the theme mode in GetStorage
  void _saveThemeMode() {
    _storage.write(_themeKey, isDarkMode.value);
  }
}
