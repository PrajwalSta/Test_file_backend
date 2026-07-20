import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class TimezoneService {
  static tz.TZDateTime getTime(
    String timezoneName,
  ) {
    final tz.Location location =
        tz.getLocation(timezoneName);

    return tz.TZDateTime.now(location);
  }

  static String formattedTime(
    String timezoneName,
  ) {
    final time = getTime(timezoneName);

    return DateFormat('HH:mm').format(time);
  }

  static String period(
    String timezoneName,
  ) {
    final hour =
        getTime(timezoneName).hour;

    if (hour >= 5 && hour < 12) {
      return "Morning ☀️";
    }

    if (hour >= 12 && hour < 17) {
      return "Afternoon 🌤️";
    }

    if (hour >= 17 && hour < 20) {
      return "Evening 🌇";
    }

    return "Night 🌙";
  }
}