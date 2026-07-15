import '../models/category_stat_model.dart';
import '../models/daily_focus_model.dart';
import '../screens/theme/app_colors.dart';

class StatisticsData {
  StatisticsData._();

  static const List<DailyFocusModel> dailyFocus = [
    DailyFocusModel(day: 'Mon', hours: 5.2),
    DailyFocusModel(day: 'Tue', hours: 5.8),
    DailyFocusModel(day: 'Wed', hours: 4.7),
    DailyFocusModel(
      day: 'Thu',
      hours: 7.5,
      isHighlighted: true,
    ),
    DailyFocusModel(day: 'Fri', hours: 6.1),
    DailyFocusModel(day: 'Sat', hours: 3.9),
    DailyFocusModel(day: 'Sun', hours: 3.2),
  ];

  static const List<CategoryStatModel> categories = [
    CategoryStatModel(
      title: 'Work',
      percentage: 42,
      color: AppColors.primary,
    ),
    CategoryStatModel(
      title: 'Study',
      percentage: 28,
      color: AppColors.cyan,
    ),
    CategoryStatModel(
      title: 'Health',
      percentage: 18,
      color: AppColors.orange,
    ),
    CategoryStatModel(
      title: 'Personal',
      percentage: 12,
      color: AppColors.yellow,
    ),
  ];

  static const List<double> monthlyFocus = [
    5.3,
    6.0,
    6.2,
    5.4,
    4.1,
    4.6,
    6.3,
  ];
}