import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import 'package:vault_mobile/controllers/login_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../controllers/document_controller.dart';
import 'dashboard_page.dart';
import 'qr_scanner_page.dart';
import 'settings_page.dart';
import '../../controllers/notification_controller.dart' as notify;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final _controller = Get.put(DashboardController());
  int _selectedIndex = 0;
  DateTime? currentBackPressTime;

  final List<Widget> _pages = [
    DashboardPage(),
    //  DashboardPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    configureFCM();
  }

  void _onItemTapped(int index) {
    debugPrint('Selected index = $index');
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    final currentTime = DateTime.now();
    final backPressTime = currentBackPressTime;
    final isBackPressValid = backPressTime == null ||
        currentTime.difference(backPressTime) > const Duration(seconds: 2);

    if (isBackPressValid) {
      currentBackPressTime = currentTime;
      Fluttertoast.showToast(
        msg: "Press back again to exit",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
      return Future.value(false);
    } else {
      return Future.value(true); // Exit the app
    }
  }

  void configureFCM() {
    final notify.NotificationController notificationController =
        Get.put(notify.NotificationController());

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Get FCM token
    messaging.getToken().then((token) {
      print("FCM Token: $token");
      if (token != null) {
        LoginController().updateToken(token);
      }
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message received: ${message.notification?.title}");

      notificationController.showLocalNotification(
        title: message.notification?.title ?? 'Vault Notification',
        body: message.notification?.body ?? 'Vault Notification',
      );

      _controller.fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Override the back button behavior
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              // BottomNavigationBarItem(
              //   icon: SizedBox.shrink(),
              //   label: '', // Empty label for the middle button
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: (index) {
              //  if (index != 1) {
              _onItemTapped(index);
              //  }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(const QRCodeScannerScreen());
            // setState(() {
            //   _selectedIndex = 1;
            // });
          },
          child: Icon(Icons.qr_code_scanner),
          tooltip: 'Scan',
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
