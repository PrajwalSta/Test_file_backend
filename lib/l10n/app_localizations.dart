import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ne.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('ne')
  ];

  /// Application name
  ///
  /// In en, this message translates to:
  /// **'Focus Glow'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @clocks.
  ///
  /// In en, this message translates to:
  /// **'Clocks'**
  String get clocks;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @themeColor.
  ///
  /// In en, this message translates to:
  /// **'Theme Color'**
  String get themeColor;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacyAndSecurity;

  /// No description provided for @focusAndDnd.
  ///
  /// In en, this message translates to:
  /// **'Focus & Do Not Disturb'**
  String get focusAndDnd;

  /// No description provided for @sleepMode.
  ///
  /// In en, this message translates to:
  /// **'Sleep Mode'**
  String get sleepMode;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @nepali.
  ///
  /// In en, this message translates to:
  /// **'Nepali'**
  String get nepali;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get hindi;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed successfully'**
  String get languageChanged;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @todaysProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todaysProgress;

  /// No description provided for @todaysSchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaysSchedule;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrow;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// No description provided for @totalFocusTime.
  ///
  /// In en, this message translates to:
  /// **'Total Focus Time'**
  String get totalFocusTime;

  /// No description provided for @focusTime.
  ///
  /// In en, this message translates to:
  /// **'Focus Time'**
  String get focusTime;

  /// No description provided for @focusHours.
  ///
  /// In en, this message translates to:
  /// **'Focus Hours'**
  String get focusHours;

  /// No description provided for @tasksDone.
  ///
  /// In en, this message translates to:
  /// **'Tasks Done'**
  String get tasksDone;

  /// No description provided for @totalTasks.
  ///
  /// In en, this message translates to:
  /// **'Total Tasks'**
  String get totalTasks;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @completedTasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed Tasks'**
  String get completedTasksTitle;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// No description provided for @dailyFocusHours.
  ///
  /// In en, this message translates to:
  /// **'Daily Focus Hours'**
  String get dailyFocusHours;

  /// No description provided for @byCategory.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get byCategory;

  /// No description provided for @monthlyFocus.
  ///
  /// In en, this message translates to:
  /// **'Monthly Focus'**
  String get monthlyFocus;

  /// No description provided for @productivityInsights.
  ///
  /// In en, this message translates to:
  /// **'Your productivity insights'**
  String get productivityInsights;

  /// No description provided for @profileSection.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileSection;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @focusModesSection.
  ///
  /// In en, this message translates to:
  /// **'Focus Modes'**
  String get focusModesSection;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, photo, bio'**
  String get profileSubtitle;

  /// No description provided for @privacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Password, 2FA, biometrics'**
  String get privacySubtitle;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeOn.
  ///
  /// In en, this message translates to:
  /// **'On — dark interface'**
  String get darkModeOn;

  /// No description provided for @darkModeOff.
  ///
  /// In en, this message translates to:
  /// **'Off — light interface'**
  String get darkModeOff;

  /// No description provided for @notificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Push, email, reminders'**
  String get notificationsSubtitle;

  /// No description provided for @themeColorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize app color scheme'**
  String get themeColorSubtitle;

  /// No description provided for @focusMode.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusMode;

  /// No description provided for @focusModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Blocked apps, break intervals'**
  String get focusModeSubtitle;

  /// No description provided for @sleepModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bedtime and wake-up schedule'**
  String get sleepModeSubtitle;

  /// No description provided for @doNotDisturb.
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb'**
  String get doNotDisturb;

  /// No description provided for @loadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Loading settings...'**
  String get loadingSettings;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @am.
  ///
  /// In en, this message translates to:
  /// **'AM'**
  String get am;

  /// No description provided for @pm.
  ///
  /// In en, this message translates to:
  /// **'PM'**
  String get pm;

  /// No description provided for @dndEnabled.
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb enabled'**
  String get dndEnabled;

  /// No description provided for @dndDisabled.
  ///
  /// In en, this message translates to:
  /// **'Do Not Disturb disabled'**
  String get dndDisabled;

  /// No description provided for @tasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} tasks completed'**
  String tasksCompleted(int completed, int total);

  /// No description provided for @pleaseLoginToViewStatistics.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view statistics.'**
  String get pleaseLoginToViewStatistics;

  /// No description provided for @unableToLoadStatistics.
  ///
  /// In en, this message translates to:
  /// **'Unable to load statistics.'**
  String get unableToLoadStatistics;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @studyMode.
  ///
  /// In en, this message translates to:
  /// **'Study Mode'**
  String get studyMode;

  /// No description provided for @workMode.
  ///
  /// In en, this message translates to:
  /// **'Work Mode'**
  String get workMode;

  /// No description provided for @sleeping.
  ///
  /// In en, this message translates to:
  /// **'Sleeping'**
  String get sleeping;

  /// No description provided for @loginToViewSchedules.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view schedules.'**
  String get loginToViewSchedules;

  /// No description provided for @pleaseLoginToViewSchedules.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view schedules.'**
  String get pleaseLoginToViewSchedules;

  /// No description provided for @unableToLoadSchedules.
  ///
  /// In en, this message translates to:
  /// **'Unable to load schedules.'**
  String get unableToLoadSchedules;

  /// No description provided for @databaseError.
  ///
  /// In en, this message translates to:
  /// **'Database error: {message}'**
  String databaseError(Object message);

  /// No description provided for @scheduleAdded.
  ///
  /// In en, this message translates to:
  /// **'Schedule Added'**
  String get scheduleAdded;

  /// No description provided for @scheduleAddedBody.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" was added to your schedule.'**
  String scheduleAddedBody(Object title);

  /// No description provided for @scheduleAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Schedule added successfully: {title}'**
  String scheduleAddedSuccessfully(String title);

  /// No description provided for @scheduleIdMissing.
  ///
  /// In en, this message translates to:
  /// **'Schedule database ID is missing.'**
  String get scheduleIdMissing;

  /// No description provided for @loginBeforeUpdating.
  ///
  /// In en, this message translates to:
  /// **'Please log in before updating.'**
  String get loginBeforeUpdating;

  /// No description provided for @loginBeforeUpdatingSchedule.
  ///
  /// In en, this message translates to:
  /// **'Please log in before updating a schedule.'**
  String get loginBeforeUpdatingSchedule;

  /// No description provided for @loginBeforeDeleting.
  ///
  /// In en, this message translates to:
  /// **'Please log in before deleting.'**
  String get loginBeforeDeleting;

  /// No description provided for @loginBeforeDeletingSchedule.
  ///
  /// In en, this message translates to:
  /// **'Please log in before deleting a schedule.'**
  String get loginBeforeDeletingSchedule;

  /// No description provided for @taskCompleted.
  ///
  /// In en, this message translates to:
  /// **'{title} completed'**
  String taskCompleted(String title);

  /// No description provided for @taskReopened.
  ///
  /// In en, this message translates to:
  /// **'Task Reopened'**
  String get taskReopened;

  /// No description provided for @taskReopenedBody.
  ///
  /// In en, this message translates to:
  /// **'\"{title}\" was marked as incomplete.'**
  String taskReopenedBody(String title);

  /// No description provided for @taskMarkedCompleted.
  ///
  /// In en, this message translates to:
  /// **'Task \"{title}\" marked as completed. Done: {count}'**
  String taskMarkedCompleted(String title, int count);

  /// No description provided for @taskMarkedIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Task \"{title}\" marked as incomplete. Done: {count}'**
  String taskMarkedIncomplete(String title, int count);

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {message}'**
  String updateFailed(String message);

  /// No description provided for @unableToUpdateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Unable to update schedule: {message}'**
  String unableToUpdateSchedule(String message);

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {message}'**
  String deleteFailed(String message);

  /// No description provided for @unableToDeleteSchedule.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete schedule: {message}'**
  String unableToDeleteSchedule(String message);

  /// No description provided for @scheduleDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Schedule deleted successfully: {title}'**
  String scheduleDeletedSuccessfully(String title);

  /// No description provided for @scheduleSelected.
  ///
  /// In en, this message translates to:
  /// **'Schedule selected: {title}'**
  String scheduleSelected(String title);

  /// No description provided for @taskCompletedNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'🎉 Task Completed'**
  String get taskCompletedNotificationTitle;

  /// No description provided for @taskCompletedNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'{title} has been completed successfully.'**
  String taskCompletedNotificationBody(String title);

  /// No description provided for @scheduleCancelledNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule Cancelled'**
  String get scheduleCancelledNotificationTitle;

  /// No description provided for @scheduleCancelledNotificationBody.
  ///
  /// In en, this message translates to:
  /// **'{title} has been deleted from your schedule.'**
  String scheduleCancelledNotificationBody(String title);

  /// No description provided for @unableToLoadDndSettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to load Do Not Disturb settings: {message}'**
  String unableToLoadDndSettings(String message);

  /// No description provided for @unableToUpdateDnd.
  ///
  /// In en, this message translates to:
  /// **'Unable to update Do Not Disturb: {message}'**
  String unableToUpdateDnd(String message);

  /// No description provided for @sleepModeSettingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Sleep Mode settings updated'**
  String get sleepModeSettingsUpdated;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmation;

  /// No description provided for @signOutFailed.
  ///
  /// In en, this message translates to:
  /// **'Sign out failed: {message}'**
  String signOutFailed(String message);

  /// No description provided for @pageTitle.
  ///
  /// In en, this message translates to:
  /// **'{title} Page'**
  String pageTitle(String title);

  /// No description provided for @addSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add Schedule'**
  String get addSchedule;

  /// No description provided for @orAddManually.
  ///
  /// In en, this message translates to:
  /// **'OR ADD MANUALLY'**
  String get orAddManually;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @startTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get startTime;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (min)'**
  String get durationMinutes;

  /// No description provided for @csvTemplateReady.
  ///
  /// In en, this message translates to:
  /// **'CSV template is ready.'**
  String get csvTemplateReady;

  /// No description provided for @unableToPrepareTemplate.
  ///
  /// In en, this message translates to:
  /// **'Unable to prepare template: {message}'**
  String unableToPrepareTemplate(String message);

  /// No description provided for @loginBeforeImportingSchedules.
  ///
  /// In en, this message translates to:
  /// **'Please log in before importing schedules.'**
  String get loginBeforeImportingSchedules;

  /// No description provided for @noSchedulesImported.
  ///
  /// In en, this message translates to:
  /// **'No schedules were imported.'**
  String get noSchedulesImported;

  /// No description provided for @unableToImportCsv.
  ///
  /// In en, this message translates to:
  /// **'Unable to import CSV file: {message}'**
  String unableToImportCsv(String message);

  /// No description provided for @importSchedulesQuestion.
  ///
  /// In en, this message translates to:
  /// **'Import schedules?'**
  String get importSchedulesQuestion;

  /// No description provided for @importProblems.
  ///
  /// In en, this message translates to:
  /// **'Import problems'**
  String get importProblems;

  /// No description provided for @noValidSchedulesFound.
  ///
  /// In en, this message translates to:
  /// **'No valid schedules were found.'**
  String get noValidSchedulesFound;

  /// No description provided for @validSchedulesFound.
  ///
  /// In en, this message translates to:
  /// **'{count} valid schedules found.'**
  String validSchedulesFound(int count);

  /// No description provided for @rowsWillBeSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count} rows will be skipped.'**
  String rowsWillBeSkipped(int count);

  /// No description provided for @minutesShort.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String minutesShort(int count);

  /// No description provided for @andMore.
  ///
  /// In en, this message translates to:
  /// **'And {count} more.'**
  String andMore(int count);

  /// No description provided for @importCount.
  ///
  /// In en, this message translates to:
  /// **'Import {count}'**
  String importCount(int count);

  /// No description provided for @unknownCategory.
  ///
  /// In en, this message translates to:
  /// **'Unknown category.'**
  String get unknownCategory;

  /// No description provided for @unknownCategoryAtRow.
  ///
  /// In en, this message translates to:
  /// **'Row {row}: Unknown category \"{category}\".'**
  String unknownCategoryAtRow(int row, String category);

  /// No description provided for @rowError.
  ///
  /// In en, this message translates to:
  /// **'Row {row}: {message}'**
  String rowError(int row, String message);

  /// No description provided for @schedulesImportedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'{count} schedules imported successfully.'**
  String schedulesImportedSuccessfully(int count);

  /// No description provided for @schedulesImportedWithSkipped.
  ///
  /// In en, this message translates to:
  /// **'{count} schedules imported successfully, {skipped} skipped.'**
  String schedulesImportedWithSkipped(int count, int skipped);

  /// No description provided for @enterScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a schedule title.'**
  String get enterScheduleTitle;

  /// No description provided for @enterValidDuration.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid duration.'**
  String get enterValidDuration;

  /// No description provided for @loginBeforeSavingSchedule.
  ///
  /// In en, this message translates to:
  /// **'Please log in before saving a schedule.'**
  String get loginBeforeSavingSchedule;

  /// No description provided for @selectFutureDateTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a future date and time.'**
  String get selectFutureDateTime;

  /// No description provided for @scheduleIdNotReturned.
  ///
  /// In en, this message translates to:
  /// **'No schedule ID was returned.'**
  String get scheduleIdNotReturned;

  /// No description provided for @unableToSaveSchedule.
  ///
  /// In en, this message translates to:
  /// **'Unable to save schedule: {message}'**
  String unableToSaveSchedule(String message);

  /// No description provided for @noSchedulesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No schedules available'**
  String get noSchedulesAvailable;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @personal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// No description provided for @social.
  ///
  /// In en, this message translates to:
  /// **'Social'**
  String get social;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @durationRequired.
  ///
  /// In en, this message translates to:
  /// **'Duration is required'**
  String get durationRequired;

  /// No description provided for @enterValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterValidNumber;

  /// No description provided for @minimumDuration.
  ///
  /// In en, this message translates to:
  /// **'Minimum duration is {minutes} minute'**
  String minimumDuration(int minutes);

  /// No description provided for @maximumDuration.
  ///
  /// In en, this message translates to:
  /// **'Maximum duration is {minutes} minutes'**
  String maximumDuration(int minutes);

  /// No description provided for @deleteSchedule.
  ///
  /// In en, this message translates to:
  /// **'Delete schedule'**
  String get deleteSchedule;

  /// No description provided for @deepWork.
  ///
  /// In en, this message translates to:
  /// **'Deep Work'**
  String get deepWork;

  /// No description provided for @readingMode.
  ///
  /// In en, this message translates to:
  /// **'Reading Mode'**
  String get readingMode;

  /// No description provided for @exerciseMode.
  ///
  /// In en, this message translates to:
  /// **'Exercise Mode'**
  String get exerciseMode;

  /// No description provided for @noFocusMode.
  ///
  /// In en, this message translates to:
  /// **'No Focus Mode'**
  String get noFocusMode;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'Notifications, {count} unread'**
  String notificationsUnread(int count);

  /// No description provided for @noSchedulesForToday.
  ///
  /// In en, this message translates to:
  /// **'No schedules for today'**
  String get noSchedulesForToday;

  /// No description provided for @pressAddToCreateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Press Add to create a schedule.'**
  String get pressAddToCreateSchedule;

  /// No description provided for @scheduleUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Schedule was not updated. Check the schedule RLS policy.'**
  String get scheduleUpdateFailed;

  /// No description provided for @scheduleDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Schedule was not deleted. Check the schedule RLS policy.'**
  String get scheduleDeleteFailed;

  /// No description provided for @importSchedule.
  ///
  /// In en, this message translates to:
  /// **'Import Schedule'**
  String get importSchedule;

  /// No description provided for @uploadCsvDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload a CSV file to add multiple schedules at once.'**
  String get uploadCsvDescription;

  /// No description provided for @selectedFile.
  ///
  /// In en, this message translates to:
  /// **'Selected: {fileName}'**
  String selectedFile(String fileName);

  /// No description provided for @preparingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Preparing template...'**
  String get preparingTemplate;

  /// No description provided for @downloadTemplate.
  ///
  /// In en, this message translates to:
  /// **'Download template'**
  String get downloadTemplate;

  /// No description provided for @uploadFile.
  ///
  /// In en, this message translates to:
  /// **'Upload File'**
  String get uploadFile;

  /// No description provided for @scheduleTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a schedule title'**
  String get scheduleTitleRequired;

  /// No description provided for @minimumTitleLength.
  ///
  /// In en, this message translates to:
  /// **'Title must contain at least {count} characters'**
  String minimumTitleLength(int count);

  /// No description provided for @scheduleTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Deep Work Session'**
  String get scheduleTitleHint;

  /// No description provided for @durationHint.
  ///
  /// In en, this message translates to:
  /// **'60'**
  String get durationHint;

  /// No description provided for @saveSchedule.
  ///
  /// In en, this message translates to:
  /// **'Save Schedule'**
  String get saveSchedule;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @noFocusDataYet.
  ///
  /// In en, this message translates to:
  /// **'No focus data yet'**
  String get noFocusDataYet;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get dec;

  /// No description provided for @taskDone.
  ///
  /// In en, this message translates to:
  /// **'Task done'**
  String get taskDone;

  /// No description provided for @tasksDonePlural.
  ///
  /// In en, this message translates to:
  /// **'Tasks done'**
  String get tasksDonePlural;

  /// No description provided for @hoursShort.
  ///
  /// In en, this message translates to:
  /// **'hr'**
  String get hoursShort;

  /// No description provided for @minutesAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutesAbbreviation;

  /// No description provided for @addWorldClock.
  ///
  /// In en, this message translates to:
  /// **'Add World Clock'**
  String get addWorldClock;

  /// No description provided for @worldClocks.
  ///
  /// In en, this message translates to:
  /// **'World Clocks'**
  String get worldClocks;

  /// No description provided for @searchCityCountryTimezone.
  ///
  /// In en, this message translates to:
  /// **'Search city, country or timezone'**
  String get searchCityCountryTimezone;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @noCityFound.
  ///
  /// In en, this message translates to:
  /// **'No city found'**
  String get noCityFound;

  /// No description provided for @tryAnotherCityCountryTimezone.
  ///
  /// In en, this message translates to:
  /// **'Try another city, country or timezone.'**
  String get tryAnotherCityCountryTimezone;

  /// No description provided for @isAlreadyAdded.
  ///
  /// In en, this message translates to:
  /// **'is already added'**
  String get isAlreadyAdded;

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'added'**
  String get added;

  /// No description provided for @removed.
  ///
  /// In en, this message translates to:
  /// **'removed'**
  String get removed;

  /// No description provided for @unableToLoadWorldClocks.
  ///
  /// In en, this message translates to:
  /// **'Unable to load world clocks'**
  String get unableToLoadWorldClocks;

  /// No description provided for @unableToAddClock.
  ///
  /// In en, this message translates to:
  /// **'Unable to add clock'**
  String get unableToAddClock;

  /// No description provided for @unableToRemoveClock.
  ///
  /// In en, this message translates to:
  /// **'Unable to remove clock'**
  String get unableToRemoveClock;

  /// No description provided for @thisClockCannotBeDeleted.
  ///
  /// In en, this message translates to:
  /// **'This clock cannot be deleted.'**
  String get thisClockCannotBeDeleted;

  /// No description provided for @deleteClock.
  ///
  /// In en, this message translates to:
  /// **'Delete clock?'**
  String get deleteClock;

  /// No description provided for @fromYourWorldClocks.
  ///
  /// In en, this message translates to:
  /// **'from your world clocks?'**
  String get fromYourWorldClocks;

  /// No description provided for @noWorldClocksAdded.
  ///
  /// In en, this message translates to:
  /// **'No world clocks added'**
  String get noWorldClocksAdded;

  /// No description provided for @tapPlusToAddCity.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to search and add a city.'**
  String get tapPlusToAddCity;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search city'**
  String get searchCity;

  /// No description provided for @unableToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to load profile'**
  String get unableToLoadProfile;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @profileDataUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Profile data is unavailable'**
  String get profileDataUnavailable;

  /// No description provided for @citySydney.
  ///
  /// In en, this message translates to:
  /// **'Sydney'**
  String get citySydney;

  /// No description provided for @cityMelbourne.
  ///
  /// In en, this message translates to:
  /// **'Melbourne'**
  String get cityMelbourne;

  /// No description provided for @cityBrisbane.
  ///
  /// In en, this message translates to:
  /// **'Brisbane'**
  String get cityBrisbane;

  /// No description provided for @cityPerth.
  ///
  /// In en, this message translates to:
  /// **'Perth'**
  String get cityPerth;

  /// No description provided for @cityAdelaide.
  ///
  /// In en, this message translates to:
  /// **'Adelaide'**
  String get cityAdelaide;

  /// No description provided for @cityDarwin.
  ///
  /// In en, this message translates to:
  /// **'Darwin'**
  String get cityDarwin;

  /// No description provided for @cityHobart.
  ///
  /// In en, this message translates to:
  /// **'Hobart'**
  String get cityHobart;

  /// No description provided for @cityKathmandu.
  ///
  /// In en, this message translates to:
  /// **'Kathmandu'**
  String get cityKathmandu;

  /// No description provided for @cityPokhara.
  ///
  /// In en, this message translates to:
  /// **'Pokhara'**
  String get cityPokhara;

  /// No description provided for @cityNewDelhi.
  ///
  /// In en, this message translates to:
  /// **'New Delhi'**
  String get cityNewDelhi;

  /// No description provided for @cityMumbai.
  ///
  /// In en, this message translates to:
  /// **'Mumbai'**
  String get cityMumbai;

  /// No description provided for @cityBengaluru.
  ///
  /// In en, this message translates to:
  /// **'Bengaluru'**
  String get cityBengaluru;

  /// No description provided for @cityChennai.
  ///
  /// In en, this message translates to:
  /// **'Chennai'**
  String get cityChennai;

  /// No description provided for @cityTokyo.
  ///
  /// In en, this message translates to:
  /// **'Tokyo'**
  String get cityTokyo;

  /// No description provided for @cityOsaka.
  ///
  /// In en, this message translates to:
  /// **'Osaka'**
  String get cityOsaka;

  /// No description provided for @citySeoul.
  ///
  /// In en, this message translates to:
  /// **'Seoul'**
  String get citySeoul;

  /// No description provided for @cityBeijing.
  ///
  /// In en, this message translates to:
  /// **'Beijing'**
  String get cityBeijing;

  /// No description provided for @cityShanghai.
  ///
  /// In en, this message translates to:
  /// **'Shanghai'**
  String get cityShanghai;

  /// No description provided for @cityHongKong.
  ///
  /// In en, this message translates to:
  /// **'Hong Kong'**
  String get cityHongKong;

  /// No description provided for @citySingapore.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get citySingapore;

  /// No description provided for @cityBangkok.
  ///
  /// In en, this message translates to:
  /// **'Bangkok'**
  String get cityBangkok;

  /// No description provided for @cityJakarta.
  ///
  /// In en, this message translates to:
  /// **'Jakarta'**
  String get cityJakarta;

  /// No description provided for @cityManila.
  ///
  /// In en, this message translates to:
  /// **'Manila'**
  String get cityManila;

  /// No description provided for @cityKualaLumpur.
  ///
  /// In en, this message translates to:
  /// **'Kuala Lumpur'**
  String get cityKualaLumpur;

  /// No description provided for @cityDhaka.
  ///
  /// In en, this message translates to:
  /// **'Dhaka'**
  String get cityDhaka;

  /// No description provided for @cityKarachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi'**
  String get cityKarachi;

  /// No description provided for @cityColombo.
  ///
  /// In en, this message translates to:
  /// **'Colombo'**
  String get cityColombo;

  /// No description provided for @cityDubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get cityDubai;

  /// No description provided for @cityLondon.
  ///
  /// In en, this message translates to:
  /// **'London'**
  String get cityLondon;

  /// No description provided for @cityParis.
  ///
  /// In en, this message translates to:
  /// **'Paris'**
  String get cityParis;

  /// No description provided for @cityBerlin.
  ///
  /// In en, this message translates to:
  /// **'Berlin'**
  String get cityBerlin;

  /// No description provided for @cityRome.
  ///
  /// In en, this message translates to:
  /// **'Rome'**
  String get cityRome;

  /// No description provided for @cityMadrid.
  ///
  /// In en, this message translates to:
  /// **'Madrid'**
  String get cityMadrid;

  /// No description provided for @cityAmsterdam.
  ///
  /// In en, this message translates to:
  /// **'Amsterdam'**
  String get cityAmsterdam;

  /// No description provided for @cityZurich.
  ///
  /// In en, this message translates to:
  /// **'Zurich'**
  String get cityZurich;

  /// No description provided for @cityAthens.
  ///
  /// In en, this message translates to:
  /// **'Athens'**
  String get cityAthens;

  /// No description provided for @cityIstanbul.
  ///
  /// In en, this message translates to:
  /// **'Istanbul'**
  String get cityIstanbul;

  /// No description provided for @cityNewYork.
  ///
  /// In en, this message translates to:
  /// **'New York'**
  String get cityNewYork;

  /// No description provided for @cityLosAngeles.
  ///
  /// In en, this message translates to:
  /// **'Los Angeles'**
  String get cityLosAngeles;

  /// No description provided for @cityChicago.
  ///
  /// In en, this message translates to:
  /// **'Chicago'**
  String get cityChicago;

  /// No description provided for @cityDenver.
  ///
  /// In en, this message translates to:
  /// **'Denver'**
  String get cityDenver;

  /// No description provided for @cityHonolulu.
  ///
  /// In en, this message translates to:
  /// **'Honolulu'**
  String get cityHonolulu;

  /// No description provided for @cityToronto.
  ///
  /// In en, this message translates to:
  /// **'Toronto'**
  String get cityToronto;

  /// No description provided for @cityVancouver.
  ///
  /// In en, this message translates to:
  /// **'Vancouver'**
  String get cityVancouver;

  /// No description provided for @citySaoPaulo.
  ///
  /// In en, this message translates to:
  /// **'São Paulo'**
  String get citySaoPaulo;

  /// No description provided for @cityBuenosAires.
  ///
  /// In en, this message translates to:
  /// **'Buenos Aires'**
  String get cityBuenosAires;

  /// No description provided for @cityCairo.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get cityCairo;

  /// No description provided for @cityNairobi.
  ///
  /// In en, this message translates to:
  /// **'Nairobi'**
  String get cityNairobi;

  /// No description provided for @cityJohannesburg.
  ///
  /// In en, this message translates to:
  /// **'Johannesburg'**
  String get cityJohannesburg;

  /// No description provided for @cityAuckland.
  ///
  /// In en, this message translates to:
  /// **'Auckland'**
  String get cityAuckland;

  /// No description provided for @cityWellington.
  ///
  /// In en, this message translates to:
  /// **'Wellington'**
  String get cityWellington;

  /// No description provided for @countryAustralia.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get countryAustralia;

  /// No description provided for @countryNepal.
  ///
  /// In en, this message translates to:
  /// **'Nepal'**
  String get countryNepal;

  /// No description provided for @countryIndia.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get countryIndia;

  /// No description provided for @countryJapan.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get countryJapan;

  /// No description provided for @countrySouthKorea.
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get countrySouthKorea;

  /// No description provided for @countryChina.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get countryChina;

  /// No description provided for @countryHongKong.
  ///
  /// In en, this message translates to:
  /// **'Hong Kong'**
  String get countryHongKong;

  /// No description provided for @countrySingapore.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get countrySingapore;

  /// No description provided for @countryThailand.
  ///
  /// In en, this message translates to:
  /// **'Thailand'**
  String get countryThailand;

  /// No description provided for @countryIndonesia.
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get countryIndonesia;

  /// No description provided for @countryPhilippines.
  ///
  /// In en, this message translates to:
  /// **'Philippines'**
  String get countryPhilippines;

  /// No description provided for @countryMalaysia.
  ///
  /// In en, this message translates to:
  /// **'Malaysia'**
  String get countryMalaysia;

  /// No description provided for @countryBangladesh.
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get countryBangladesh;

  /// No description provided for @countryPakistan.
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get countryPakistan;

  /// No description provided for @countrySriLanka.
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get countrySriLanka;

  /// No description provided for @countryUnitedArabEmirates.
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get countryUnitedArabEmirates;

  /// No description provided for @countryUnitedKingdom.
  ///
  /// In en, this message translates to:
  /// **'United Kingdom'**
  String get countryUnitedKingdom;

  /// No description provided for @countryFrance.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get countryFrance;

  /// No description provided for @countryGermany.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get countryGermany;

  /// No description provided for @countryItaly.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get countryItaly;

  /// No description provided for @countrySpain.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get countrySpain;

  /// No description provided for @countryNetherlands.
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get countryNetherlands;

  /// No description provided for @countrySwitzerland.
  ///
  /// In en, this message translates to:
  /// **'Switzerland'**
  String get countrySwitzerland;

  /// No description provided for @countryGreece.
  ///
  /// In en, this message translates to:
  /// **'Greece'**
  String get countryGreece;

  /// No description provided for @countryTurkiye.
  ///
  /// In en, this message translates to:
  /// **'Türkiye'**
  String get countryTurkiye;

  /// No description provided for @countryUnitedStates.
  ///
  /// In en, this message translates to:
  /// **'United States'**
  String get countryUnitedStates;

  /// No description provided for @countryCanada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get countryCanada;

  /// No description provided for @countryBrazil.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get countryBrazil;

  /// No description provided for @countryArgentina.
  ///
  /// In en, this message translates to:
  /// **'Argentina'**
  String get countryArgentina;

  /// No description provided for @countryEgypt.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get countryEgypt;

  /// No description provided for @countryKenya.
  ///
  /// In en, this message translates to:
  /// **'Kenya'**
  String get countryKenya;

  /// No description provided for @countrySouthAfrica.
  ///
  /// In en, this message translates to:
  /// **'South Africa'**
  String get countrySouthAfrica;

  /// No description provided for @countryNewZealand.
  ///
  /// In en, this message translates to:
  /// **'New Zealand'**
  String get countryNewZealand;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'done'**
  String get done;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @membership.
  ///
  /// In en, this message translates to:
  /// **'membership'**
  String get membership;

  /// No description provided for @projectUser.
  ///
  /// In en, this message translates to:
  /// **'Project User'**
  String get projectUser;

  /// No description provided for @defaultBio.
  ///
  /// In en, this message translates to:
  /// **'Focused on building better habits ✨'**
  String get defaultBio;

  /// No description provided for @member.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get member;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @badge.
  ///
  /// In en, this message translates to:
  /// **'Badge'**
  String get badge;

  /// No description provided for @earlyBird.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get earlyBird;

  /// No description provided for @nightOwl.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get nightOwl;

  /// No description provided for @streakSeven.
  ///
  /// In en, this message translates to:
  /// **'Streak 7'**
  String get streakSeven;

  /// No description provided for @focusOneHundredHours.
  ///
  /// In en, this message translates to:
  /// **'Focus 100h'**
  String get focusOneHundredHours;

  /// No description provided for @plannerPro.
  ///
  /// In en, this message translates to:
  /// **'Planner Pro'**
  String get plannerPro;

  /// No description provided for @zenMaster.
  ///
  /// In en, this message translates to:
  /// **'Zen Master'**
  String get zenMaster;

  /// No description provided for @unableToLoadBadges.
  ///
  /// In en, this message translates to:
  /// **'Unable to load badges'**
  String get unableToLoadBadges;

  /// No description provided for @badgesEarned.
  ///
  /// In en, this message translates to:
  /// **'{earned}/{total} earned'**
  String badgesEarned(int earned, int total);

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get recentActivity;

  /// No description provided for @refreshActivity.
  ///
  /// In en, this message translates to:
  /// **'Refresh activity'**
  String get refreshActivity;

  /// No description provided for @unableToLoadRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Unable to load recent activity'**
  String get unableToLoadRecentActivity;

  /// No description provided for @noRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity yet.'**
  String get noRecentActivity;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @scheduleAddedActivity.
  ///
  /// In en, this message translates to:
  /// **'Schedule added'**
  String get scheduleAddedActivity;

  /// No description provided for @scheduleCompletedActivity.
  ///
  /// In en, this message translates to:
  /// **'Schedule completed'**
  String get scheduleCompletedActivity;

  /// No description provided for @scheduleDeletedActivity.
  ///
  /// In en, this message translates to:
  /// **'Schedule deleted'**
  String get scheduleDeletedActivity;

  /// No description provided for @focusCompletedActivity.
  ///
  /// In en, this message translates to:
  /// **'Focus session completed'**
  String get focusCompletedActivity;

  /// No description provided for @badgeUnlockedActivity.
  ///
  /// In en, this message translates to:
  /// **'Badge unlocked'**
  String get badgeUnlockedActivity;

  /// No description provided for @membershipChangedActivity.
  ///
  /// In en, this message translates to:
  /// **'Membership changed'**
  String get membershipChangedActivity;

  /// No description provided for @levelUpActivity.
  ///
  /// In en, this message translates to:
  /// **'Level increased'**
  String get levelUpActivity;

  /// No description provided for @streakUpdatedActivity.
  ///
  /// In en, this message translates to:
  /// **'Streak updated'**
  String get streakUpdatedActivity;

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @minutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String minutesAgo(int count);

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String hoursAgo(int count);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @pleaseEnterYourName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// No description provided for @unableToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Unable to update profile'**
  String get unableToUpdateProfile;

  /// No description provided for @livePreview.
  ///
  /// In en, this message translates to:
  /// **'Live Preview'**
  String get livePreview;

  /// No description provided for @primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// No description provided for @secondary.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get secondary;

  /// No description provided for @primaryButtonPreview.
  ///
  /// In en, this message translates to:
  /// **'Primary button preview'**
  String get primaryButtonPreview;

  /// No description provided for @secondaryButtonPreview.
  ///
  /// In en, this message translates to:
  /// **'Secondary button preview'**
  String get secondaryButtonPreview;

  /// No description provided for @accentColorPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'This is how your selected accent colour will appear on buttons, icons, borders and selected controls throughout the app.'**
  String get accentColorPreviewDescription;

  /// No description provided for @themeColorDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose your accent color. Changes apply across the entire app instantly.'**
  String get themeColorDescription;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// No description provided for @ocean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get ocean;

  /// No description provided for @sunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get sunset;

  /// No description provided for @forest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get forest;

  /// No description provided for @rose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get rose;

  /// No description provided for @gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get gold;

  /// No description provided for @themeApplied.
  ///
  /// In en, this message translates to:
  /// **'{themeName} theme applied'**
  String themeApplied(String themeName);

  /// No description provided for @unableToSaveThemeColor.
  ///
  /// In en, this message translates to:
  /// **'Unable to save theme color'**
  String get unableToSaveThemeColor;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get saving;

  /// No description provided for @saveSettings.
  ///
  /// In en, this message translates to:
  /// **'Save settings'**
  String get saveSettings;

  /// No description provided for @enableSleepMode.
  ///
  /// In en, this message translates to:
  /// **'Enable Sleep Mode'**
  String get enableSleepMode;

  /// No description provided for @sleepModeActive.
  ///
  /// In en, this message translates to:
  /// **'Sleep Mode is active'**
  String get sleepModeActive;

  /// No description provided for @sleepModeOff.
  ///
  /// In en, this message translates to:
  /// **'Sleep Mode is turned off'**
  String get sleepModeOff;

  /// No description provided for @sleepSchedule.
  ///
  /// In en, this message translates to:
  /// **'Sleep Schedule'**
  String get sleepSchedule;

  /// No description provided for @sleepScheduleDescription.
  ///
  /// In en, this message translates to:
  /// **'Set your bedtime and wake-up time to maintain a consistent sleep routine.'**
  String get sleepScheduleDescription;

  /// No description provided for @bedtime.
  ///
  /// In en, this message translates to:
  /// **'Bedtime'**
  String get bedtime;

  /// No description provided for @wakeUpTime.
  ///
  /// In en, this message translates to:
  /// **'Wake-up Time'**
  String get wakeUpTime;

  /// No description provided for @selectBedtime.
  ///
  /// In en, this message translates to:
  /// **'Select bedtime'**
  String get selectBedtime;

  /// No description provided for @selectWakeUpTime.
  ///
  /// In en, this message translates to:
  /// **'Select wake-up time'**
  String get selectWakeUpTime;

  /// No description provided for @sleepModeSettingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Sleep Mode settings saved.'**
  String get sleepModeSettingsSaved;

  /// No description provided for @unableToLoadSleepModeSettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to load Sleep Mode settings.'**
  String get unableToLoadSleepModeSettings;

  /// No description provided for @unableToSaveSleepModeSettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to save Sleep Mode settings.'**
  String get unableToSaveSleepModeSettings;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @blockedApps.
  ///
  /// In en, this message translates to:
  /// **'Blocked Apps'**
  String get blockedApps;

  /// No description provided for @unableToLoadFocusModeSettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to load Focus Mode settings.'**
  String get unableToLoadFocusModeSettings;

  /// No description provided for @unableToSaveFocusModeSettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to save Focus Mode settings.'**
  String get unableToSaveFocusModeSettings;

  /// No description provided for @breakInterval.
  ///
  /// In en, this message translates to:
  /// **'Break Interval'**
  String get breakInterval;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @selectDndStartTime.
  ///
  /// In en, this message translates to:
  /// **'Select Do Not Disturb start time'**
  String get selectDndStartTime;

  /// No description provided for @selectDndEndTime.
  ///
  /// In en, this message translates to:
  /// **'Select Do Not Disturb end time'**
  String get selectDndEndTime;

  /// No description provided for @focusModeDescription.
  ///
  /// In en, this message translates to:
  /// **'Block distracting apps while working'**
  String get focusModeDescription;

  /// No description provided for @emailVerification.
  ///
  /// In en, this message translates to:
  /// **'Email Verification'**
  String get emailVerification;

  /// No description provided for @emailVerificationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Email verification enabled'**
  String get emailVerificationEnabled;

  /// No description provided for @emailVerified.
  ///
  /// In en, this message translates to:
  /// **'Your email has been verified.'**
  String get emailVerified;

  /// No description provided for @verificationEnabledFor.
  ///
  /// In en, this message translates to:
  /// **'Verification is enabled for {email}.'**
  String verificationEnabledFor(String email);

  /// No description provided for @disableEmailVerification.
  ///
  /// In en, this message translates to:
  /// **'Disable Email Verification'**
  String get disableEmailVerification;

  /// No description provided for @disabling.
  ///
  /// In en, this message translates to:
  /// **'Disabling...'**
  String get disabling;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyYourEmail;

  /// No description provided for @verificationCodeWillBeSent.
  ///
  /// In en, this message translates to:
  /// **'A verification code will be sent to your email.'**
  String get verificationCodeWillBeSent;

  /// No description provided for @sixDigitCodeWillBeSentTo.
  ///
  /// In en, this message translates to:
  /// **'We will send a six-digit code to {email}.'**
  String sixDigitCodeWillBeSentTo(String email);

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'Sending...'**
  String get sending;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @sixDigitVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Six-digit verification code'**
  String get sixDigitVerificationCode;

  /// No description provided for @verifyAndEnable.
  ///
  /// In en, this message translates to:
  /// **'Verify and Enable'**
  String get verifyAndEnable;

  /// No description provided for @sessionExpiredLoginAgain.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again.'**
  String get sessionExpiredLoginAgain;

  /// No description provided for @noEmailConnected.
  ///
  /// In en, this message translates to:
  /// **'No email address is connected to your account.'**
  String get noEmailConnected;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'A verification code was sent. Use only the newest code.'**
  String get verificationCodeSent;

  /// No description provided for @waitBeforeRequestingCode.
  ///
  /// In en, this message translates to:
  /// **'Please wait about 60 seconds before requesting another code.'**
  String get waitBeforeRequestingCode;

  /// No description provided for @sendVerificationCodeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please send a verification code first.'**
  String get sendVerificationCodeFirst;

  /// No description provided for @enterCompleteSixDigitCode.
  ///
  /// In en, this message translates to:
  /// **'Please enter the complete six-digit code.'**
  String get enterCompleteSixDigitCode;

  /// No description provided for @verificationCodeExpired.
  ///
  /// In en, this message translates to:
  /// **'The code is invalid or expired. Press Send Code and use the newest email.'**
  String get verificationCodeExpired;

  /// No description provided for @verificationCodeIncorrect.
  ///
  /// In en, this message translates to:
  /// **'The verification code is incorrect. Check the newest email.'**
  String get verificationCodeIncorrect;

  /// No description provided for @verificationCodeNotConfirmed.
  ///
  /// In en, this message translates to:
  /// **'The verification code could not be confirmed.'**
  String get verificationCodeNotConfirmed;

  /// No description provided for @verifiedEmailMismatch.
  ///
  /// In en, this message translates to:
  /// **'The verified email does not match the current account.'**
  String get verifiedEmailMismatch;

  /// No description provided for @unableToLoadEmailVerificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to load email verification settings.'**
  String get unableToLoadEmailVerificationSettings;

  /// No description provided for @unableToSendVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Unable to send the verification code.'**
  String get unableToSendVerificationCode;

  /// No description provided for @unableToVerifyVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Unable to verify the verification code.'**
  String get unableToVerifyVerificationCode;

  /// No description provided for @unableToDisableEmailVerification.
  ///
  /// In en, this message translates to:
  /// **'Unable to disable email verification.'**
  String get unableToDisableEmailVerification;

  /// No description provided for @unableToLoadSecuritySettings.
  ///
  /// In en, this message translates to:
  /// **'Unable to load security settings.'**
  String get unableToLoadSecuritySettings;

  /// No description provided for @faceIdLogin.
  ///
  /// In en, this message translates to:
  /// **'Face ID Login'**
  String get faceIdLogin;

  /// No description provided for @fingerprintLogin.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint Login'**
  String get fingerprintLogin;

  /// No description provided for @biometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Biometric Login'**
  String get biometricLogin;

  /// No description provided for @checkingAuthentication.
  ///
  /// In en, this message translates to:
  /// **'Checking authentication...'**
  String get checkingAuthentication;

  /// No description provided for @faceIdLoginEnabled.
  ///
  /// In en, this message translates to:
  /// **'Face ID login is enabled'**
  String get faceIdLoginEnabled;

  /// No description provided for @unlockUsingFaceId.
  ///
  /// In en, this message translates to:
  /// **'Unlock using Face ID'**
  String get unlockUsingFaceId;

  /// No description provided for @fingerprintLoginEnabled.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint login is enabled'**
  String get fingerprintLoginEnabled;

  /// No description provided for @unlockUsingFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Unlock using fingerprint'**
  String get unlockUsingFingerprint;

  /// No description provided for @biometricUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Face ID or fingerprint is unavailable'**
  String get biometricUnavailable;

  /// No description provided for @faceIdOrFingerprint.
  ///
  /// In en, this message translates to:
  /// **'Face ID / Fingerprint'**
  String get faceIdOrFingerprint;

  /// No description provided for @faceId.
  ///
  /// In en, this message translates to:
  /// **'Face ID'**
  String get faceId;

  /// No description provided for @fingerprint.
  ///
  /// In en, this message translates to:
  /// **'Fingerprint'**
  String get fingerprint;

  /// No description provided for @biometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric'**
  String get biometric;

  /// No description provided for @twoFactorAuth.
  ///
  /// In en, this message translates to:
  /// **'Two-Factor Auth'**
  String get twoFactorAuth;

  /// No description provided for @openingEmailVerification.
  ///
  /// In en, this message translates to:
  /// **'Opening email verification...'**
  String get openingEmailVerification;

  /// No description provided for @verifyUsingEmailOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify using email OTP'**
  String get verifyUsingEmailOtp;

  /// No description provided for @emailVerificationEnabledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Email verification enabled successfully.'**
  String get emailVerificationEnabledSuccessfully;

  /// No description provided for @emailVerificationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Email verification disabled.'**
  String get emailVerificationDisabled;

  /// No description provided for @unableToOpenEmailVerification.
  ///
  /// In en, this message translates to:
  /// **'Unable to open email verification.'**
  String get unableToOpenEmailVerification;

  /// No description provided for @enterCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password.'**
  String get enterCurrentPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password.'**
  String get enterNewPassword;

  /// No description provided for @newPasswordMustBeDifferent.
  ///
  /// In en, this message translates to:
  /// **'The new password must be different from your current password.'**
  String get newPasswordMustBeDifferent;

  /// No description provided for @currentPasswordIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Your current password is incorrect.'**
  String get currentPasswordIncorrect;

  /// No description provided for @unableToUpdatePassword.
  ///
  /// In en, this message translates to:
  /// **'Unable to update your password. Please try again.'**
  String get unableToUpdatePassword;

  /// No description provided for @biometricLoginDisabled.
  ///
  /// In en, this message translates to:
  /// **'{authenticationName} login disabled.'**
  String biometricLoginDisabled(String authenticationName);

  /// No description provided for @biometricLoginEnabled.
  ///
  /// In en, this message translates to:
  /// **'{authenticationName} login enabled successfully.'**
  String biometricLoginEnabled(String authenticationName);

  /// No description provided for @sessionExpiredBeforeBiometric.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please log in again before enabling biometric login.'**
  String get sessionExpiredBeforeBiometric;

  /// No description provided for @configureBiometricsFirst.
  ///
  /// In en, this message translates to:
  /// **'Face ID or fingerprint is not available. Configure biometrics in your device settings first.'**
  String get configureBiometricsFirst;

  /// No description provided for @noBiometricAuthenticationEnrolled.
  ///
  /// In en, this message translates to:
  /// **'No biometric authentication is enrolled. Configure Face ID, Touch ID, or fingerprint in your device settings.'**
  String get noBiometricAuthenticationEnrolled;

  /// No description provided for @biometricVerificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Biometric verification was not successful.'**
  String get biometricVerificationFailed;

  /// No description provided for @unableToUpdateBiometricLogin.
  ///
  /// In en, this message translates to:
  /// **'Unable to update biometric login.'**
  String get unableToUpdateBiometricLogin;

  /// No description provided for @activityLog.
  ///
  /// In en, this message translates to:
  /// **'Activity Log'**
  String get activityLog;

  /// No description provided for @viewAccountActivity.
  ///
  /// In en, this message translates to:
  /// **'View your account activity'**
  String get viewAccountActivity;

  /// No description provided for @activityTrackingDisabled.
  ///
  /// In en, this message translates to:
  /// **'Activity tracking is disabled'**
  String get activityTrackingDisabled;

  /// No description provided for @activityLogEnabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Activity log enabled.'**
  String get activityLogEnabledMessage;

  /// No description provided for @activityLogDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Activity log disabled.'**
  String get activityLogDisabledMessage;

  /// No description provided for @unableToUpdateActivityLog.
  ///
  /// In en, this message translates to:
  /// **'Unable to update activity log.'**
  String get unableToUpdateActivityLog;

  /// No description provided for @dataSharing.
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get dataSharing;

  /// No description provided for @analyticsSharingEnabled.
  ///
  /// In en, this message translates to:
  /// **'Analytics sharing is enabled'**
  String get analyticsSharingEnabled;

  /// No description provided for @shareAnalyticsWithUs.
  ///
  /// In en, this message translates to:
  /// **'Share analytics with us'**
  String get shareAnalyticsWithUs;

  /// No description provided for @dataSharingEnabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Data sharing enabled.'**
  String get dataSharingEnabledMessage;

  /// No description provided for @dataSharingDisabledMessage.
  ///
  /// In en, this message translates to:
  /// **'Data sharing disabled.'**
  String get dataSharingDisabledMessage;

  /// No description provided for @unableToUpdateDataSharing.
  ///
  /// In en, this message translates to:
  /// **'Unable to update data sharing.'**
  String get unableToUpdateDataSharing;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @updateLoginPassword.
  ///
  /// In en, this message translates to:
  /// **'Update your login password'**
  String get updateLoginPassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePassword;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Weak Password'**
  String get weakPassword;

  /// No description provided for @mediumPassword.
  ///
  /// In en, this message translates to:
  /// **'Medium Password'**
  String get mediumPassword;

  /// No description provided for @strongPassword.
  ///
  /// In en, this message translates to:
  /// **'Strong Password'**
  String get strongPassword;

  /// No description provided for @passwordUpdateServiceNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Password update service is not connected.'**
  String get passwordUpdateServiceNotConnected;

  /// No description provided for @passwordUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdatedSuccessfully;

  /// No description provided for @clearActivityLog.
  ///
  /// In en, this message translates to:
  /// **'Clear activity log'**
  String get clearActivityLog;

  /// No description provided for @clearActivityLogQuestion.
  ///
  /// In en, this message translates to:
  /// **'Clear activity log?'**
  String get clearActivityLogQuestion;

  /// No description provided for @allActivityRecordsDeleted.
  ///
  /// In en, this message translates to:
  /// **'All activity records will be deleted.'**
  String get allActivityRecordsDeleted;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @activityLogCleared.
  ///
  /// In en, this message translates to:
  /// **'Activity log cleared.'**
  String get activityLogCleared;

  /// No description provided for @unableToLoadActivityLog.
  ///
  /// In en, this message translates to:
  /// **'Unable to load activity log.'**
  String get unableToLoadActivityLog;

  /// No description provided for @unableToClearActivityLog.
  ///
  /// In en, this message translates to:
  /// **'Unable to clear activity log.'**
  String get unableToClearActivityLog;

  /// No description provided for @noActivityRecordedYet.
  ///
  /// In en, this message translates to:
  /// **'No activity recorded yet.'**
  String get noActivityRecordedYet;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @pleaseLogInToViewNotifications.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view notifications.'**
  String get pleaseLogInToViewNotifications;

  /// No description provided for @unableToLoadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unable to load notifications.'**
  String get unableToLoadNotifications;

  /// No description provided for @unableToMarkNotificationAsRead.
  ///
  /// In en, this message translates to:
  /// **'Unable to mark notification as read'**
  String get unableToMarkNotificationAsRead;

  /// No description provided for @unableToMarkNotificationAsUnread.
  ///
  /// In en, this message translates to:
  /// **'Unable to mark notification as unread'**
  String get unableToMarkNotificationAsUnread;

  /// No description provided for @allNotificationsMarkedAsRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read.'**
  String get allNotificationsMarkedAsRead;

  /// No description provided for @unableToMarkAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Unable to mark all as read'**
  String get unableToMarkAllAsRead;

  /// No description provided for @notificationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted.'**
  String get notificationDeleted;

  /// No description provided for @unableToDeleteNotification.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete notification'**
  String get unableToDeleteNotification;

  /// No description provided for @deleteAllNotificationsQuestion.
  ///
  /// In en, this message translates to:
  /// **'Delete all notifications?'**
  String get deleteAllNotificationsQuestion;

  /// No description provided for @deleteAllNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove all notifications from your inbox.'**
  String get deleteAllNotificationsDescription;

  /// No description provided for @deleteAll.
  ///
  /// In en, this message translates to:
  /// **'Delete all'**
  String get deleteAll;

  /// No description provided for @allNotificationsDeleted.
  ///
  /// In en, this message translates to:
  /// **'All notifications deleted.'**
  String get allNotificationsDeleted;

  /// No description provided for @unableToDeleteAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unable to delete all notifications'**
  String get unableToDeleteAllNotifications;

  /// No description provided for @markAsUnread.
  ///
  /// In en, this message translates to:
  /// **'Mark as unread'**
  String get markAsUnread;

  /// No description provided for @markAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markAsRead;

  /// No description provided for @deleteNotification.
  ///
  /// In en, this message translates to:
  /// **'Delete notification'**
  String get deleteNotification;

  /// No description provided for @todayWithTime.
  ///
  /// In en, this message translates to:
  /// **'Today • {time}'**
  String todayWithTime(String time);

  /// No description provided for @yesterdayWithTime.
  ///
  /// In en, this message translates to:
  /// **'Yesterday • {time}'**
  String yesterdayWithTime(String time);

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// No description provided for @notificationInboxEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Your schedule reminders and task updates will appear here.'**
  String get notificationInboxEmptyDescription;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @moreOptions.
  ///
  /// In en, this message translates to:
  /// **'More options'**
  String get moreOptions;

  /// No description provided for @notificationChannels.
  ///
  /// In en, this message translates to:
  /// **'CHANNELS'**
  String get notificationChannels;

  /// No description provided for @notificationAlerts.
  ///
  /// In en, this message translates to:
  /// **'ALERTS'**
  String get notificationAlerts;

  /// No description provided for @notificationDisplay.
  ///
  /// In en, this message translates to:
  /// **'DISPLAY'**
  String get notificationDisplay;

  /// No description provided for @couldNotLoadNotificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Could not load notification settings.'**
  String get couldNotLoadNotificationSettings;

  /// No description provided for @couldNotSaveNotificationSetting.
  ///
  /// In en, this message translates to:
  /// **'Could not save notification setting.'**
  String get couldNotSaveNotificationSetting;

  /// No description provided for @pushNotifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get pushNotifications;

  /// No description provided for @emailNotifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get emailNotifications;

  /// No description provided for @scheduleReminders.
  ///
  /// In en, this message translates to:
  /// **'Schedule Reminders'**
  String get scheduleReminders;

  /// No description provided for @breakAlerts.
  ///
  /// In en, this message translates to:
  /// **'Break Alerts'**
  String get breakAlerts;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @weeklyReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly Report'**
  String get weeklyReport;

  /// No description provided for @notificationSounds.
  ///
  /// In en, this message translates to:
  /// **'Notification Sounds'**
  String get notificationSounds;

  /// No description provided for @appBadges.
  ///
  /// In en, this message translates to:
  /// **'App Badges'**
  String get appBadges;

  /// No description provided for @realTimeAlertsOnYourDevice.
  ///
  /// In en, this message translates to:
  /// **'Real-time alerts on your device'**
  String get realTimeAlertsOnYourDevice;

  /// No description provided for @digestToYourInbox.
  ///
  /// In en, this message translates to:
  /// **'Digest to your inbox'**
  String get digestToYourInbox;

  /// No description provided for @beforeEventsStart.
  ///
  /// In en, this message translates to:
  /// **'Before events start'**
  String get beforeEventsStart;

  /// No description provided for @remindToTakeBreaks.
  ///
  /// In en, this message translates to:
  /// **'Remind to take breaks'**
  String get remindToTakeBreaks;

  /// No description provided for @badgesAndMilestones.
  ///
  /// In en, this message translates to:
  /// **'Badges & milestones'**
  String get badgesAndMilestones;

  /// No description provided for @sundaySummaryEmail.
  ///
  /// In en, this message translates to:
  /// **'Sunday summary email'**
  String get sundaySummaryEmail;

  /// No description provided for @audioForAlerts.
  ///
  /// In en, this message translates to:
  /// **'Audio for alerts'**
  String get audioForAlerts;

  /// No description provided for @unreadCountOnIcon.
  ///
  /// In en, this message translates to:
  /// **'Unread count on icon'**
  String get unreadCountOnIcon;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'ne'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'ne': return AppLocalizationsNe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
