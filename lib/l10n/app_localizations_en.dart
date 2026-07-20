// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Focus Glow';

  @override
  String get home => 'Home';

  @override
  String get schedule => 'Schedule';

  @override
  String get statistics => 'Statistics';

  @override
  String get clocks => 'Clocks';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get themeColor => 'Theme Color';

  @override
  String get language => 'Language';

  @override
  String get profile => 'Profile';

  @override
  String get privacyAndSecurity => 'Privacy and Security';

  @override
  String get focusAndDnd => 'Focus and Do Not Disturb';

  @override
  String get sleepMode => 'Sleep Mode';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get add => 'Add';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get english => 'English';

  @override
  String get nepali => 'Nepali';

  @override
  String get hindi => 'Hindi';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageChanged => 'Language changed successfully';

  @override
  String get goodMorning => 'Good Morning';

  @override
  String get goodAfternoon => 'Good Afternoon';

  @override
  String get goodEvening => 'Good Evening';

  @override
  String get project => 'Project';

  @override
  String get todaysProgress => 'Today\'s Progress';

  @override
  String tasksCompleted(int completed, int total) {
    return '$completed of $total tasks completed';
  }

  @override
  String get focusTime => 'Focus Time';

  @override
  String get tasksDone => 'Tasks Done';

  @override
  String get todaysSchedule => 'Today\'s Schedule';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get untitled => 'Untitled';

  @override
  String get studyMode => 'Study Mode';

  @override
  String get off => 'Off';

  @override
  String get sleeping => 'Sleeping';

  @override
  String get pleaseLoginToViewSchedules => 'Please log in to view schedules.';

  @override
  String get unableToLoadSchedules => 'Unable to load schedules.';

  @override
  String get scheduleIdMissing => 'Schedule database ID is missing';

  @override
  String get loginBeforeUpdating => 'Please log in before updating.';

  @override
  String get loginBeforeDeleting => 'Please log in before deleting.';

  @override
  String databaseError(String message) {
    return 'Database error: $message';
  }

  @override
  String scheduleAddedSuccessfully(String title) {
    return '$title added successfully';
  }

  @override
  String taskCompleted(String title) {
    return '$title completed';
  }

  @override
  String taskMarkedIncomplete(String title) {
    return '$title marked incomplete';
  }

  @override
  String updateFailed(String message) {
    return 'Update failed: $message';
  }

  @override
  String deleteFailed(String message) {
    return 'Delete failed: $message';
  }

  @override
  String get unableToUpdateSchedule => 'Unable to update schedule.';

  @override
  String get unableToDeleteSchedule => 'Unable to delete schedule.';

  @override
  String scheduleDeletedSuccessfully(String title) {
    return '$title deleted successfully';
  }

  @override
  String scheduleSelected(String title) {
    return '$title selected';
  }

  @override
  String get taskCompletedNotificationTitle => '🎉 Task Completed';

  @override
  String taskCompletedNotificationBody(String title) {
    return '$title has been completed successfully.';
  }

  @override
  String get scheduleCancelledNotificationTitle => 'Schedule Cancelled';

  @override
  String scheduleCancelledNotificationBody(String title) {
    return '$title has been deleted from your schedule.';
  }
}
