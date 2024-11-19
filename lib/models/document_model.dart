// import 'dart:math';

// class DocumentModel {
//   final String code;
//   final String title;
//   final String description;
//   final String type;
//   final String origin;
//   final String location;
//   final String status;

//   DocumentModel({
//     required this.code,
//     required this.title,
//     required this.description,
//     required this.type,
//     required this.origin,
//     required this.location,
//     required this.status,
//   });

//   // Factory constructor for creating a Document from a JSON object
//   factory DocumentModel.fromJson(Map<String, dynamic> json) {
//     return DocumentModel(
//       code: json['code'] as String,
//       title: json['title'] as String,
//       description: json['description'] as String,
//       type: json['type'] as String,
//       origin: json['origin'] as String,
//       location: json['location'] as String,
//       status: json['status'] as String,
//     );
//   }

//   // Method to convert a Document object into a JSON object
//   Map<String, dynamic> toJson() {
//     return {
//       'code': code,
//       'title': title,
//       'description': description,
//       'type': type,
//       'origin': origin,
//       'location': location,
//       'status': status,
//     };
//   }
// }

// // Generate a random Document object
// DocumentModel generateRandomDocument(int index) {
//   final random = Random();

//   // Predefined sets of data
//   final titles = ["Invoice", "Report", "Contract", "Order", "Memo"];
//   final descriptions = [
//     "Details about the document.",
//     "This is a sample description.",
//     "Related to project X.",
//     "Important contract details.",
//     "Summary of operations."
//   ];
//   final types = ["Type A", "Type B", "Type C"];
//   final origins = ["Office A", "Office B", "Client X", "Vendor Y"];
//   final locations = ["Location 1", "Location 2", "Warehouse", "HQ"];
//   final statuses = ["Pending", "Completed", "Outgoing", "Incoming"];

//   // Randomly select from predefined data
//   final title = titles[random.nextInt(titles.length)];
//   final description = descriptions[random.nextInt(descriptions.length)];
//   final type = types[random.nextInt(types.length)];
//   final origin = origins[random.nextInt(origins.length)];
//   final location = locations[random.nextInt(locations.length)];
//   final status = statuses[random.nextInt(statuses.length)];

//   // Generate a random Document object
//   return DocumentModel(
//     code: "DOC${index.toString().padLeft(4, '0')}",
//     title: "$title $index",
//     description: description,
//     type: type,
//     origin: origin,
//     location: location,
//     status: status,
//   );
// }

class DocumentModel {
  final String documentNumber;
  final String title;
  final String description;
  final String origin;
  final String originName;
  final String location;
  final String locationName;
  final String action;
  final String actionDisplay;
  final int documentTypeId;
  final int? securityId;
  final String? securityDescription;
  final int? version;
  final String documentType;
  final DateTime? dateCreated;
  final String createdBy;
  final DateTime? lastUpdated;
  final bool isDeleted;

  DocumentModel({
    required this.documentNumber,
    required this.title,
    required this.description,
    required this.origin,
    required this.originName,
    required this.location,
    required this.locationName,
    required this.action,
    required this.actionDisplay,
    required this.documentTypeId,
    this.securityId,
    this.securityDescription,
    this.version,
    required this.documentType,
    this.dateCreated,
    required this.createdBy,
    this.lastUpdated,
    required this.isDeleted,
  });

  // Factory method to create a DocumentModel from JSON
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      documentNumber: json['document_number'],
      title: json['title'],
      description: json['description'],
      origin: json['origin'],
      originName: json['origin_name'],
      location: json['location'],
      locationName: json['location_name'],
      action: json['action'],
      actionDisplay: json['action_display'],
      documentTypeId: json['document_type_id'],
      securityId: json['security_id'],
      securityDescription: json['security_description'],
      version: json['version'],
      documentType: json['document_type'],
      dateCreated: json['date_created'] != null
          ? DateTime.parse(json['date_created'])
          : null,
      createdBy: json['created_by'],
      lastUpdated: json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : null,
      isDeleted: json['is_deleted'],
    );
  }

  // Method to convert DocumentModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'document_number': documentNumber,
      'title': title,
      'description': description,
      'origin': origin,
      'origin_name': originName,
      'location': location,
      'location_name': locationName,
      'action': action,
      'action_display': actionDisplay,
      'document_type_id': documentTypeId,
      'security_id': securityId,
      'security_description': securityDescription,
      'version': version,
      'document_type': documentType,
      'date_created': dateCreated?.toIso8601String(),
      'created_by': createdBy,
      'last_updated': lastUpdated?.toIso8601String(),
      'is_deleted': isDeleted,
    };
  }
}
