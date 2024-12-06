class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isRead;
  final String document_code;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    this.isRead = false,
    required this.document_code,
  });

  /// Factory constructor to create a NotificationModel from JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['notification_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isRead: json['is_read'] as bool? ?? false,
      document_code: json['document_code'],
    );
  }

  /// Convert a NotificationModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'notification_id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }
}
