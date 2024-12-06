import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/notification_controller.dart';
import '../../widgets/confirm_dialog.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final _notificationController = Get.put(NotificationController());

  final List<Map<String, String>> notifications = [
    {
      "title": "New Update Available",
      "description": "Version 1.2.0 is now available for download.",
      "timestamp": "2 hours ago"
    },
    {
      "title": "Maintenance Scheduled",
      "description": "System maintenance is scheduled for tomorrow at 2 AM.",
      "timestamp": "1 day ago"
    },
    {
      "title": "Welcome to the App",
      "description": "Thank you for joining our platform!",
      "timestamp": "3 days ago"
    },
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationController.fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _notificationController.fetchNotifications();
              },
              icon: const Icon(Icons.refresh))
        ],
        title: const Text("Notifications"),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text(
                "No notifications yet!",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Obx(() {
              return _notificationController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _notificationController.notifications.length,
                      itemBuilder: (context, index) {
                        final notification =
                            _notificationController.notifications[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: ListTile(
                            title: Text(notification.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text(notification.description),
                                const SizedBox(height: 5),
                                Text(
                                  timeAgo(notification.timestamp),
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            leading: Icon(
                              Icons.notifications,
                              color: Theme.of(context).primaryColor,
                            ),
                            onLongPress: () async {
                              bool confirm = await showConfirmDialog(
                                context,
                                title: 'Remove Notification',
                                message:
                                    'Are you sure you want to delete the selected notification?',
                              );
                              if (confirm) {
                                _notificationController.deleteNotification(
                                    _notificationController
                                        .notifications[index].id);
                              }
                            },
                            onTap: () {
                              // Handle tap on notification
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(notification.title),
                                  content: Text(notification.description),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Close"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
            }),
    );
  }
}

String timeAgo(DateTime timestamp) {
  final Duration difference = DateTime.now().difference(timestamp);

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes == 1) {
    return '1 minute ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minutes ago';
  } else if (difference.inHours == 1) {
    return '1 hour ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} hours ago';
  } else if (difference.inDays == 1) {
    return '1 day ago';
  } else {
    return '${difference.inDays} days ago';
  }
}
