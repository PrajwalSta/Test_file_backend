class ProfileModel {
  final String id;
  final String fullName;
  final String bio;
  final String? avatarUrl;
  final String membership;
  final int level;

  // Statistics
  final int streak;
  final int completedTasks;
  final int focusMinutes;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.bio,
    this.avatarUrl,
    required this.membership,
    required this.level,
    required this.streak,
    required this.completedTasks,
    required this.focusMinutes,
  });

  factory ProfileModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProfileModel(
      id:
          map['id']?.toString() ?? '',
      fullName:
          map['full_name']
                  ?.toString() ??
              '',
      bio:
          map['bio']?.toString() ?? '',
      avatarUrl:
          map['avatar_url']
              ?.toString(),
      membership:
          map['membership']
                  ?.toString() ??
              'Free',
      level:
          (map['level'] as num?)
                  ?.toInt() ??
              1,
      streak:
          (map['streak'] as num?)
                  ?.toInt() ??
              0,
      completedTasks:
          (map['completed_tasks']
                      as num?)
                  ?.toInt() ??
              0,
      focusMinutes:
          (map['focus_minutes']
                      as num?)
                  ?.toInt() ??
              0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id':
          id,
      'full_name':
          fullName,
      'bio':
          bio,
      'avatar_url':
          avatarUrl,
      'membership':
          membership,
      'level':
          level,
      'streak':
          streak,
      'completed_tasks':
          completedTasks,
      'focus_minutes':
          focusMinutes,
    };
  }
}