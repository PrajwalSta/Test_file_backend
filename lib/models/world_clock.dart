/// Model representing a world clock location
class WorldClock {
  final String city;
  final String country;
  final String flag;
  final String time;
  final String period;
  final bool isSelected;

  const WorldClock({
    required this.city,
    required this.country,
    required this.flag,
    required this.time,
    required this.period,
    this.isSelected = false,
  });
}