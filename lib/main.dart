import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import SystemChrome
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vault_mobile/controllers/notification_controller.dart';

import 'controllers/theme_controller.dart';
import 'pages/home/dashboard_page.dart';
import 'pages/home/home_page.dart';
import 'pages/home/qr_scanner_page.dart';
import 'pages/home/settings_page.dart';
import 'pages/login/login.dart';
import 'services/notification_service.dart';

void main() async {
  await GetStorage.init(); // Initialize GetStorage

  // Restrict app orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait mode (default orientation)
    DeviceOrientation
        .portraitDown, // Optional: Landscape flipped orientation (could be disabled based on use case)
  ]);

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

Future<void> requestOverlayPermission() async {
  bool granted = await FlutterOverlayWindow.requestPermission() ?? false;
  if (!granted) {
    // Handle permission denial
  }
}

Future<void> requestPermissions() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final bool isGranted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions() ??
      false;

  if (isGranted) {
    print("Notification permissions granted.");
  } else {
    print("Notification permissions denied.");
  }
}
