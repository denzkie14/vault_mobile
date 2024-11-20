class ActionModel {
  int action_id;
  String display;
  String label;

  ActionModel({
    required this.action_id,
    required this.display,
    required this.label,
  });

  factory ActionModel.fromJson(Map<String, dynamic> json) {
    return ActionModel(
      action_id: json['id'],
      display: json['display'],
      label: json['action'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'action_id': action_id, 'display': display, 'label': label};
  }
}
