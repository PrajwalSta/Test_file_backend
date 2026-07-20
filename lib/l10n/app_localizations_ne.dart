// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Nepali (`ne`).
class AppLocalizationsNe extends AppLocalizations {
  AppLocalizationsNe([String locale = 'ne']) : super(locale);

  @override
  String get appName => 'फोकस ग्लो';

  @override
  String get home => 'गृह';

  @override
  String get schedule => 'तालिका';

  @override
  String get statistics => 'तथ्याङ्क';

  @override
  String get clocks => 'घडीहरू';

  @override
  String get settings => 'सेटिङ';

  @override
  String get notifications => 'सूचनाहरू';

  @override
  String get themeColor => 'थिम रङ';

  @override
  String get language => 'भाषा';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get privacyAndSecurity => 'गोपनीयता र सुरक्षा';

  @override
  String get focusAndDnd => 'फोकस र डु नट डिस्टर्ब';

  @override
  String get sleepMode => 'निद्रा मोड';

  @override
  String get save => 'सेभ गर्नुहोस्';

  @override
  String get cancel => 'रद्द गर्नुहोस्';

  @override
  String get delete => 'मेटाउनुहोस्';

  @override
  String get add => 'थप्नुहोस्';

  @override
  String get tryAgain => 'फेरि प्रयास गर्नुहोस्';

  @override
  String get english => 'अङ्ग्रेजी';

  @override
  String get nepali => 'नेपाली';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get selectLanguage => 'भाषा चयन गर्नुहोस्';

  @override
  String get languageChanged => 'भाषा सफलतापूर्वक परिवर्तन भयो';

  @override
  String get goodMorning => 'शुभ प्रभात';

  @override
  String get goodAfternoon => 'शुभ दिउँसो';

  @override
  String get goodEvening => 'शुभ साँझ';

  @override
  String get project => 'परियोजना';

  @override
  String get todaysProgress => 'आजको प्रगति';

  @override
  String tasksCompleted(int completed, int total) {
    return '$total मध्ये $completed कार्य पूरा भयो';
  }

  @override
  String get focusTime => 'फोकस समय';

  @override
  String get tasksDone => 'पूरा भएका कार्य';

  @override
  String get todaysSchedule => 'आजको तालिका';

  @override
  String get today => 'आज';

  @override
  String get tomorrow => 'भोलि';

  @override
  String get untitled => 'शीर्षक छैन';

  @override
  String get studyMode => 'अध्ययन मोड';

  @override
  String get off => 'बन्द';

  @override
  String get sleeping => 'सुतिरहेको';

  @override
  String get pleaseLoginToViewSchedules => 'तालिका हेर्न कृपया लगइन गर्नुहोस्।';

  @override
  String get unableToLoadSchedules => 'तालिका लोड गर्न सकिएन।';

  @override
  String get scheduleIdMissing => 'तालिकाको डेटाबेस आईडी उपलब्ध छैन।';

  @override
  String get loginBeforeUpdating => 'अपडेट गर्नुअघि कृपया लगइन गर्नुहोस्।';

  @override
  String get loginBeforeDeleting => 'मेटाउनुअघि कृपया लगइन गर्नुहोस्।';

  @override
  String databaseError(String message) {
    return 'डाटाबेस त्रुटि: $message';
  }

  @override
  String scheduleAddedSuccessfully(String title) {
    return '$title सफलतापूर्वक थपियो';
  }

  @override
  String taskCompleted(String title) {
    return '$title पूरा भयो';
  }

  @override
  String taskMarkedIncomplete(String title) {
    return '$title अपूर्णको रूपमा चिन्ह लगाइयो';
  }

  @override
  String updateFailed(String message) {
    return 'अपडेट असफल: $message';
  }

  @override
  String deleteFailed(String message) {
    return 'मेटाउन असफल: $message';
  }

  @override
  String get unableToUpdateSchedule => 'तालिका अपडेट गर्न सकिएन।';

  @override
  String get unableToDeleteSchedule => 'तालिका मेटाउन सकिएन।';

  @override
  String scheduleDeletedSuccessfully(String title) {
    return '$title सफलतापूर्वक मेटाइयो';
  }

  @override
  String scheduleSelected(String title) {
    return '$title चयन गरियो';
  }

  @override
  String get taskCompletedNotificationTitle => '🎉 कार्य पूरा भयो';

  @override
  String taskCompletedNotificationBody(String title) {
    return '$title सफलतापूर्वक पूरा भयो।';
  }

  @override
  String get scheduleCancelledNotificationTitle => 'तालिका रद्द गरियो';

  @override
  String scheduleCancelledNotificationBody(String title) {
    return '$title तपाईंको तालिकाबाट हटाइएको छ।';
  }
}
