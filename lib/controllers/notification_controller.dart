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

import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vault_mobile/models/notification_model.dart';
import 'package:http/http.dart' as http;
import '../constants/values.dart';
import '../models/user_model.dart';

class NotificationController extends GetxController {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  var isNotificationsEnabled = false.obs;
  final GetStorage _storage = GetStorage();
  final String _notificationKey = 'isNotificationsEnabled';
  var notifications = <NotificationModel>[].obs;
  var isLoading = false.obs;
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

  final GetStorage storage = GetStorage(); // Instance of GetStorage
  // Fetch Document Logs by Document Number
  fetchNotifications() async {
    try {
      isLoading(true);
      User user = User.fromJson(storage.read('user'));

      final response = await http.get(
        Uri.parse('$apiUrl/notifications/'),
        headers: {'Authorization': 'Bearer  ${user.token}'},
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        List<NotificationModel> logs = (data['notifications'] as List)
            .map((log) => NotificationModel.fromJson(log))
            .toList();
        notifications.clear();
        notifications.addAll(logs);
        notifications.refresh();
      } else {
        print(jsonDecode(
            'fetchNotifications Error: code: ${response.statusCode}'));
        print(jsonDecode(response.body));
      }
    } catch (e) {
      print(jsonDecode('fetchNotifications Error: ${e}'));
    } finally {
      isLoading(false);
    }
  }

  String message = "";
  Future<bool> deleteNotification(String id) async {
    try {
      isLoading(true);
      User user = User.fromJson(storage.read('user'));

      final response = await http.delete(
        Uri.parse('$apiUrl/notification?id=$id'),
        headers: {'Authorization': 'Bearer  ${user.token}'},
      );

      if (response.statusCode == 200) {
        fetchNotifications();
        message = "Notification deleted successfully.";
        return true;
      } else {
        // print(jsonDecode(
        //     'fetchNotifications Error: code: ${response.statusCode}'));
        // print(jsonDecode(response.body));
        message = "Error Occured, please try again.";
        return false;
      }
    } catch (e) {
      message = "Error Occured, please try again.";
      // print(jsonDecode('fetchNotifications Error: ${e}'));
      return false;
    } finally {
      isLoading(false);
    }
  }
}
