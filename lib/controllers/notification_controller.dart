import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  var isNotificationsEnabled =
      false.obs; // RxBool to observe notification toggle
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'notification_icon'); // Use your icon name here

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: IOSInitializationSettings(), // Uncomment if you want iOS support
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Toggle notification state and show notification if enabled
  void toggleNotifications(bool isEnabled) {
    isNotificationsEnabled.value = isEnabled;
    if (isEnabled) {
      showNotification(); // Show the notification when the switch is turned on
    }
  }

  // Show a notification
  Future<void> showNotification() async {
    debugPrint('Show notification!');
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id', // Use your own channel ID
      'your_channel_name', // Channel name
      channelDescription: 'Description of your notification channel',
      importance: Importance.high,
      priority: Priority.high,
      icon:
          'notification_icon', // Ensure this icon exists in your drawable folder
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      // iOS: IOSNotificationDetails(), // Uncomment if supporting iOS
    );

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      'Notifications Enabled', // Title
      'You will now receive notifications.', // Body
      notificationDetails,
      payload: 'Notification Payload', // Optional: Custom data
    );
  }
}
