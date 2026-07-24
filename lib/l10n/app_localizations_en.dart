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
  String get privacyAndSecurity => 'Privacy & Security';

  @override
  String get focusAndDnd => 'Focus & Do Not Disturb';

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
  String get tryAgain => 'Try again';

  @override
  String get close => 'Close';

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
  String get todaysSchedule => 'Today\'s Schedule';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get totalFocusTime => 'Total Focus Time';

  @override
  String get focusTime => 'Focus Time';

  @override
  String get focusHours => 'Focus Hours';

  @override
  String get tasksDone => 'Tasks Done';

  @override
  String get totalTasks => 'Total Tasks';

  @override
  String get completed => 'Completed';

  @override
  String get completedTasksTitle => 'Completed Tasks';

  @override
  String get completionRate => 'Completion Rate';

  @override
  String get dailyFocusHours => 'Daily Focus Hours';

  @override
  String get byCategory => 'By Category';

  @override
  String get monthlyFocus => 'Monthly Focus';

  @override
  String get productivityInsights => 'Your productivity insights';

  @override
  String get profileSection => 'Profile';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get focusModesSection => 'Focus Modes';

  @override
  String get profileSubtitle => 'Name, photo, bio';

  @override
  String get privacySubtitle => 'Password, 2FA, biometrics';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeOn => 'On — dark interface';

  @override
  String get darkModeOff => 'Off — light interface';

  @override
  String get notificationsSubtitle => 'Push, email, reminders';

  @override
  String get themeColorSubtitle => 'Customize app color scheme';

  @override
  String get focusMode => 'Focus Mode';

  @override
  String get focusModeSubtitle => 'Blocked apps, break intervals';

  @override
  String get sleepModeSubtitle => 'Bedtime and wake-up schedule';

  @override
  String get doNotDisturb => 'Do Not Disturb';

  @override
  String get loadingSettings => 'Loading settings...';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get am => 'AM';

  @override
  String get pm => 'PM';

  @override
  String get dndEnabled => 'Do Not Disturb enabled';

  @override
  String get dndDisabled => 'Do Not Disturb disabled';

  @override
  String tasksCompleted(int completed, int total) {
    return '$completed of $total tasks completed';
  }

  @override
  String get pleaseLoginToViewStatistics => 'Please log in to view statistics.';

  @override
  String get unableToLoadStatistics => 'Unable to load statistics.';

  @override
  String get untitled => 'Untitled';

  @override
  String get studyMode => 'Study Mode';

  @override
  String get workMode => 'Work Mode';

  @override
  String get sleeping => 'Sleeping';

  @override
  String get loginToViewSchedules => 'Please log in to view schedules.';

  @override
  String get pleaseLoginToViewSchedules => 'Please log in to view schedules.';

  @override
  String get unableToLoadSchedules => 'Unable to load schedules.';

  @override
  String databaseError(Object message) {
    return 'Database error: $message';
  }

  @override
  String get scheduleAdded => 'Schedule Added';

  @override
  String scheduleAddedBody(Object title) {
    return '\"$title\" was added to your schedule.';
  }

  @override
  String scheduleAddedSuccessfully(String title) {
    return 'Schedule added successfully: $title';
  }

  @override
  String get scheduleIdMissing => 'Schedule database ID is missing.';

  @override
  String get loginBeforeUpdating => 'Please log in before updating.';

  @override
  String get loginBeforeUpdatingSchedule => 'Please log in before updating a schedule.';

  @override
  String get loginBeforeDeleting => 'Please log in before deleting.';

  @override
  String get loginBeforeDeletingSchedule => 'Please log in before deleting a schedule.';

  @override
  String taskCompleted(String title) {
    return '$title completed';
  }

  @override
  String get taskReopened => 'Task Reopened';

  @override
  String taskReopenedBody(String title) {
    return '\"$title\" was marked as incomplete.';
  }

  @override
  String taskMarkedCompleted(String title, int count) {
    return 'Task \"$title\" marked as completed. Done: $count';
  }

  @override
  String taskMarkedIncomplete(String title, int count) {
    return 'Task \"$title\" marked as incomplete. Done: $count';
  }

  @override
  String updateFailed(String message) {
    return 'Update failed: $message';
  }

  @override
  String unableToUpdateSchedule(String message) {
    return 'Unable to update schedule: $message';
  }

  @override
  String deleteFailed(String message) {
    return 'Delete failed: $message';
  }

  @override
  String unableToDeleteSchedule(String message) {
    return 'Unable to delete schedule: $message';
  }

  @override
  String scheduleDeletedSuccessfully(String title) {
    return 'Schedule deleted successfully: $title';
  }

  @override
  String scheduleSelected(String title) {
    return 'Schedule selected: $title';
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

  @override
  String unableToLoadDndSettings(String message) {
    return 'Unable to load Do Not Disturb settings: $message';
  }

  @override
  String unableToUpdateDnd(String message) {
    return 'Unable to update Do Not Disturb: $message';
  }

  @override
  String get sleepModeSettingsUpdated => 'Sleep Mode settings updated';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirmation => 'Are you sure you want to sign out?';

  @override
  String signOutFailed(String message) {
    return 'Sign out failed: $message';
  }

  @override
  String pageTitle(String title) {
    return '$title Page';
  }

  @override
  String get addSchedule => 'Add Schedule';

  @override
  String get orAddManually => 'OR ADD MANUALLY';

  @override
  String get title => 'Title';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get startTime => 'Start Time';

  @override
  String get durationMinutes => 'Duration (min)';

  @override
  String get csvTemplateReady => 'CSV template is ready.';

  @override
  String unableToPrepareTemplate(String message) {
    return 'Unable to prepare template: $message';
  }

  @override
  String get loginBeforeImportingSchedules => 'Please log in before importing schedules.';

  @override
  String get noSchedulesImported => 'No schedules were imported.';

  @override
  String unableToImportCsv(String message) {
    return 'Unable to import CSV file: $message';
  }

  @override
  String get importSchedulesQuestion => 'Import schedules?';

  @override
  String get importProblems => 'Import problems';

  @override
  String get noValidSchedulesFound => 'No valid schedules were found.';

  @override
  String validSchedulesFound(int count) {
    return '$count valid schedules found.';
  }

  @override
  String rowsWillBeSkipped(int count) {
    return '$count rows will be skipped.';
  }

  @override
  String minutesShort(int count) {
    return '$count min';
  }

  @override
  String andMore(int count) {
    return 'And $count more.';
  }

  @override
  String importCount(int count) {
    return 'Import $count';
  }

  @override
  String get unknownCategory => 'Unknown category.';

  @override
  String unknownCategoryAtRow(int row, String category) {
    return 'Row $row: Unknown category \"$category\".';
  }

  @override
  String rowError(int row, String message) {
    return 'Row $row: $message';
  }

  @override
  String schedulesImportedSuccessfully(int count) {
    return '$count schedules imported successfully.';
  }

  @override
  String schedulesImportedWithSkipped(int count, int skipped) {
    return '$count schedules imported successfully, $skipped skipped.';
  }

  @override
  String get enterScheduleTitle => 'Please enter a schedule title.';

  @override
  String get enterValidDuration => 'Please enter a valid duration.';

  @override
  String get loginBeforeSavingSchedule => 'Please log in before saving a schedule.';

  @override
  String get selectFutureDateTime => 'Please select a future date and time.';

  @override
  String get scheduleIdNotReturned => 'No schedule ID was returned.';

  @override
  String unableToSaveSchedule(String message) {
    return 'Unable to save schedule: $message';
  }

  @override
  String get noSchedulesAvailable => 'No schedules available';

  @override
  String get all => 'All';

  @override
  String get work => 'Work';

  @override
  String get study => 'Study';

  @override
  String get health => 'Health';

  @override
  String get personal => 'Personal';

  @override
  String get social => 'Social';

  @override
  String get exercise => 'Exercise';

  @override
  String get durationRequired => 'Duration is required';

  @override
  String get enterValidNumber => 'Enter a valid number';

  @override
  String minimumDuration(int minutes) {
    return 'Minimum duration is $minutes minute';
  }

  @override
  String maximumDuration(int minutes) {
    return 'Maximum duration is $minutes minutes';
  }

  @override
  String get deleteSchedule => 'Delete schedule';

  @override
  String get deepWork => 'Deep Work';

  @override
  String get readingMode => 'Reading Mode';

  @override
  String get exerciseMode => 'Exercise Mode';

  @override
  String get noFocusMode => 'No Focus Mode';

  @override
  String get custom => 'Custom';

  @override
  String get user => 'User';

  @override
  String notificationsUnread(int count) {
    return 'Notifications, $count unread';
  }

  @override
  String get noSchedulesForToday => 'No schedules for today';

  @override
  String get pressAddToCreateSchedule => 'Press Add to create a schedule.';

  @override
  String get scheduleUpdateFailed => 'Schedule was not updated. Check the schedule RLS policy.';

  @override
  String get scheduleDeleteFailed => 'Schedule was not deleted. Check the schedule RLS policy.';

  @override
  String get importSchedule => 'Import Schedule';

  @override
  String get uploadCsvDescription => 'Upload a CSV file to add multiple schedules at once.';

  @override
  String selectedFile(String fileName) {
    return 'Selected: $fileName';
  }

  @override
  String get preparingTemplate => 'Preparing template...';

  @override
  String get downloadTemplate => 'Download template';

  @override
  String get uploadFile => 'Upload File';

  @override
  String get scheduleTitleRequired => 'Please enter a schedule title';

  @override
  String minimumTitleLength(int count) {
    return 'Title must contain at least $count characters';
  }

  @override
  String get scheduleTitleHint => 'e.g. Deep Work Session';

  @override
  String get durationHint => '60';

  @override
  String get saveSchedule => 'Save Schedule';

  @override
  String get noData => 'No data';

  @override
  String get noFocusDataYet => 'No focus data yet';

  @override
  String get mon => 'Mon';

  @override
  String get tue => 'Tue';

  @override
  String get wed => 'Wed';

  @override
  String get thu => 'Thu';

  @override
  String get fri => 'Fri';

  @override
  String get sat => 'Sat';

  @override
  String get sun => 'Sun';

  @override
  String get jan => 'Jan';

  @override
  String get feb => 'Feb';

  @override
  String get mar => 'Mar';

  @override
  String get apr => 'Apr';

  @override
  String get may => 'May';

  @override
  String get jun => 'Jun';

  @override
  String get jul => 'Jul';

  @override
  String get aug => 'Aug';

  @override
  String get sep => 'Sep';

  @override
  String get oct => 'Oct';

  @override
  String get nov => 'Nov';

  @override
  String get dec => 'Dec';

  @override
  String get taskDone => 'Task done';

  @override
  String get tasksDonePlural => 'Tasks done';

  @override
  String get hoursShort => 'hr';

  @override
  String get minutesAbbreviation => 'min';

  @override
  String get addWorldClock => 'Add World Clock';

  @override
  String get worldClocks => 'World Clocks';

  @override
  String get searchCityCountryTimezone => 'Search city, country or timezone';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get noCityFound => 'No city found';

  @override
  String get tryAnotherCityCountryTimezone => 'Try another city, country or timezone.';

  @override
  String get isAlreadyAdded => 'is already added';

  @override
  String get added => 'added';

  @override
  String get removed => 'removed';

  @override
  String get unableToLoadWorldClocks => 'Unable to load world clocks';

  @override
  String get unableToAddClock => 'Unable to add clock';

  @override
  String get unableToRemoveClock => 'Unable to remove clock';

  @override
  String get thisClockCannotBeDeleted => 'This clock cannot be deleted.';

  @override
  String get deleteClock => 'Delete clock?';

  @override
  String get fromYourWorldClocks => 'from your world clocks?';

  @override
  String get noWorldClocksAdded => 'No world clocks added';

  @override
  String get tapPlusToAddCity => 'Tap the + button to search and add a city.';

  @override
  String get searchCity => 'Search city';

  @override
  String get unableToLoadProfile => 'Unable to load profile';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully';

  @override
  String get profileDataUnavailable => 'Profile data is unavailable';

  @override
  String get citySydney => 'Sydney';

  @override
  String get cityMelbourne => 'Melbourne';

  @override
  String get cityBrisbane => 'Brisbane';

  @override
  String get cityPerth => 'Perth';

  @override
  String get cityAdelaide => 'Adelaide';

  @override
  String get cityDarwin => 'Darwin';

  @override
  String get cityHobart => 'Hobart';

  @override
  String get cityKathmandu => 'Kathmandu';

  @override
  String get cityPokhara => 'Pokhara';

  @override
  String get cityNewDelhi => 'New Delhi';

  @override
  String get cityMumbai => 'Mumbai';

  @override
  String get cityBengaluru => 'Bengaluru';

  @override
  String get cityChennai => 'Chennai';

  @override
  String get cityTokyo => 'Tokyo';

  @override
  String get cityOsaka => 'Osaka';

  @override
  String get citySeoul => 'Seoul';

  @override
  String get cityBeijing => 'Beijing';

  @override
  String get cityShanghai => 'Shanghai';

  @override
  String get cityHongKong => 'Hong Kong';

  @override
  String get citySingapore => 'Singapore';

  @override
  String get cityBangkok => 'Bangkok';

  @override
  String get cityJakarta => 'Jakarta';

  @override
  String get cityManila => 'Manila';

  @override
  String get cityKualaLumpur => 'Kuala Lumpur';

  @override
  String get cityDhaka => 'Dhaka';

  @override
  String get cityKarachi => 'Karachi';

  @override
  String get cityColombo => 'Colombo';

  @override
  String get cityDubai => 'Dubai';

  @override
  String get cityLondon => 'London';

  @override
  String get cityParis => 'Paris';

  @override
  String get cityBerlin => 'Berlin';

  @override
  String get cityRome => 'Rome';

  @override
  String get cityMadrid => 'Madrid';

  @override
  String get cityAmsterdam => 'Amsterdam';

  @override
  String get cityZurich => 'Zurich';

  @override
  String get cityAthens => 'Athens';

  @override
  String get cityIstanbul => 'Istanbul';

  @override
  String get cityNewYork => 'New York';

  @override
  String get cityLosAngeles => 'Los Angeles';

  @override
  String get cityChicago => 'Chicago';

  @override
  String get cityDenver => 'Denver';

  @override
  String get cityHonolulu => 'Honolulu';

  @override
  String get cityToronto => 'Toronto';

  @override
  String get cityVancouver => 'Vancouver';

  @override
  String get citySaoPaulo => 'São Paulo';

  @override
  String get cityBuenosAires => 'Buenos Aires';

  @override
  String get cityCairo => 'Cairo';

  @override
  String get cityNairobi => 'Nairobi';

  @override
  String get cityJohannesburg => 'Johannesburg';

  @override
  String get cityAuckland => 'Auckland';

  @override
  String get cityWellington => 'Wellington';

  @override
  String get countryAustralia => 'Australia';

  @override
  String get countryNepal => 'Nepal';

  @override
  String get countryIndia => 'India';

  @override
  String get countryJapan => 'Japan';

  @override
  String get countrySouthKorea => 'South Korea';

  @override
  String get countryChina => 'China';

  @override
  String get countryHongKong => 'Hong Kong';

  @override
  String get countrySingapore => 'Singapore';

  @override
  String get countryThailand => 'Thailand';

  @override
  String get countryIndonesia => 'Indonesia';

  @override
  String get countryPhilippines => 'Philippines';

  @override
  String get countryMalaysia => 'Malaysia';

  @override
  String get countryBangladesh => 'Bangladesh';

  @override
  String get countryPakistan => 'Pakistan';

  @override
  String get countrySriLanka => 'Sri Lanka';

  @override
  String get countryUnitedArabEmirates => 'United Arab Emirates';

  @override
  String get countryUnitedKingdom => 'United Kingdom';

  @override
  String get countryFrance => 'France';

  @override
  String get countryGermany => 'Germany';

  @override
  String get countryItaly => 'Italy';

  @override
  String get countrySpain => 'Spain';

  @override
  String get countryNetherlands => 'Netherlands';

  @override
  String get countrySwitzerland => 'Switzerland';

  @override
  String get countryGreece => 'Greece';

  @override
  String get countryTurkiye => 'Türkiye';

  @override
  String get countryUnitedStates => 'United States';

  @override
  String get countryCanada => 'Canada';

  @override
  String get countryBrazil => 'Brazil';

  @override
  String get countryArgentina => 'Argentina';

  @override
  String get countryEgypt => 'Egypt';

  @override
  String get countryKenya => 'Kenya';

  @override
  String get countrySouthAfrica => 'South Africa';

  @override
  String get countryNewZealand => 'New Zealand';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get days => 'days';

  @override
  String get done => 'done';

  @override
  String get hours => 'hours';

  @override
  String get membership => 'membership';

  @override
  String get projectUser => 'Project User';

  @override
  String get defaultBio => 'Focused on building better habits ✨';

  @override
  String get member => 'Member';

  @override
  String get level => 'Level';

  @override
  String get badges => 'Badges';

  @override
  String get badge => 'Badge';

  @override
  String get earlyBird => 'Early Bird';

  @override
  String get nightOwl => 'Night Owl';

  @override
  String get streakSeven => 'Streak 7';

  @override
  String get focusOneHundredHours => 'Focus 100h';

  @override
  String get plannerPro => 'Planner Pro';

  @override
  String get zenMaster => 'Zen Master';

  @override
  String get unableToLoadBadges => 'Unable to load badges';

  @override
  String badgesEarned(int earned, int total) {
    return '$earned/$total earned';
  }

  @override
  String get recentActivity => 'Recent activity';

  @override
  String get refreshActivity => 'Refresh activity';

  @override
  String get unableToLoadRecentActivity => 'Unable to load recent activity';

  @override
  String get noRecentActivity => 'No recent activity yet.';

  @override
  String get activity => 'Activity';

  @override
  String get scheduleAddedActivity => 'Schedule added';

  @override
  String get scheduleCompletedActivity => 'Schedule completed';

  @override
  String get scheduleDeletedActivity => 'Schedule deleted';

  @override
  String get focusCompletedActivity => 'Focus session completed';

  @override
  String get badgeUnlockedActivity => 'Badge unlocked';

  @override
  String get membershipChangedActivity => 'Membership changed';

  @override
  String get levelUpActivity => 'Level increased';

  @override
  String get streakUpdatedActivity => 'Streak updated';

  @override
  String get justNow => 'Just now';

  @override
  String get yesterday => 'Yesterday';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get fullName => 'Full name';

  @override
  String get bio => 'Bio';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get unableToUpdateProfile => 'Unable to update profile';

  @override
  String get livePreview => 'Live Preview';

  @override
  String get primary => 'Primary';

  @override
  String get secondary => 'Secondary';

  @override
  String get primaryButtonPreview => 'Primary button preview';

  @override
  String get secondaryButtonPreview => 'Secondary button preview';

  @override
  String get accentColorPreviewDescription => 'This is how your selected accent colour will appear on buttons, icons, borders and selected controls throughout the app.';

  @override
  String get themeColorDescription => 'Choose your accent color. Changes apply across the entire app instantly.';

  @override
  String get purple => 'Purple';

  @override
  String get ocean => 'Ocean';

  @override
  String get sunset => 'Sunset';

  @override
  String get forest => 'Forest';

  @override
  String get rose => 'Rose';

  @override
  String get gold => 'Gold';

  @override
  String themeApplied(String themeName) {
    return '$themeName theme applied';
  }

  @override
  String get unableToSaveThemeColor => 'Unable to save theme color';

  @override
  String get saving => 'Saving...';

  @override
  String get saveSettings => 'Save settings';

  @override
  String get enableSleepMode => 'Enable Sleep Mode';

  @override
  String get sleepModeActive => 'Sleep Mode is active';

  @override
  String get sleepModeOff => 'Sleep Mode is turned off';

  @override
  String get sleepSchedule => 'Sleep Schedule';

  @override
  String get sleepScheduleDescription => 'Set your bedtime and wake-up time to maintain a consistent sleep routine.';

  @override
  String get bedtime => 'Bedtime';

  @override
  String get wakeUpTime => 'Wake-up Time';

  @override
  String get selectBedtime => 'Select bedtime';

  @override
  String get selectWakeUpTime => 'Select wake-up time';

  @override
  String get sleepModeSettingsSaved => 'Sleep Mode settings saved.';

  @override
  String get unableToLoadSleepModeSettings => 'Unable to load Sleep Mode settings.';

  @override
  String get unableToSaveSleepModeSettings => 'Unable to save Sleep Mode settings.';

  @override
  String get ok => 'OK';

  @override
  String get blockedApps => 'Blocked Apps';

  @override
  String get unableToLoadFocusModeSettings => 'Unable to load Focus Mode settings.';

  @override
  String get unableToSaveFocusModeSettings => 'Unable to save Focus Mode settings.';

  @override
  String get breakInterval => 'Break Interval';

  @override
  String get start => 'Start';

  @override
  String get end => 'End';

  @override
  String get selectDndStartTime => 'Select Do Not Disturb start time';

  @override
  String get selectDndEndTime => 'Select Do Not Disturb end time';

  @override
  String get focusModeDescription => 'Block distracting apps while working';

  @override
  String get emailVerification => 'Email Verification';

  @override
  String get emailVerificationEnabled => 'Email verification enabled';

  @override
  String get emailVerified => 'Your email has been verified.';

  @override
  String verificationEnabledFor(String email) {
    return 'Verification is enabled for $email.';
  }

  @override
  String get disableEmailVerification => 'Disable Email Verification';

  @override
  String get disabling => 'Disabling...';

  @override
  String get verifyYourEmail => 'Verify your email';

  @override
  String get verificationCodeWillBeSent => 'A verification code will be sent to your email.';

  @override
  String sixDigitCodeWillBeSentTo(String email) {
    return 'We will send a six-digit code to $email.';
  }

  @override
  String get sending => 'Sending...';

  @override
  String get sendCode => 'Send Code';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get sixDigitVerificationCode => 'Six-digit verification code';

  @override
  String get verifyAndEnable => 'Verify and Enable';

  @override
  String get sessionExpiredLoginAgain => 'Your session has expired. Please log in again.';

  @override
  String get noEmailConnected => 'No email address is connected to your account.';

  @override
  String get verificationCodeSent => 'A verification code was sent. Use only the newest code.';

  @override
  String get waitBeforeRequestingCode => 'Please wait about 60 seconds before requesting another code.';

  @override
  String get sendVerificationCodeFirst => 'Please send a verification code first.';

  @override
  String get enterCompleteSixDigitCode => 'Please enter the complete six-digit code.';

  @override
  String get verificationCodeExpired => 'The code is invalid or expired. Press Send Code and use the newest email.';

  @override
  String get verificationCodeIncorrect => 'The verification code is incorrect. Check the newest email.';

  @override
  String get verificationCodeNotConfirmed => 'The verification code could not be confirmed.';

  @override
  String get verifiedEmailMismatch => 'The verified email does not match the current account.';

  @override
  String get unableToLoadEmailVerificationSettings => 'Unable to load email verification settings.';

  @override
  String get unableToSendVerificationCode => 'Unable to send the verification code.';

  @override
  String get unableToVerifyVerificationCode => 'Unable to verify the verification code.';

  @override
  String get unableToDisableEmailVerification => 'Unable to disable email verification.';

  @override
  String get unableToLoadSecuritySettings => 'Unable to load security settings.';

  @override
  String get faceIdLogin => 'Face ID Login';

  @override
  String get fingerprintLogin => 'Fingerprint Login';

  @override
  String get biometricLogin => 'Biometric Login';

  @override
  String get checkingAuthentication => 'Checking authentication...';

  @override
  String get faceIdLoginEnabled => 'Face ID login is enabled';

  @override
  String get unlockUsingFaceId => 'Unlock using Face ID';

  @override
  String get fingerprintLoginEnabled => 'Fingerprint login is enabled';

  @override
  String get unlockUsingFingerprint => 'Unlock using fingerprint';

  @override
  String get biometricUnavailable => 'Face ID or fingerprint is unavailable';

  @override
  String get faceIdOrFingerprint => 'Face ID / Fingerprint';

  @override
  String get faceId => 'Face ID';

  @override
  String get fingerprint => 'Fingerprint';

  @override
  String get biometric => 'Biometric';

  @override
  String get twoFactorAuth => 'Two-Factor Auth';

  @override
  String get openingEmailVerification => 'Opening email verification...';

  @override
  String get verifyUsingEmailOtp => 'Verify using email OTP';

  @override
  String get emailVerificationEnabledSuccessfully => 'Email verification enabled successfully.';

  @override
  String get emailVerificationDisabled => 'Email verification disabled.';

  @override
  String get unableToOpenEmailVerification => 'Unable to open email verification.';

  @override
  String get enterCurrentPassword => 'Please enter your current password.';

  @override
  String get enterNewPassword => 'Please enter a new password.';

  @override
  String get newPasswordMustBeDifferent => 'The new password must be different from your current password.';

  @override
  String get currentPasswordIncorrect => 'Your current password is incorrect.';

  @override
  String get unableToUpdatePassword => 'Unable to update your password. Please try again.';

  @override
  String biometricLoginDisabled(String authenticationName) {
    return '$authenticationName login disabled.';
  }

  @override
  String biometricLoginEnabled(String authenticationName) {
    return '$authenticationName login enabled successfully.';
  }

  @override
  String get sessionExpiredBeforeBiometric => 'Your session has expired. Please log in again before enabling biometric login.';

  @override
  String get configureBiometricsFirst => 'Face ID or fingerprint is not available. Configure biometrics in your device settings first.';

  @override
  String get noBiometricAuthenticationEnrolled => 'No biometric authentication is enrolled. Configure Face ID, Touch ID, or fingerprint in your device settings.';

  @override
  String get biometricVerificationFailed => 'Biometric verification was not successful.';

  @override
  String get unableToUpdateBiometricLogin => 'Unable to update biometric login.';

  @override
  String get activityLog => 'Activity Log';

  @override
  String get viewAccountActivity => 'View your account activity';

  @override
  String get activityTrackingDisabled => 'Activity tracking is disabled';

  @override
  String get activityLogEnabledMessage => 'Activity log enabled.';

  @override
  String get activityLogDisabledMessage => 'Activity log disabled.';

  @override
  String get unableToUpdateActivityLog => 'Unable to update activity log.';

  @override
  String get dataSharing => 'Data Sharing';

  @override
  String get analyticsSharingEnabled => 'Analytics sharing is enabled';

  @override
  String get shareAnalyticsWithUs => 'Share analytics with us';

  @override
  String get dataSharingEnabledMessage => 'Data sharing enabled.';

  @override
  String get dataSharingDisabledMessage => 'Data sharing disabled.';

  @override
  String get unableToUpdateDataSharing => 'Unable to update data sharing.';

  @override
  String get changePassword => 'Change Password';

  @override
  String get updateLoginPassword => 'Update your login password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get updatePassword => 'Update Password';

  @override
  String get weakPassword => 'Weak Password';

  @override
  String get mediumPassword => 'Medium Password';

  @override
  String get strongPassword => 'Strong Password';

  @override
  String get passwordUpdateServiceNotConnected => 'Password update service is not connected.';

  @override
  String get passwordUpdatedSuccessfully => 'Password updated successfully';

  @override
  String get clearActivityLog => 'Clear activity log';

  @override
  String get clearActivityLogQuestion => 'Clear activity log?';

  @override
  String get allActivityRecordsDeleted => 'All activity records will be deleted.';

  @override
  String get clear => 'Clear';

  @override
  String get activityLogCleared => 'Activity log cleared.';

  @override
  String get unableToLoadActivityLog => 'Unable to load activity log.';

  @override
  String get unableToClearActivityLog => 'Unable to clear activity log.';

  @override
  String get noActivityRecordedYet => 'No activity recorded yet.';

  @override
  String get back => 'Back';

  @override
  String get pleaseLogInToViewNotifications => 'Please log in to view notifications.';

  @override
  String get unableToLoadNotifications => 'Unable to load notifications.';

  @override
  String get unableToMarkNotificationAsRead => 'Unable to mark notification as read';

  @override
  String get unableToMarkNotificationAsUnread => 'Unable to mark notification as unread';

  @override
  String get allNotificationsMarkedAsRead => 'All notifications marked as read.';

  @override
  String get unableToMarkAllAsRead => 'Unable to mark all as read';

  @override
  String get notificationDeleted => 'Notification deleted.';

  @override
  String get unableToDeleteNotification => 'Unable to delete notification';

  @override
  String get deleteAllNotificationsQuestion => 'Delete all notifications?';

  @override
  String get deleteAllNotificationsDescription => 'This will permanently remove all notifications from your inbox.';

  @override
  String get deleteAll => 'Delete all';

  @override
  String get allNotificationsDeleted => 'All notifications deleted.';

  @override
  String get unableToDeleteAllNotifications => 'Unable to delete all notifications';

  @override
  String get markAsUnread => 'Mark as unread';

  @override
  String get markAsRead => 'Mark as read';

  @override
  String get deleteNotification => 'Delete notification';

  @override
  String todayWithTime(String time) {
    return 'Today • $time';
  }

  @override
  String yesterdayWithTime(String time) {
    return 'Yesterday • $time';
  }

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get refresh => 'Refresh';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get notificationInboxEmptyDescription => 'Your schedule reminders and task updates will appear here.';

  @override
  String get notification => 'Notification';

  @override
  String get moreOptions => 'More options';

  @override
  String get notificationChannels => 'CHANNELS';

  @override
  String get notificationAlerts => 'ALERTS';

  @override
  String get notificationDisplay => 'DISPLAY';

  @override
  String get couldNotLoadNotificationSettings => 'Could not load notification settings.';

  @override
  String get couldNotSaveNotificationSetting => 'Could not save notification setting.';

  @override
  String get pushNotifications => 'Push Notifications';

  @override
  String get emailNotifications => 'Email Notifications';

  @override
  String get scheduleReminders => 'Schedule Reminders';

  @override
  String get breakAlerts => 'Break Alerts';

  @override
  String get achievements => 'Achievements';

  @override
  String get weeklyReport => 'Weekly Report';

  @override
  String get notificationSounds => 'Notification Sounds';

  @override
  String get appBadges => 'App Badges';

  @override
  String get realTimeAlertsOnYourDevice => 'Real-time alerts on your device';

  @override
  String get digestToYourInbox => 'Digest to your inbox';

  @override
  String get beforeEventsStart => 'Before events start';

  @override
  String get remindToTakeBreaks => 'Remind to take breaks';

  @override
  String get badgesAndMilestones => 'Badges & milestones';

  @override
  String get sundaySummaryEmail => 'Sunday summary email';

  @override
  String get audioForAlerts => 'Audio for alerts';

  @override
  String get unreadCountOnIcon => 'Unread count on icon';
}
