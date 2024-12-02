import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import SystemChrome
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:vault_mobile/controllers/notification_controller.dart';
import 'controllers/theme_controller.dart';
import 'pages/home/dashboard_page.dart';
import 'pages/home/document_page.dart';
import 'pages/home/home_page.dart';
import 'pages/home/qr_scanner_page.dart';
import 'pages/home/settings_page.dart';
import 'pages/login/login.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init(); // Initialize GetStorage

  await Firebase.initializeApp();

  // Restrict app orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Portrait mode (default orientation)
  ]);

  //configureFCM();
  runApp(VaultApp());
}

void requestNotificationPermissions() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
}

class VaultApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());
  final GetStorage storage = GetStorage(); // Instance of GetStorage

  @override
  Widget build(BuildContext context) {
    // Check if user data exists
    final bool isLoggedIn = storage.read('user') != null;

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vault App',
        theme: themeController.isDarkMode.value
            ? ThemeController.darkTheme
            : ThemeController.lightTheme,
        initialRoute:
            isLoggedIn ? '/home' : '/login', // Navigate based on login status
        getPages: [
          GetPage(name: '/login', page: () => LoginView()),
          GetPage(name: '/home', page: () => HomePage()),
          GetPage(name: '/dashboard', page: () => DashboardPage()),
          GetPage(name: '/scan', page: () => QRCodeScannerScreen()),
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
