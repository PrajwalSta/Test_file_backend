class DailyFocusModel {
  final String day;
  final double hours;
  final bool isHighlighted;

  const DailyFocusModel({
    required this.day,
    required this.hours,
    this.isHighlighted = false,
  });
}