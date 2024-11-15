import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  // Observable for current theme mode
  var isDarkMode = false.obs;

  // Light and dark theme configurations
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: false,
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    primarySwatch: Colors.blueGrey,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
  );

  // Method to toggle theme
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(isDarkMode.value ? darkTheme : lightTheme);
  }
}
