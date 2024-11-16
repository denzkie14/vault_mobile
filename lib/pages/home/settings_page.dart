import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/theme_controller.dart';
import '../../controllers/notification_controller.dart' as notify;
import '../../widgets/confirm_dialog.dart'; // Import NotificationController

class SettingsPage extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final notify.NotificationController notificationController =
      Get.put(notify.NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          // Dark Mode Switch with padding, separator, and icon
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Obx(() {
              return SwitchListTile(
                title: Text('Dark Mode'),
                value: themeController.isDarkMode.value,
                onChanged: (value) => themeController.toggleTheme(),
                secondary: Icon(Icons.brightness_6), // Icon for Dark Mode
              );
            }),
          ),
          Divider(),

          // Notifications Switch with padding, separator, and icon
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Obx(() {
              return SwitchListTile(
                title: Text('Notifications'),
                value: notificationController.isNotificationsEnabled.value,
                onChanged: (value) {
                  notificationController
                      .toggleNotifications(value); // Toggle notifications
                },
                secondary: Icon(Icons.notifications), // Icon for Notifications
              );
            }),
          ),
          Divider(),

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
                  // Handle log out action
                  print("Logged out");
                }
              },
              leading: Icon(Icons.exit_to_app), // Icon for Log Out
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
                  // Handle exit action, such as quitting the app
                  print("Exiting the app");
                }
              },
              leading: Icon(Icons.power_settings_new), // Icon for Exit
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
