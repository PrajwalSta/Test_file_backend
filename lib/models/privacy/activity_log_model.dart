class ActivityLogModel {
  final String id;
  final String action;
  final String description;
  final String iconName;
  final DateTime createdAt;

  const ActivityLogModel({
    required this.id,
    required this.action,
    required this.description,
    required this.iconName,
    required this.createdAt,
  });

  factory ActivityLogModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ActivityLogModel(
      id: map['id'] as String,
      action:
          map['action'] as String? ??
              'Activity',
      description:
          map['description'] as String? ??
              '',
      iconName:
          map['icon_name'] as String? ??
              'history',
      createdAt: DateTime.parse(
        map['created_at'] as String,
      ).toLocal(),
    );
  }
}