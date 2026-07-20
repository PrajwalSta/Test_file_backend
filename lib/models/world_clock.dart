/// Model representing a saved world clock location.
class WorldClock {
  final String? id;
  final String userId;

  final String city;
  final String country;
  final String flag;

  // Example: Australia/Sydney
  final String timezoneName;

  final int sortOrder;
  final bool isSelected;

  const WorldClock({
    this.id,
    required this.userId,
    required this.city,
    required this.country,
    required this.flag,
    required this.timezoneName,
    this.sortOrder = 0,
    this.isSelected = false,
  });

  /// Convert Supabase database data into WorldClock.
  factory WorldClock.fromMap(
    Map<String, dynamic> map,
  ) {
    return WorldClock(
      id: map['id'] as String?,
      userId: map['user_id'] as String? ?? '',
      city: map['city'] as String? ?? '',
      country: map['country'] as String? ?? '',
      flag: map['flag'] as String? ?? '',
      timezoneName:
          map['timezone_name'] as String? ?? 'UTC',
      sortOrder: map['sort_order'] as int? ?? 0,
      isSelected:
          map['is_selected'] as bool? ?? false,
    );
  }

  /// Convert WorldClock into data for Supabase.
  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'city': city,
      'country': country,
      'flag': flag,
      'timezone_name': timezoneName,
      'sort_order': sortOrder,
      'is_selected': isSelected,
    };
  }

  /// Create an updated copy of this clock.
  WorldClock copyWith({
    String? id,
    String? userId,
    String? city,
    String? country,
    String? flag,
    String? timezoneName,
    int? sortOrder,
    bool? isSelected,
  }) {
    return WorldClock(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      city: city ?? this.city,
      country: country ?? this.country,
      flag: flag ?? this.flag,
      timezoneName:
          timezoneName ?? this.timezoneName,
      sortOrder: sortOrder ?? this.sortOrder,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}