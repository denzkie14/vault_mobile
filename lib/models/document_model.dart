import 'dart:math';

class DocumentModel {
  final String code;
  final String title;
  final String description;
  final String type;
  final String origin;
  final String location;
  final String status;

  DocumentModel({
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.origin,
    required this.location,
    required this.status,
  });

  // Factory constructor for creating a Document from a JSON object
  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      code: json['code'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      origin: json['origin'] as String,
      location: json['location'] as String,
      status: json['status'] as String,
    );
  }

  // Method to convert a Document object into a JSON object
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'description': description,
      'type': type,
      'origin': origin,
      'location': location,
      'status': status,
    };
  }
}

// Generate a random Document object
DocumentModel generateRandomDocument(int index) {
  final random = Random();

  // Predefined sets of data
  final titles = ["Invoice", "Report", "Contract", "Order", "Memo"];
  final descriptions = [
    "Details about the document.",
    "This is a sample description.",
    "Related to project X.",
    "Important contract details.",
    "Summary of operations."
  ];
  final types = ["Type A", "Type B", "Type C"];
  final origins = ["Office A", "Office B", "Client X", "Vendor Y"];
  final locations = ["Location 1", "Location 2", "Warehouse", "HQ"];
  final statuses = ["Pending", "Completed", "Outgoing", "Incoming"];

  // Randomly select from predefined data
  final title = titles[random.nextInt(titles.length)];
  final description = descriptions[random.nextInt(descriptions.length)];
  final type = types[random.nextInt(types.length)];
  final origin = origins[random.nextInt(origins.length)];
  final location = locations[random.nextInt(locations.length)];
  final status = statuses[random.nextInt(statuses.length)];

  // Generate a random Document object
  return DocumentModel(
    code: "DOC${index.toString().padLeft(4, '0')}",
    title: "$title $index",
    description: description,
    type: type,
    origin: origin,
    location: location,
    status: status,
  );
}
