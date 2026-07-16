class SleepSettingModel {
  final String sleepTime;
  final String wakeTime;
  final bool enabled;

  const SleepSettingModel({
    required this.sleepTime,
    required this.wakeTime,
    required this.enabled,
  });

  factory SleepSettingModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return SleepSettingModel(
      sleepTime:
          map['sleep_time']?.toString() ??
              '22:00:00',
      wakeTime:
          map['wake_time']?.toString() ??
              '07:00:00',
      enabled:
          map['enabled'] == true,
    );
  }

  Map<String, dynamic> toMap({
    required String userId,
  }) {
    return {
      'user_id': userId,
      'sleep_time': sleepTime,
      'wake_time': wakeTime,
      'enabled': enabled,
      'updated_at':
          DateTime.now().toIso8601String(),
    };
  }

  SleepSettingModel copyWith({
    String? sleepTime,
    String? wakeTime,
    bool? enabled,
  }) {
    return SleepSettingModel(
      sleepTime:
          sleepTime ?? this.sleepTime,
      wakeTime:
          wakeTime ?? this.wakeTime,
      enabled:
          enabled ?? this.enabled,
    );
  }
}