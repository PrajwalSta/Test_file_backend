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
  String get close => 'बन्द गर्नुहोस्';

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
  String get todaysSchedule => 'आजको तालिका';

  @override
  String get today => 'आज';

  @override
  String get tomorrow => 'भोलि';

  @override
  String get monday => 'सोमबार';

  @override
  String get tuesday => 'मङ्गलबार';

  @override
  String get wednesday => 'बुधबार';

  @override
  String get thursday => 'बिहीबार';

  @override
  String get friday => 'शुक्रबार';

  @override
  String get saturday => 'शनिबार';

  @override
  String get sunday => 'आइतबार';

  @override
  String get totalFocusTime => 'कुल फोकस समय';

  @override
  String get focusTime => 'फोकस समय';

  @override
  String get focusHours => 'फोकस घण्टा';

  @override
  String get tasksDone => 'सम्पन्न कार्यहरू';

  @override
  String get totalTasks => 'कुल कार्यहरू';

  @override
  String get completed => 'सम्पन्न';

  @override
  String get completedTasksTitle => 'सम्पन्न कार्यहरू';

  @override
  String get completionRate => 'सम्पन्न दर';

  @override
  String get dailyFocusHours => 'दैनिक फोकस घण्टा';

  @override
  String get byCategory => 'श्रेणीअनुसार';

  @override
  String get monthlyFocus => 'मासिक फोकस';

  @override
  String get productivityInsights => 'तपाईंको उत्पादकता विवरण';

  @override
  String get profileSection => 'प्रोफाइल';

  @override
  String get preferencesSection => 'प्राथमिकताहरू';

  @override
  String get focusModesSection => 'फोकस मोडहरू';

  @override
  String get profileSubtitle => 'नाम, फोटो र परिचय';

  @override
  String get privacySubtitle => 'पासवर्ड, 2FA र बायोमेट्रिक्स';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get darkModeOn => 'चालु — डार्क इन्टरफेस';

  @override
  String get darkModeOff => 'बन्द — लाइट इन्टरफेस';

  @override
  String get notificationsSubtitle => 'पुश, इमेल र रिमाइन्डर';

  @override
  String get themeColorSubtitle => 'एपको रङ योजना परिवर्तन गर्नुहोस्';

  @override
  String get focusMode => 'फोकस मोड';

  @override
  String get focusModeSubtitle => 'ब्लक गरिएका एप र विश्राम अन्तराल';

  @override
  String get sleepModeSubtitle => 'सुत्ने र उठ्ने समय';

  @override
  String get doNotDisturb => 'डु नट डिस्टर्ब';

  @override
  String get loadingSettings => 'सेटिङ लोड हुँदैछ...';

  @override
  String get on => 'चालु';

  @override
  String get off => 'बन्द';

  @override
  String get am => 'बिहान';

  @override
  String get pm => 'साँझ';

  @override
  String get dndEnabled => 'डु नट डिस्टर्ब चालु गरियो';

  @override
  String get dndDisabled => 'डु नट डिस्टर्ब बन्द गरियो';

  @override
  String tasksCompleted(int completed, int total) {
    return '$total मध्ये $completed कार्य पूरा भयो';
  }

  @override
  String get pleaseLoginToViewStatistics => 'तथ्याङ्क हेर्न कृपया लगइन गर्नुहोस्।';

  @override
  String get unableToLoadStatistics => 'तथ्याङ्क लोड गर्न सकिएन।';

  @override
  String get untitled => 'शीर्षक छैन';

  @override
  String get studyMode => 'अध्ययन मोड';

  @override
  String get workMode => 'काम मोड';

  @override
  String get sleeping => 'सुतिरहेको';

  @override
  String get loginToViewSchedules => 'तालिका हेर्न कृपया लगइन गर्नुहोस्।';

  @override
  String get pleaseLoginToViewSchedules => 'तालिका हेर्न कृपया लगइन गर्नुहोस्।';

  @override
  String get unableToLoadSchedules => 'तालिका लोड गर्न सकिएन।';

  @override
  String databaseError(Object message) {
    return 'डाटाबेस त्रुटि: $message';
  }

  @override
  String get scheduleAdded => 'तालिका थपियो';

  @override
  String scheduleAddedBody(Object title) {
    return '\"$title\" तपाईंको तालिकामा थपियो।';
  }

  @override
  String scheduleAddedSuccessfully(String title) {
    return 'तालिका सफलतापूर्वक थपियो: $title';
  }

  @override
  String get scheduleIdMissing => 'तालिकाको डाटाबेस ID उपलब्ध छैन।';

  @override
  String get loginBeforeUpdating => 'अपडेट गर्नुअघि कृपया लगइन गर्नुहोस्।';

  @override
  String get loginBeforeUpdatingSchedule => 'तालिका अपडेट गर्नुअघि कृपया लगइन गर्नुहोस्।';

  @override
  String get loginBeforeDeleting => 'मेटाउनुअघि कृपया लगइन गर्नुहोस्।';

  @override
  String get loginBeforeDeletingSchedule => 'तालिका मेटाउनुअघि कृपया लगइन गर्नुहोस्।';

  @override
  String taskCompleted(String title) {
    return '$title पूरा भयो';
  }

  @override
  String get taskReopened => 'कार्य पुनः खोलियो';

  @override
  String taskReopenedBody(String title) {
    return '\"$title\" लाई अपूर्णको रूपमा चिन्ह लगाइयो।';
  }

  @override
  String taskMarkedCompleted(String title, int count) {
    return '\"$title\" कार्य सम्पन्न भयो। सम्पन्न कार्य: $count';
  }

  @override
  String taskMarkedIncomplete(String title, int count) {
    return '\"$title\" कार्य अपूर्णको रूपमा चिन्ह लगाइयो। सम्पन्न कार्य: $count';
  }

  @override
  String updateFailed(String message) {
    return 'अपडेट असफल भयो: $message';
  }

  @override
  String unableToUpdateSchedule(String message) {
    return 'तालिका अपडेट गर्न सकिएन: $message';
  }

  @override
  String deleteFailed(String message) {
    return 'मेटाउन असफल भयो: $message';
  }

  @override
  String unableToDeleteSchedule(String message) {
    return 'तालिका मेटाउन सकिएन: $message';
  }

  @override
  String scheduleDeletedSuccessfully(String title) {
    return 'तालिका सफलतापूर्वक मेटाइयो: $title';
  }

  @override
  String scheduleSelected(String title) {
    return 'चयन गरिएको तालिका: $title';
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

  @override
  String unableToLoadDndSettings(String message) {
    return 'डु नट डिस्टर्ब सेटिङ लोड गर्न सकिएन: $message';
  }

  @override
  String unableToUpdateDnd(String message) {
    return 'डु नट डिस्टर्ब अपडेट गर्न सकिएन: $message';
  }

  @override
  String get sleepModeSettingsUpdated => 'निद्रा मोड सेटिङ अपडेट भयो';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get signOutConfirmation => 'के तपाईं साइन आउट गर्न निश्चित हुनुहुन्छ?';

  @override
  String signOutFailed(String message) {
    return 'साइन आउट असफल भयो: $message';
  }

  @override
  String pageTitle(String title) {
    return '$title पृष्ठ';
  }

  @override
  String get addSchedule => 'तालिका थप्नुहोस्';

  @override
  String get orAddManually => 'वा म्यानुअल रूपमा थप्नुहोस्';

  @override
  String get title => 'शीर्षक';

  @override
  String get category => 'श्रेणी';

  @override
  String get date => 'मिति';

  @override
  String get startTime => 'सुरु हुने समय';

  @override
  String get durationMinutes => 'अवधि (मिनेट)';

  @override
  String get csvTemplateReady => 'CSV टेम्प्लेट तयार छ।';

  @override
  String unableToPrepareTemplate(String message) {
    return 'टेम्प्लेट तयार गर्न सकिएन: $message';
  }

  @override
  String get loginBeforeImportingSchedules => 'तालिकाहरू आयात गर्नुअघि कृपया लगइन गर्नुहोस्।';

  @override
  String get noSchedulesImported => 'कुनै तालिका आयात भएन।';

  @override
  String unableToImportCsv(String message) {
    return 'CSV फाइल आयात गर्न सकिएन: $message';
  }

  @override
  String get importSchedulesQuestion => 'तालिकाहरू आयात गर्ने?';

  @override
  String get importProblems => 'आयातसम्बन्धी समस्याहरू';

  @override
  String get noValidSchedulesFound => 'कुनै मान्य तालिका फेला परेन।';

  @override
  String validSchedulesFound(int count) {
    return '$count वटा मान्य तालिका फेला परे।';
  }

  @override
  String rowsWillBeSkipped(int count) {
    return '$count वटा पङ्क्ति छोडिनेछन्।';
  }

  @override
  String minutesShort(int count) {
    return '$count मिनेट';
  }

  @override
  String andMore(int count) {
    return 'र थप $count वटा।';
  }

  @override
  String importCount(int count) {
    return '$count आयात गर्नुहोस्';
  }

  @override
  String get unknownCategory => 'अज्ञात श्रेणी।';

  @override
  String unknownCategoryAtRow(int row, String category) {
    return 'पङ्क्ति $row: अज्ञात श्रेणी \"$category\"।';
  }

  @override
  String rowError(int row, String message) {
    return 'पङ्क्ति $row: $message';
  }

  @override
  String schedulesImportedSuccessfully(int count) {
    return '$count वटा तालिका सफलतापूर्वक आयात भए।';
  }

  @override
  String schedulesImportedWithSkipped(int count, int skipped) {
    return '$count वटा तालिका सफलतापूर्वक आयात भए, $skipped वटा छोडिए।';
  }

  @override
  String get enterScheduleTitle => 'कृपया तालिकाको शीर्षक प्रविष्ट गर्नुहोस्।';

  @override
  String get enterValidDuration => 'कृपया मान्य अवधि प्रविष्ट गर्नुहोस्।';

  @override
  String get loginBeforeSavingSchedule => 'तालिका सेभ गर्नुअघि कृपया लगइन गर्नुहोस्।';

  @override
  String get selectFutureDateTime => 'कृपया भविष्यको मिति र समय चयन गर्नुहोस्।';

  @override
  String get scheduleIdNotReturned => 'तालिका ID फिर्ता आएन।';

  @override
  String unableToSaveSchedule(String message) {
    return 'तालिका सेभ गर्न सकिएन: $message';
  }

  @override
  String get noSchedulesAvailable => 'कुनै तालिका उपलब्ध छैन';

  @override
  String get all => 'सबै';

  @override
  String get work => 'काम';

  @override
  String get study => 'अध्ययन';

  @override
  String get health => 'स्वास्थ्य';

  @override
  String get personal => 'व्यक्तिगत';

  @override
  String get social => 'सामाजिक';

  @override
  String get exercise => 'व्यायाम';

  @override
  String get durationRequired => 'अवधि प्रविष्ट गर्नु आवश्यक छ';

  @override
  String get enterValidNumber => 'मान्य संख्या प्रविष्ट गर्नुहोस्';

  @override
  String minimumDuration(int minutes) {
    return 'न्यूनतम अवधि $minutes मिनेट हो';
  }

  @override
  String maximumDuration(int minutes) {
    return 'अधिकतम अवधि $minutes मिनेट हो';
  }

  @override
  String get deleteSchedule => 'तालिका मेटाउनुहोस्';

  @override
  String get deepWork => 'गहन काम';

  @override
  String get readingMode => 'पढाइ मोड';

  @override
  String get exerciseMode => 'व्यायाम मोड';

  @override
  String get noFocusMode => 'फोकस मोड छैन';

  @override
  String get custom => 'अनुकूलित';

  @override
  String get user => 'प्रयोगकर्ता';

  @override
  String notificationsUnread(int count) {
    return '$count अपठित सूचनाहरू';
  }

  @override
  String get noSchedulesForToday => 'आजका लागि कुनै तालिका छैन';

  @override
  String get pressAddToCreateSchedule => 'तालिका बनाउन थप्नुहोस् थिच्नुहोस्।';

  @override
  String get scheduleUpdateFailed => 'तालिका अद्यावधिक भएन। कृपया RLS नीति जाँच गर्नुहोस्।';

  @override
  String get scheduleDeleteFailed => 'तालिका मेटिएन। कृपया RLS नीति जाँच गर्नुहोस्।';

  @override
  String get importSchedule => 'तालिका आयात गर्नुहोस्';

  @override
  String get uploadCsvDescription => 'एकैपटक धेरै तालिका थप्न CSV फाइल अपलोड गर्नुहोस्।';

  @override
  String selectedFile(String fileName) {
    return 'चयन गरिएको: $fileName';
  }

  @override
  String get preparingTemplate => 'टेम्प्लेट तयार हुँदैछ...';

  @override
  String get downloadTemplate => 'टेम्प्लेट डाउनलोड गर्नुहोस्';

  @override
  String get uploadFile => 'फाइल अपलोड गर्नुहोस्';

  @override
  String get scheduleTitleRequired => 'कृपया तालिकाको शीर्षक लेख्नुहोस्';

  @override
  String minimumTitleLength(int count) {
    return 'शीर्षकमा कम्तीमा $count अक्षर हुनुपर्छ';
  }

  @override
  String get scheduleTitleHint => 'जस्तै: गहन कार्य सत्र';

  @override
  String get durationHint => '६०';

  @override
  String get saveSchedule => 'तालिका सेभ गर्नुहोस्';

  @override
  String get noData => 'कुनै डाटा छैन';

  @override
  String get noFocusDataYet => 'अहिलेसम्म कुनै फोकस डाटा छैन';

  @override
  String get mon => 'सोम';

  @override
  String get tue => 'मङ्गल';

  @override
  String get wed => 'बुध';

  @override
  String get thu => 'बिही';

  @override
  String get fri => 'शुक्र';

  @override
  String get sat => 'शनि';

  @override
  String get sun => 'आइत';

  @override
  String get jan => 'जन';

  @override
  String get feb => 'फेब';

  @override
  String get mar => 'मार्च';

  @override
  String get apr => 'अप्रिल';

  @override
  String get may => 'मे';

  @override
  String get jun => 'जुन';

  @override
  String get jul => 'जुलाई';

  @override
  String get aug => 'अग';

  @override
  String get sep => 'सेप';

  @override
  String get oct => 'अक्टो';

  @override
  String get nov => 'नोभ';

  @override
  String get dec => 'डिस';

  @override
  String get taskDone => 'कार्य पूरा';

  @override
  String get tasksDonePlural => 'कार्यहरू पूरा';

  @override
  String get hoursShort => 'घण्टा';

  @override
  String get minutesAbbreviation => 'मि';

  @override
  String get addWorldClock => 'विश्व घडी थप्नुहोस्';

  @override
  String get worldClocks => 'विश्व घडीहरू';

  @override
  String get searchCityCountryTimezone => 'सहर, देश वा समय क्षेत्र खोज्नुहोस्';

  @override
  String get clearSearch => 'खोज खाली गर्नुहोस्';

  @override
  String get noCityFound => 'कुनै सहर भेटिएन';

  @override
  String get tryAnotherCityCountryTimezone => 'अर्को सहर, देश वा समय क्षेत्र खोज्नुहोस्।';

  @override
  String get isAlreadyAdded => 'पहिले नै थपिएको छ';

  @override
  String get added => 'थपियो';

  @override
  String get removed => 'हटाइयो';

  @override
  String get unableToLoadWorldClocks => 'विश्व घडीहरू लोड गर्न सकिएन';

  @override
  String get unableToAddClock => 'घडी थप्न सकिएन';

  @override
  String get unableToRemoveClock => 'घडी हटाउन सकिएन';

  @override
  String get thisClockCannotBeDeleted => 'यो घडी मेटाउन सकिँदैन।';

  @override
  String get deleteClock => 'घडी मेटाउने?';

  @override
  String get fromYourWorldClocks => 'लाई तपाईंको विश्व घडीबाट मेटाउने?';

  @override
  String get noWorldClocksAdded => 'कुनै विश्व घडी थपिएको छैन';

  @override
  String get tapPlusToAddCity => 'सहर खोज्न र थप्न + बटन थिच्नुहोस्।';

  @override
  String get searchCity => 'सहर खोज्नुहोस्';

  @override
  String get unableToLoadProfile => 'प्रोफाइल लोड गर्न सकिएन';

  @override
  String get profileUpdatedSuccessfully => 'प्रोफाइल सफलतापूर्वक अपडेट भयो';

  @override
  String get profileDataUnavailable => 'प्रोफाइल डाटा उपलब्ध छैन';

  @override
  String get citySydney => 'सिड्नी';

  @override
  String get cityMelbourne => 'मेलबर्न';

  @override
  String get cityBrisbane => 'ब्रिस्बेन';

  @override
  String get cityPerth => 'पर्थ';

  @override
  String get cityAdelaide => 'एडिलेड';

  @override
  String get cityDarwin => 'डार्विन';

  @override
  String get cityHobart => 'होबार्ट';

  @override
  String get cityKathmandu => 'काठमाडौं';

  @override
  String get cityPokhara => 'पोखरा';

  @override
  String get cityNewDelhi => 'नयाँ दिल्ली';

  @override
  String get cityMumbai => 'मुम्बई';

  @override
  String get cityBengaluru => 'बेङ्गलुरु';

  @override
  String get cityChennai => 'चेन्नई';

  @override
  String get cityTokyo => 'टोकियो';

  @override
  String get cityOsaka => 'ओसाका';

  @override
  String get citySeoul => 'सिओल';

  @override
  String get cityBeijing => 'बेइजिङ';

  @override
  String get cityShanghai => 'साङ्घाई';

  @override
  String get cityHongKong => 'हङकङ';

  @override
  String get citySingapore => 'सिङ्गापुर';

  @override
  String get cityBangkok => 'बैंकक';

  @override
  String get cityJakarta => 'जकार्ता';

  @override
  String get cityManila => 'मनिला';

  @override
  String get cityKualaLumpur => 'क्वालालम्पुर';

  @override
  String get cityDhaka => 'ढाका';

  @override
  String get cityKarachi => 'कराँची';

  @override
  String get cityColombo => 'कोलम्बो';

  @override
  String get cityDubai => 'दुबई';

  @override
  String get cityLondon => 'लन्डन';

  @override
  String get cityParis => 'पेरिस';

  @override
  String get cityBerlin => 'बर्लिन';

  @override
  String get cityRome => 'रोम';

  @override
  String get cityMadrid => 'म्याड्रिड';

  @override
  String get cityAmsterdam => 'एम्स्टर्डम';

  @override
  String get cityZurich => 'ज्युरिख';

  @override
  String get cityAthens => 'एथेन्स';

  @override
  String get cityIstanbul => 'इस्तानबुल';

  @override
  String get cityNewYork => 'न्युयोर्क';

  @override
  String get cityLosAngeles => 'लस एन्जलस';

  @override
  String get cityChicago => 'शिकागो';

  @override
  String get cityDenver => 'डेनभर';

  @override
  String get cityHonolulu => 'होनोलुलु';

  @override
  String get cityToronto => 'टोरोन्टो';

  @override
  String get cityVancouver => 'भ्यानकुभर';

  @override
  String get citySaoPaulo => 'साओ पाउलो';

  @override
  String get cityBuenosAires => 'ब्युनस आयर्स';

  @override
  String get cityCairo => 'काइरो';

  @override
  String get cityNairobi => 'नैरोबी';

  @override
  String get cityJohannesburg => 'जोहानेसबर्ग';

  @override
  String get cityAuckland => 'अकल्यान्ड';

  @override
  String get cityWellington => 'वेलिङ्टन';

  @override
  String get countryAustralia => 'अस्ट्रेलिया';

  @override
  String get countryNepal => 'नेपाल';

  @override
  String get countryIndia => 'भारत';

  @override
  String get countryJapan => 'जापान';

  @override
  String get countrySouthKorea => 'दक्षिण कोरिया';

  @override
  String get countryChina => 'चीन';

  @override
  String get countryHongKong => 'हङकङ';

  @override
  String get countrySingapore => 'सिङ्गापुर';

  @override
  String get countryThailand => 'थाइल्यान्ड';

  @override
  String get countryIndonesia => 'इन्डोनेसिया';

  @override
  String get countryPhilippines => 'फिलिपिन्स';

  @override
  String get countryMalaysia => 'मलेसिया';

  @override
  String get countryBangladesh => 'बङ्गलादेश';

  @override
  String get countryPakistan => 'पाकिस्तान';

  @override
  String get countrySriLanka => 'श्रीलङ्का';

  @override
  String get countryUnitedArabEmirates => 'संयुक्त अरब इमिरेट्स';

  @override
  String get countryUnitedKingdom => 'संयुक्त अधिराज्य';

  @override
  String get countryFrance => 'फ्रान्स';

  @override
  String get countryGermany => 'जर्मनी';

  @override
  String get countryItaly => 'इटाली';

  @override
  String get countrySpain => 'स्पेन';

  @override
  String get countryNetherlands => 'नेदरल्यान्ड्स';

  @override
  String get countrySwitzerland => 'स्विट्जरल्यान्ड';

  @override
  String get countryGreece => 'ग्रीस';

  @override
  String get countryTurkiye => 'टर्की';

  @override
  String get countryUnitedStates => 'संयुक्त राज्य अमेरिका';

  @override
  String get countryCanada => 'क्यानडा';

  @override
  String get countryBrazil => 'ब्राजिल';

  @override
  String get countryArgentina => 'अर्जेन्टिना';

  @override
  String get countryEgypt => 'इजिप्ट';

  @override
  String get countryKenya => 'केन्या';

  @override
  String get countrySouthAfrica => 'दक्षिण अफ्रिका';

  @override
  String get countryNewZealand => 'न्युजिल्यान्ड';

  @override
  String get editProfile => 'प्रोफाइल सम्पादन गर्नुहोस्';

  @override
  String get days => 'दिन';

  @override
  String get done => 'सम्पन्न';

  @override
  String get hours => 'घण्टा';

  @override
  String get membership => 'सदस्यता';

  @override
  String get projectUser => 'परियोजना प्रयोगकर्ता';

  @override
  String get defaultBio => 'राम्रो बानी विकासमा केन्द्रित ✨';

  @override
  String get member => 'सदस्य';

  @override
  String get level => 'स्तर';

  @override
  String get badges => 'ब्याजहरू';

  @override
  String get badge => 'ब्याज';

  @override
  String get earlyBird => 'बिहानी सक्रिय';

  @override
  String get nightOwl => 'राति सक्रिय';

  @override
  String get streakSeven => '७ दिनको निरन्तरता';

  @override
  String get focusOneHundredHours => '१०० घण्टा फोकस';

  @override
  String get plannerPro => 'योजना विशेषज्ञ';

  @override
  String get zenMaster => 'जेन मास्टर';

  @override
  String get unableToLoadBadges => 'ब्याजहरू लोड गर्न सकिएन';

  @override
  String badgesEarned(int earned, int total) {
    return '$total मध्ये $earned प्राप्त';
  }

  @override
  String get recentActivity => 'हालको गतिविधि';

  @override
  String get refreshActivity => 'गतिविधि पुनः लोड गर्नुहोस्';

  @override
  String get unableToLoadRecentActivity => 'हालको गतिविधि लोड गर्न सकिएन';

  @override
  String get noRecentActivity => 'अहिलेसम्म कुनै हालको गतिविधि छैन।';

  @override
  String get activity => 'गतिविधि';

  @override
  String get scheduleAddedActivity => 'तालिका थपियो';

  @override
  String get scheduleCompletedActivity => 'तालिका सम्पन्न भयो';

  @override
  String get scheduleDeletedActivity => 'तालिका मेटाइयो';

  @override
  String get focusCompletedActivity => 'फोकस सत्र सम्पन्न भयो';

  @override
  String get badgeUnlockedActivity => 'ब्याज प्राप्त भयो';

  @override
  String get membershipChangedActivity => 'सदस्यता परिवर्तन भयो';

  @override
  String get levelUpActivity => 'स्तर बढ्यो';

  @override
  String get streakUpdatedActivity => 'निरन्तरता अद्यावधिक भयो';

  @override
  String get justNow => 'भर्खरै';

  @override
  String get yesterday => 'हिजो';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनेटअघि',
      one: '१ मिनेटअघि',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घण्टाअघि',
      one: '१ घण्टाअघि',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिनअघि',
      one: '१ दिनअघि',
    );
    return '$_temp0';
  }

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get bio => 'परिचय';

  @override
  String get saveChanges => 'परिवर्तनहरू सेभ गर्नुहोस्';

  @override
  String get pleaseEnterYourName => 'कृपया आफ्नो नाम प्रविष्ट गर्नुहोस्';

  @override
  String get unableToUpdateProfile => 'प्रोफाइल अद्यावधिक गर्न सकिएन';

  @override
  String get livePreview => 'प्रत्यक्ष पूर्वावलोकन';

  @override
  String get primary => 'प्राथमिक';

  @override
  String get secondary => 'द्वितीयक';

  @override
  String get primaryButtonPreview => 'प्राथमिक बटनको पूर्वावलोकन';

  @override
  String get secondaryButtonPreview => 'द्वितीयक बटनको पूर्वावलोकन';

  @override
  String get accentColorPreviewDescription => 'तपाईंले चयन गर्नुभएको एक्सेन्ट रङ एपभरिका बटन, आइकन, बोर्डर र चयन गरिएका नियन्त्रणहरूमा यसरी देखिनेछ।';

  @override
  String get themeColorDescription => 'आफ्नो एक्सेन्ट रङ चयन गर्नुहोस्। परिवर्तनहरू तुरुन्तै सम्पूर्ण एपमा लागू हुनेछन्।';

  @override
  String get purple => 'बैजनी';

  @override
  String get ocean => 'महासागर';

  @override
  String get sunset => 'सूर्यास्त';

  @override
  String get forest => 'वन';

  @override
  String get rose => 'गुलाबी';

  @override
  String get gold => 'सुनौलो';

  @override
  String themeApplied(String themeName) {
    return '$themeName थिम लागू गरियो';
  }

  @override
  String get unableToSaveThemeColor => 'थिम रङ सेभ गर्न सकिएन';

  @override
  String get saving => 'सेभ हुँदैछ...';

  @override
  String get saveSettings => 'सेटिङहरू सेभ गर्नुहोस्';

  @override
  String get enableSleepMode => 'निद्रा मोड सक्षम गर्नुहोस्';

  @override
  String get sleepModeActive => 'निद्रा मोड सक्रिय छ';

  @override
  String get sleepModeOff => 'निद्रा मोड बन्द छ';

  @override
  String get sleepSchedule => 'निद्रा तालिका';

  @override
  String get sleepScheduleDescription => 'नियमित निद्रा दिनचर्या कायम राख्न आफ्नो सुत्ने र उठ्ने समय सेट गर्नुहोस्।';

  @override
  String get bedtime => 'सुत्ने समय';

  @override
  String get wakeUpTime => 'उठ्ने समय';

  @override
  String get selectBedtime => 'सुत्ने समय चयन गर्नुहोस्';

  @override
  String get selectWakeUpTime => 'उठ्ने समय चयन गर्नुहोस्';

  @override
  String get sleepModeSettingsSaved => 'निद्रा मोड सेटिङहरू सेभ गरियो।';

  @override
  String get unableToLoadSleepModeSettings => 'निद्रा मोड सेटिङहरू लोड गर्न सकिएन।';

  @override
  String get unableToSaveSleepModeSettings => 'निद्रा मोड सेटिङहरू सेभ गर्न सकिएन।';

  @override
  String get ok => 'ठीक छ';

  @override
  String get blockedApps => 'ब्लक गरिएका एपहरू';

  @override
  String get unableToLoadFocusModeSettings => 'फोकस मोड सेटिङहरू लोड गर्न सकिएन।';

  @override
  String get unableToSaveFocusModeSettings => 'फोकस मोड सेटिङहरू सेभ गर्न सकिएन।';

  @override
  String get breakInterval => 'विश्राम अन्तराल';

  @override
  String get start => 'सुरु';

  @override
  String get end => 'अन्त्य';

  @override
  String get selectDndStartTime => 'डु नट डिस्टर्ब सुरु हुने समय चयन गर्नुहोस्';

  @override
  String get selectDndEndTime => 'डु नट डिस्टर्ब अन्त्य हुने समय चयन गर्नुहोस्';

  @override
  String get focusModeDescription => 'काम गर्दा ध्यान भंग गर्ने एपहरू रोक्नुहोस्';

  @override
  String get emailVerification => 'इमेल प्रमाणीकरण';

  @override
  String get emailVerificationEnabled => 'इमेल प्रमाणीकरण सक्षम छ';

  @override
  String get emailVerified => 'तपाईंको इमेल प्रमाणीकरण गरिएको छ।';

  @override
  String verificationEnabledFor(String email) {
    return '$email का लागि प्रमाणीकरण सक्षम छ।';
  }

  @override
  String get disableEmailVerification => 'इमेल प्रमाणीकरण असक्षम गर्नुहोस्';

  @override
  String get disabling => 'असक्षम हुँदैछ...';

  @override
  String get verifyYourEmail => 'आफ्नो इमेल प्रमाणीकरण गर्नुहोस्';

  @override
  String get verificationCodeWillBeSent => 'तपाईंको इमेलमा प्रमाणीकरण कोड पठाइनेछ।';

  @override
  String sixDigitCodeWillBeSentTo(String email) {
    return 'हामी $email मा छ अङ्कको कोड पठाउनेछौँ।';
  }

  @override
  String get sending => 'पठाउँदैछ...';

  @override
  String get sendCode => 'कोड पठाउनुहोस्';

  @override
  String get resendCode => 'कोड पुनः पठाउनुहोस्';

  @override
  String get sixDigitVerificationCode => 'छ अङ्कको प्रमाणीकरण कोड';

  @override
  String get verifyAndEnable => 'प्रमाणीकरण गरी सक्षम गर्नुहोस्';

  @override
  String get sessionExpiredLoginAgain => 'तपाईंको सत्र समाप्त भएको छ। कृपया फेरि लगइन गर्नुहोस्।';

  @override
  String get noEmailConnected => 'तपाईंको खातामा कुनै इमेल ठेगाना जोडिएको छैन।';

  @override
  String get verificationCodeSent => 'प्रमाणीकरण कोड पठाइएको छ। सबैभन्दा नयाँ कोड मात्र प्रयोग गर्नुहोस्।';

  @override
  String get waitBeforeRequestingCode => 'अर्को कोड अनुरोध गर्नुअघि करिब ६० सेकेन्ड पर्खनुहोस्।';

  @override
  String get sendVerificationCodeFirst => 'पहिले प्रमाणीकरण कोड पठाउनुहोस्।';

  @override
  String get enterCompleteSixDigitCode => 'पूरा छ अङ्कको कोड प्रविष्ट गर्नुहोस्।';

  @override
  String get verificationCodeExpired => 'कोड अमान्य वा म्याद सकिएको छ। कोड पठाउनुहोस् थिचेर नयाँ इमेलको कोड प्रयोग गर्नुहोस्।';

  @override
  String get verificationCodeIncorrect => 'प्रमाणीकरण कोड गलत छ। सबैभन्दा नयाँ इमेल जाँच गर्नुहोस्।';

  @override
  String get verificationCodeNotConfirmed => 'प्रमाणीकरण कोड पुष्टि गर्न सकिएन।';

  @override
  String get verifiedEmailMismatch => 'प्रमाणित इमेल हालको खातासँग मेल खाँदैन।';

  @override
  String get unableToLoadEmailVerificationSettings => 'इमेल प्रमाणीकरण सेटिङहरू लोड गर्न सकिएन।';

  @override
  String get unableToSendVerificationCode => 'प्रमाणीकरण कोड पठाउन सकिएन।';

  @override
  String get unableToVerifyVerificationCode => 'प्रमाणीकरण कोड प्रमाणित गर्न सकिएन।';

  @override
  String get unableToDisableEmailVerification => 'इमेल प्रमाणीकरण असक्षम गर्न सकिएन।';

  @override
  String get unableToLoadSecuritySettings => 'सुरक्षा सेटिङहरू लोड गर्न सकिएन।';

  @override
  String get faceIdLogin => 'फेस आईडी लगइन';

  @override
  String get fingerprintLogin => 'फिङ्गरप्रिन्ट लगइन';

  @override
  String get biometricLogin => 'बायोमेट्रिक लगइन';

  @override
  String get checkingAuthentication => 'प्रमाणीकरण जाँच हुँदैछ...';

  @override
  String get faceIdLoginEnabled => 'फेस आईडी लगइन सक्षम छ';

  @override
  String get unlockUsingFaceId => 'फेस आईडी प्रयोग गरेर अनलक गर्नुहोस्';

  @override
  String get fingerprintLoginEnabled => 'फिङ्गरप्रिन्ट लगइन सक्षम छ';

  @override
  String get unlockUsingFingerprint => 'फिङ्गरप्रिन्ट प्रयोग गरेर अनलक गर्नुहोस्';

  @override
  String get biometricUnavailable => 'फेस आईडी वा फिङ्गरप्रिन्ट उपलब्ध छैन';

  @override
  String get faceIdOrFingerprint => 'फेस आईडी / फिङ्गरप्रिन्ट';

  @override
  String get faceId => 'फेस आईडी';

  @override
  String get fingerprint => 'फिङ्गरप्रिन्ट';

  @override
  String get biometric => 'बायोमेट्रिक';

  @override
  String get twoFactorAuth => 'दुई-चरण प्रमाणीकरण';

  @override
  String get openingEmailVerification => 'इमेल प्रमाणीकरण खोलिँदैछ...';

  @override
  String get verifyUsingEmailOtp => 'इमेल ओटीपी प्रयोग गरेर प्रमाणीकरण गर्नुहोस्';

  @override
  String get emailVerificationEnabledSuccessfully => 'इमेल प्रमाणीकरण सफलतापूर्वक सक्षम गरियो।';

  @override
  String get emailVerificationDisabled => 'इमेल प्रमाणीकरण असक्षम गरियो।';

  @override
  String get unableToOpenEmailVerification => 'इमेल प्रमाणीकरण खोल्न सकिएन।';

  @override
  String get enterCurrentPassword => 'कृपया आफ्नो हालको पासवर्ड प्रविष्ट गर्नुहोस्।';

  @override
  String get enterNewPassword => 'कृपया नयाँ पासवर्ड प्रविष्ट गर्नुहोस्।';

  @override
  String get newPasswordMustBeDifferent => 'नयाँ पासवर्ड हालको पासवर्डभन्दा फरक हुनुपर्छ।';

  @override
  String get currentPasswordIncorrect => 'तपाईंको हालको पासवर्ड गलत छ।';

  @override
  String get unableToUpdatePassword => 'पासवर्ड अपडेट गर्न सकिएन। कृपया फेरि प्रयास गर्नुहोस्।';

  @override
  String biometricLoginDisabled(String authenticationName) {
    return '$authenticationName लगइन असक्षम गरियो।';
  }

  @override
  String biometricLoginEnabled(String authenticationName) {
    return '$authenticationName लगइन सफलतापूर्वक सक्षम गरियो।';
  }

  @override
  String get sessionExpiredBeforeBiometric => 'तपाईंको सत्र समाप्त भएको छ। बायोमेट्रिक लगइन सक्षम गर्नुअघि फेरि लगइन गर्नुहोस्।';

  @override
  String get configureBiometricsFirst => 'फेस आईडी वा फिङ्गरप्रिन्ट उपलब्ध छैन। पहिले आफ्नो डिभाइस सेटिङमा बायोमेट्रिक सेटअप गर्नुहोस्।';

  @override
  String get noBiometricAuthenticationEnrolled => 'कुनै बायोमेट्रिक प्रमाणीकरण सेटअप गरिएको छैन। डिभाइस सेटिङमा फेस आईडी, टच आईडी वा फिङ्गरप्रिन्ट सेटअप गर्नुहोस्।';

  @override
  String get biometricVerificationFailed => 'बायोमेट्रिक प्रमाणीकरण सफल भएन।';

  @override
  String get unableToUpdateBiometricLogin => 'बायोमेट्रिक लगइन अपडेट गर्न सकिएन।';

  @override
  String get activityLog => 'गतिविधि लग';

  @override
  String get viewAccountActivity => 'आफ्नो खाता गतिविधि हेर्नुहोस्';

  @override
  String get activityTrackingDisabled => 'गतिविधि ट्र्याकिङ असक्षम छ';

  @override
  String get activityLogEnabledMessage => 'गतिविधि लग सक्षम गरियो।';

  @override
  String get activityLogDisabledMessage => 'गतिविधि लग असक्षम गरियो।';

  @override
  String get unableToUpdateActivityLog => 'गतिविधि लग अपडेट गर्न सकिएन।';

  @override
  String get dataSharing => 'डेटा साझेदारी';

  @override
  String get analyticsSharingEnabled => 'एनालिटिक्स साझेदारी सक्षम छ';

  @override
  String get shareAnalyticsWithUs => 'हामीसँग एनालिटिक्स साझेदारी गर्नुहोस्';

  @override
  String get dataSharingEnabledMessage => 'डेटा साझेदारी सक्षम गरियो।';

  @override
  String get dataSharingDisabledMessage => 'डेटा साझेदारी असक्षम गरियो।';

  @override
  String get unableToUpdateDataSharing => 'डेटा साझेदारी अपडेट गर्न सकिएन।';

  @override
  String get changePassword => 'पासवर्ड परिवर्तन गर्नुहोस्';

  @override
  String get updateLoginPassword => 'आफ्नो लगइन पासवर्ड अपडेट गर्नुहोस्';

  @override
  String get currentPassword => 'हालको पासवर्ड';

  @override
  String get newPassword => 'नयाँ पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड पुष्टि गर्नुहोस्';

  @override
  String get updatePassword => 'पासवर्ड अपडेट गर्नुहोस्';

  @override
  String get weakPassword => 'कमजोर पासवर्ड';

  @override
  String get mediumPassword => 'मध्यम पासवर्ड';

  @override
  String get strongPassword => 'बलियो पासवर्ड';

  @override
  String get passwordUpdateServiceNotConnected => 'पासवर्ड अपडेट सेवा जडान गरिएको छैन।';

  @override
  String get passwordUpdatedSuccessfully => 'पासवर्ड सफलतापूर्वक अपडेट गरियो';

  @override
  String get clearActivityLog => 'गतिविधि लग खाली गर्नुहोस्';

  @override
  String get clearActivityLogQuestion => 'गतिविधि लग खाली गर्ने?';

  @override
  String get allActivityRecordsDeleted => 'सबै गतिविधि रेकर्डहरू मेटाइनेछन्।';

  @override
  String get clear => 'खाली गर्नुहोस्';

  @override
  String get activityLogCleared => 'गतिविधि लग खाली गरियो।';

  @override
  String get unableToLoadActivityLog => 'गतिविधि लग लोड गर्न सकिएन।';

  @override
  String get unableToClearActivityLog => 'गतिविधि लग खाली गर्न सकिएन।';

  @override
  String get noActivityRecordedYet => 'अहिलेसम्म कुनै गतिविधि रेकर्ड गरिएको छैन।';

  @override
  String get back => 'पछाडि';

  @override
  String get pleaseLogInToViewNotifications => 'सूचनाहरू हेर्न कृपया लगइन गर्नुहोस्।';

  @override
  String get unableToLoadNotifications => 'सूचनाहरू लोड गर्न सकिएन।';

  @override
  String get unableToMarkNotificationAsRead => 'सूचनालाई पढिएको रूपमा चिन्ह लगाउन सकिएन';

  @override
  String get unableToMarkNotificationAsUnread => 'सूचनालाई नपढिएको रूपमा चिन्ह लगाउन सकिएन';

  @override
  String get allNotificationsMarkedAsRead => 'सबै सूचनाहरू पढिएको रूपमा चिन्ह लगाइयो।';

  @override
  String get unableToMarkAllAsRead => 'सबैलाई पढिएको रूपमा चिन्ह लगाउन सकिएन';

  @override
  String get notificationDeleted => 'सूचना मेटाइयो।';

  @override
  String get unableToDeleteNotification => 'सूचना मेटाउन सकिएन';

  @override
  String get deleteAllNotificationsQuestion => 'सबै सूचनाहरू मेटाउने?';

  @override
  String get deleteAllNotificationsDescription => 'यसले तपाईंको इनबक्सबाट सबै सूचनाहरू स्थायी रूपमा हटाउनेछ।';

  @override
  String get deleteAll => 'सबै मेटाउनुहोस्';

  @override
  String get allNotificationsDeleted => 'सबै सूचनाहरू मेटाइयो।';

  @override
  String get unableToDeleteAllNotifications => 'सबै सूचनाहरू मेटाउन सकिएन';

  @override
  String get markAsUnread => 'नपढिएको रूपमा चिन्ह लगाउनुहोस्';

  @override
  String get markAsRead => 'पढिएको रूपमा चिन्ह लगाउनुहोस्';

  @override
  String get deleteNotification => 'सूचना मेटाउनुहोस्';

  @override
  String todayWithTime(String time) {
    return 'आज • $time';
  }

  @override
  String yesterdayWithTime(String time) {
    return 'हिजो • $time';
  }

  @override
  String get markAllRead => 'सबैलाई पढिएको बनाउनुहोस्';

  @override
  String get refresh => 'रिफ्रेस गर्नुहोस्';

  @override
  String get noNotificationsYet => 'अहिलेसम्म कुनै सूचना छैन';

  @override
  String get notificationInboxEmptyDescription => 'तपाईंका तालिका रिमाइन्डर र कार्य अपडेटहरू यहाँ देखिनेछन्।';

  @override
  String get notification => 'सूचना';

  @override
  String get moreOptions => 'थप विकल्पहरू';

  @override
  String get notificationChannels => 'सूचना माध्यमहरू';

  @override
  String get notificationAlerts => 'अलर्टहरू';

  @override
  String get notificationDisplay => 'प्रदर्शन';

  @override
  String get couldNotLoadNotificationSettings => 'सूचना सेटिङहरू लोड गर्न सकिएन।';

  @override
  String get couldNotSaveNotificationSetting => 'सूचना सेटिङ सेभ गर्न सकिएन।';

  @override
  String get pushNotifications => 'पुश सूचनाहरू';

  @override
  String get emailNotifications => 'इमेल सूचनाहरू';

  @override
  String get scheduleReminders => 'तालिका रिमाइन्डरहरू';

  @override
  String get breakAlerts => 'विश्राम अलर्टहरू';

  @override
  String get achievements => 'उपलब्धिहरू';

  @override
  String get weeklyReport => 'साप्ताहिक रिपोर्ट';

  @override
  String get notificationSounds => 'सूचना ध्वनिहरू';

  @override
  String get appBadges => 'एप ब्याजहरू';

  @override
  String get realTimeAlertsOnYourDevice => 'तपाईंको उपकरणमा तत्काल अलर्टहरू';

  @override
  String get digestToYourInbox => 'तपाईंको इनबक्समा सारांश';

  @override
  String get beforeEventsStart => 'कार्यक्रम सुरु हुनुअघि';

  @override
  String get remindToTakeBreaks => 'विश्राम लिन सम्झाउनुहोस्';

  @override
  String get badgesAndMilestones => 'ब्याज र उपलब्धिका चरणहरू';

  @override
  String get sundaySummaryEmail => 'आइतबारको सारांश इमेल';

  @override
  String get audioForAlerts => 'अलर्टका लागि ध्वनि';

  @override
  String get unreadCountOnIcon => 'आइकनमा नपढिएका सूचनाको संख्या';
}
