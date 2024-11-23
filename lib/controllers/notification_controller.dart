// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';

// class NotificationController extends GetxController {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   var isNotificationsEnabled = false.obs;

//   NotificationController() {
//     _initializeNotifications();
//   }

//   void _initializeNotifications() async {
//     // Android-specific initialization
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     // Define initialization settings for the plugin
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid);

//     // Initialize the plugin
//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> requestNotificationPermissions() async {
//     if (await Permission.notification.isDenied) {
//       await Permission.notification.request();
//     }
//   }

//   Future<void> toggleNotifications(bool value) async {
//     if (value) {
//       await requestNotificationPermissions();
//     }
//     isNotificationsEnabled.value = value;
//   }

//   Future<void> showLocalNotification({
//     required String title,
//     required String body,
//   }) async {
//     try {
//       const AndroidNotificationDetails androidPlatformChannelSpecifics =
//           AndroidNotificationDetails(
//         'your_channel_id', // Replace with your channel ID
//         'your_channel_name', // Replace with your channel name
//         channelDescription: 'This channel is used for notifications.',
//         importance: Importance.high,
//         priority: Priority.high,
//       );

//       const NotificationDetails platformChannelSpecifics =
//           NotificationDetails(android: androidPlatformChannelSpecifics);

//       await flutterLocalNotificationsPlugin.show(
//         0, // Notification ID
//         title,
//         body,
//         platformChannelSpecifics,
//       );
//     } catch (e) {
//       print('Error showing notification: $e');
//     }
//   }
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var isNotificationsEnabled = false.obs;
  final GetStorage _storage = GetStorage();
  final String _notificationKey = 'isNotificationsEnabled';

  NotificationController() {
    _initializeNotifications();
    _loadNotificationSettings();
  }

  void _initializeNotifications() async {
    // Android-specific initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Define initialization settings for the plugin
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _loadNotificationSettings() {
    // Load the saved notification setting from GetStorage
    isNotificationsEnabled.value = _storage.read(_notificationKey) ?? false;
  }

  Future<void> _saveNotificationSettings() async {
    // Save the notification state in GetStorage
    await _storage.write(_notificationKey, isNotificationsEnabled.value);
  }

  Future<void> requestNotificationPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> toggleNotifications(bool value) async {
    if (value) {
      await requestNotificationPermissions();
    }
    isNotificationsEnabled.value = value;
    _saveNotificationSettings();
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
  }) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id', // Replace with your channel ID
        'your_channel_name', // Replace with your channel name
        channelDescription: 'This channel is used for notifications.',
        importance: Importance.high,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        title,
        body,
        platformChannelSpecifics,
      );
    } catch (e) {
      print('Error showing notification: $e');
    }
  }
}
