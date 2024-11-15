import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/theme_controller.dart';
import 'pages/home/dashboard_page.dart';
import 'pages/home/home_page.dart';
import 'pages/home/qr_scanner_page.dart';
import 'pages/home/settings_page.dart';
import 'pages/login/login.dart';
import 'services/theme_service.dart';

void main() async {
  await GetStorage.init(); // Initialize GetStorage
  runApp(VaultApp());
}

class VaultApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'Flutter Home Page with Bottom Navigation',
        theme: themeController.isDarkMode.value
            ? ThemeController.darkTheme
            : ThemeController.lightTheme,
        initialRoute: '/',
        getPages: [
          GetPage(name: '/', page: () => HomePage()),
          GetPage(name: '/dashboard', page: () => DashboardPage()),
          GetPage(name: '/scan', page: () => QRScannerPage()),
          GetPage(name: '/settings', page: () => SettingsPage()),
        ],
      );
    });
  }
}


// class VaultApp extends StatelessWidget {
//   final ThemeService _themeService = ThemeService();

//   @override
//   Widget build(BuildContext context) {
//     return ValueListenableBuilder(
//       valueListenable: _themeService.themeNotifier, // Listen to theme changes
//       builder: (context, ThemeMode themeMode, child) {
//         return MaterialApp(
//           title: 'VAULT',
//           theme: ThemeService.lightTheme,
//           darkTheme: ThemeService.darkTheme,
//           themeMode: themeMode,
//           home: LoginView(),
//         );
//       },
//     );
//   }
// }
