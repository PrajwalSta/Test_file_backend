// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'फोकस ग्लो';

  @override
  String get home => 'होम';

  @override
  String get schedule => 'शेड्यूल';

  @override
  String get statistics => 'आंकड़े';

  @override
  String get clocks => 'घड़ियां';

  @override
  String get settings => 'सेटिंग';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get themeColor => 'थीम रंग';

  @override
  String get language => 'भाषा';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get privacyAndSecurity => 'गोपनीयता और सुरक्षा';

  @override
  String get focusAndDnd => 'फोकस और डू नॉट डिस्टर्ब';

  @override
  String get sleepMode => 'स्लीप मोड';

  @override
  String get save => 'सेव करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get add => 'जोड़ें';

  @override
  String get tryAgain => 'फिर प्रयास करें';

  @override
  String get english => 'अंग्रेजी';

  @override
  String get nepali => 'नेपाली';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get languageChanged => 'भाषा सफलतापूर्वक बदल दी गई';

  @override
  String get goodMorning => 'सुप्रभात';

  @override
  String get goodAfternoon => 'शुभ दोपहर';

  @override
  String get goodEvening => 'शुभ संध्या';

  @override
  String get project => 'प्रोजेक्ट';

  @override
  String get todaysProgress => 'आज की प्रगति';

  @override
  String tasksCompleted(int completed, int total) {
    return '$total में से $completed कार्य पूरे हुए';
  }

  @override
  String get focusTime => 'फोकस समय';

  @override
  String get tasksDone => 'पूर्ण कार्य';

  @override
  String get todaysSchedule => 'आज का शेड्यूल';

  @override
  String get today => 'आज';

  @override
  String get tomorrow => 'कल';

  @override
  String get untitled => 'बिना शीर्षक';

  @override
  String get studyMode => 'स्टडी मोड';

  @override
  String get off => 'बंद';

  @override
  String get sleeping => 'सो रहे हैं';

  @override
  String get pleaseLoginToViewSchedules => 'शेड्यूल देखने के लिए कृपया लॉग इन करें।';

  @override
  String get unableToLoadSchedules => 'शेड्यूल लोड नहीं किया जा सका।';

  @override
  String get scheduleIdMissing => 'शेड्यूल डेटाबेस आईडी उपलब्ध नहीं है।';

  @override
  String get loginBeforeUpdating => 'अपडेट करने से पहले कृपया लॉग इन करें।';

  @override
  String get loginBeforeDeleting => 'हटाने से पहले कृपया लॉग इन करें।';

  @override
  String databaseError(String message) {
    return 'डेटाबेस त्रुटि: $message';
  }

  @override
  String scheduleAddedSuccessfully(String title) {
    return '$title सफलतापूर्वक जोड़ा गया';
  }

  @override
  String taskCompleted(String title) {
    return '$title पूरा हुआ';
  }

  @override
  String taskMarkedIncomplete(String title) {
    return '$title अपूर्ण के रूप में चिह्नित किया गया';
  }

  @override
  String updateFailed(String message) {
    return 'अपडेट विफल: $message';
  }

  @override
  String deleteFailed(String message) {
    return 'हटाना विफल: $message';
  }

  @override
  String get unableToUpdateSchedule => 'शेड्यूल अपडेट नहीं किया जा सका।';

  @override
  String get unableToDeleteSchedule => 'शेड्यूल हटाया नहीं जा सका।';

  @override
  String scheduleDeletedSuccessfully(String title) {
    return '$title सफलतापूर्वक हटाया गया';
  }

  @override
  String scheduleSelected(String title) {
    return '$title चुना गया';
  }

  @override
  String get taskCompletedNotificationTitle => '🎉 कार्य पूरा हुआ';

  @override
  String taskCompletedNotificationBody(String title) {
    return '$title सफलतापूर्वक पूरा हो गया।';
  }

  @override
  String get scheduleCancelledNotificationTitle => 'शेड्यूल रद्द किया गया';

  @override
  String scheduleCancelledNotificationBody(String title) {
    return '$title आपके शेड्यूल से हटा दिया गया है।';
  }
}
