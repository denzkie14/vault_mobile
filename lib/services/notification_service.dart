import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(
            'notification_icon'); // Use the icon you want

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: IOSInitializationSettings(),
    );

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //   onSelectNotification: onSelectNotification,
    );
  }

  // Handle notification taps (when the user taps the notification)
  static Future<void> onSelectNotification(String? payload) async {
    // Handle the notification tap, for example, navigating to another screen
    debugPrint('Notification tapped: $payload');
    // Add your navigation logic here if needed
  }

  // Show a simple notification
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      '031490', // ID of the notification channel
      'vault_channel', // Name of the channel
      channelDescription: 'Description of your notification channel',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'notification_icon', // Custom icon used here
    );

    // const IOSNotificationDetails iosDetails = IOSNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      // iOS: iosDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload:
          'Custom Payload', // Optional: Custom data that can be passed along
    );
  }
}
