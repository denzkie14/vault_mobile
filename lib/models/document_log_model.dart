class DocumentLog {
  final int actionId;
  final String actionLabel;
  final DateTime dateActed;
  final String actedBy;
  final String actorOffice;
  final String actorOfficeCode;
  final String deliveredBy;
  final bool copyOnly;
  DocumentLog({
    required this.actionId,
    required this.actionLabel,
    required this.dateActed,
    required this.actedBy,
    required this.actorOffice,
    required this.actorOfficeCode,
    this.deliveredBy = "",
    required this.copyOnly,
  });

  // Factory method to create a DocumentLog instance from JSON
  factory DocumentLog.fromJson(Map<String, dynamic> json) {
    return DocumentLog(
      actionId: json['action_id'],
      actionLabel: json['action_label'],
      dateActed: DateTime.parse(json['date_acted']),
      actedBy: json['acted_by'],
      actorOffice: json['actor_office'],
      actorOfficeCode: json['actor_office_code'],
      deliveredBy: json['delivered_by'] ?? "",
      copyOnly: json['copy_only'],
    );
  }

  // Method to convert DocumentLog instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'action_id': actionId,
      'action_label': actionLabel,
      'date_acted': dateActed.toIso8601String(),
      'acted_by': actedBy,
      'actor_office': actorOffice,
      'actor_office_code': actorOfficeCode,
      'delivered_by': deliveredBy,
      'copy_only': copyOnly,
    };
  }
}
