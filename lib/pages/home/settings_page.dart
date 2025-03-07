import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/notification_controller.dart' as notify;
import '../../models/user_model.dart';
import '../../widgets/confirm_dialog.dart';

class SettingsPage extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final notify.NotificationController notificationController =
      Get.put(notify.NotificationController());
  final GetStorage storage = GetStorage();
  SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = User.fromJson(storage.read('user'));
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          UserAccountsDrawerHeader(
              currentAccountPicture: Image.asset('assets/images/user.png'),
              accountName: Text(
                '${user.firstName} ${user.lastName}'.toUpperCase(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(user.officeDescription)),
          // Dark Mode Switch with padding, separator, and icon
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Obx(() {
              return SwitchListTile(
                title: Text('Dark Mode'),
                value: themeController.isDarkMode.value,
                onChanged: (value) => themeController.toggleTheme(),
                secondary: Icon(Icons.brightness_6),
              );
            }),
          ),
          const Divider(),

          // Notifications Switch with padding, separator, and icon
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Obx(() {
              return SwitchListTile(
                title: Text('Notifications'),
                value: notificationController.isNotificationsEnabled.value,
                onChanged: (value) async {
                  await notificationController.toggleNotifications(value);

                  if (value) {
                    notificationController.showLocalNotification(
                      title: 'Notifications Enabled',
                      body: 'You will now receive notifications.',
                    );
                  }
                },
                secondary: Icon(Icons.notifications),
              );
            }),
          ),
          // Divider(),

          // // Test Notification Button
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 8.0),
          //   child: ElevatedButton(
          //     onPressed: () {
          //       notificationController.showLocalNotification(
          //         title: 'Test Notification',
          //         body: 'This is a test notification.',
          //       );
          //     },
          //     child: Text('Test Notification'),
          //   ),
          // ),
          const Divider(),

          // Log Out Option with padding, separator, and icon
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text('Log Out'),
              onTap: () async {
                bool confirm = await showConfirmDialog(
                  context,
                  message: 'Are you sure you want to log out?',
                );
                if (confirm) {
                  final GetStorage storage =
                      GetStorage(); // Access GetStorage instance
                  unsubscribeFromTopic(user.officeCode);
                  storage.remove('user'); // Clear user data
                  Get.offAllNamed('/login'); // Navigate to LoginPage
                  print("User logged out and redirected to LoginPage");
                }
              },
              leading: Icon(Icons.exit_to_app),
            ),
          ),

          Divider(),

          // Exit Option with padding, separator, and icon
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ListTile(
              title: Text('Exit'),
              onTap: () async {
                bool confirm = await showConfirmDialog(
                  context,
                  message: 'Are you sure you want to exit?',
                );
                if (confirm) {
                  print("Exiting the app");
                  SystemNavigator.pop(); // Exits the app
                }
              },
              leading: Icon(Icons.power_settings_new),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  void unsubscribeFromTopic(String topic) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    print("Unsubscribed from topic: $topic");
  }
}
