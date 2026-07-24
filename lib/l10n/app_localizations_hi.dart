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
  String get statistics => 'आँकड़े';

  @override
  String get clocks => 'घड़ियाँ';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get notifications => 'सूचनाएँ';

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
  String get sleepMode => 'नींद मोड';

  @override
  String get save => 'सेव करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get add => 'जोड़ें';

  @override
  String get tryAgain => 'फिर से प्रयास करें';

  @override
  String get close => 'बंद करें';

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
  String get todaysSchedule => 'आज का शेड्यूल';

  @override
  String get today => 'आज';

  @override
  String get tomorrow => 'कल';

  @override
  String get monday => 'सोमवार';

  @override
  String get tuesday => 'मंगलवार';

  @override
  String get wednesday => 'बुधवार';

  @override
  String get thursday => 'गुरुवार';

  @override
  String get friday => 'शुक्रवार';

  @override
  String get saturday => 'शनिवार';

  @override
  String get sunday => 'रविवार';

  @override
  String get totalFocusTime => 'कुल फोकस समय';

  @override
  String get focusTime => 'फोकस समय';

  @override
  String get focusHours => 'फोकस घंटे';

  @override
  String get tasksDone => 'पूर्ण कार्य';

  @override
  String get totalTasks => 'कुल कार्य';

  @override
  String get completed => 'पूर्ण';

  @override
  String get completedTasksTitle => 'पूर्ण कार्य';

  @override
  String get completionRate => 'पूर्णता दर';

  @override
  String get dailyFocusHours => 'दैनिक फोकस घंटे';

  @override
  String get byCategory => 'श्रेणी के अनुसार';

  @override
  String get monthlyFocus => 'मासिक फोकस';

  @override
  String get productivityInsights => 'आपकी उत्पादकता संबंधी जानकारी';

  @override
  String get profileSection => 'प्रोफाइल';

  @override
  String get preferencesSection => 'प्राथमिकताएँ';

  @override
  String get focusModesSection => 'फोकस मोड';

  @override
  String get profileSubtitle => 'नाम, फोटो और परिचय';

  @override
  String get privacySubtitle => 'पासवर्ड, 2FA और बायोमेट्रिक्स';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get darkModeOn => 'चालू — डार्क इंटरफेस';

  @override
  String get darkModeOff => 'बंद — लाइट इंटरफेस';

  @override
  String get notificationsSubtitle => 'पुश, ईमेल और रिमाइंडर';

  @override
  String get themeColorSubtitle => 'ऐप की रंग योजना बदलें';

  @override
  String get focusMode => 'फोकस मोड';

  @override
  String get focusModeSubtitle => 'ब्लॉक किए गए ऐप और ब्रेक अंतराल';

  @override
  String get sleepModeSubtitle => 'सोने और जागने का समय';

  @override
  String get doNotDisturb => 'डू नॉट डिस्टर्ब';

  @override
  String get loadingSettings => 'सेटिंग लोड हो रही है...';

  @override
  String get on => 'चालू';

  @override
  String get off => 'बंद';

  @override
  String get am => 'पूर्वाह्न';

  @override
  String get pm => 'अपराह्न';

  @override
  String get dndEnabled => 'डू नॉट डिस्टर्ब चालू किया गया';

  @override
  String get dndDisabled => 'डू नॉट डिस्टर्ब बंद किया गया';

  @override
  String tasksCompleted(int completed, int total) {
    return '$total में से $completed कार्य पूरे हुए';
  }

  @override
  String get pleaseLoginToViewStatistics => 'आँकड़े देखने के लिए कृपया लॉग इन करें।';

  @override
  String get unableToLoadStatistics => 'आँकड़े लोड नहीं किए जा सके।';

  @override
  String get untitled => 'बिना शीर्षक';

  @override
  String get studyMode => 'अध्ययन मोड';

  @override
  String get workMode => 'कार्य मोड';

  @override
  String get sleeping => 'सो रहे हैं';

  @override
  String get loginToViewSchedules => 'शेड्यूल देखने के लिए कृपया लॉग इन करें।';

  @override
  String get pleaseLoginToViewSchedules => 'शेड्यूल देखने के लिए कृपया लॉग इन करें।';

  @override
  String get unableToLoadSchedules => 'शेड्यूल लोड नहीं किया जा सका।';

  @override
  String databaseError(Object message) {
    return 'डेटाबेस त्रुटि: $message';
  }

  @override
  String get scheduleAdded => 'शेड्यूल जोड़ा गया';

  @override
  String scheduleAddedBody(Object title) {
    return '\"$title\" आपके शेड्यूल में जोड़ा गया।';
  }

  @override
  String scheduleAddedSuccessfully(String title) {
    return 'शेड्यूल सफलतापूर्वक जोड़ा गया: $title';
  }

  @override
  String get scheduleIdMissing => 'शेड्यूल डेटाबेस ID उपलब्ध नहीं है।';

  @override
  String get loginBeforeUpdating => 'अपडेट करने से पहले कृपया लॉग इन करें।';

  @override
  String get loginBeforeUpdatingSchedule => 'शेड्यूल अपडेट करने से पहले कृपया लॉग इन करें।';

  @override
  String get loginBeforeDeleting => 'हटाने से पहले कृपया लॉग इन करें।';

  @override
  String get loginBeforeDeletingSchedule => 'शेड्यूल हटाने से पहले कृपया लॉग इन करें।';

  @override
  String taskCompleted(String title) {
    return '$title पूरा हुआ';
  }

  @override
  String get taskReopened => 'कार्य फिर से खोला गया';

  @override
  String taskReopenedBody(String title) {
    return '\"$title\" को अपूर्ण के रूप में चिह्नित किया गया।';
  }

  @override
  String taskMarkedCompleted(String title, int count) {
    return 'कार्य \"$title\" पूर्ण किया गया। पूर्ण कार्य: $count';
  }

  @override
  String taskMarkedIncomplete(String title, int count) {
    return 'कार्य \"$title\" अपूर्ण के रूप में चिह्नित किया गया। पूर्ण कार्य: $count';
  }

  @override
  String updateFailed(String message) {
    return 'अपडेट विफल हुआ: $message';
  }

  @override
  String unableToUpdateSchedule(String message) {
    return 'शेड्यूल अपडेट नहीं किया जा सका: $message';
  }

  @override
  String deleteFailed(String message) {
    return 'हटाना विफल हुआ: $message';
  }

  @override
  String unableToDeleteSchedule(String message) {
    return 'शेड्यूल हटाया नहीं जा सका: $message';
  }

  @override
  String scheduleDeletedSuccessfully(String title) {
    return 'शेड्यूल सफलतापूर्वक हटाया गया: $title';
  }

  @override
  String scheduleSelected(String title) {
    return 'चयनित शेड्यूल: $title';
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

  @override
  String unableToLoadDndSettings(String message) {
    return 'डू नॉट डिस्टर्ब सेटिंग लोड नहीं की जा सकी: $message';
  }

  @override
  String unableToUpdateDnd(String message) {
    return 'डू नॉट डिस्टर्ब अपडेट नहीं किया जा सका: $message';
  }

  @override
  String get sleepModeSettingsUpdated => 'स्लीप मोड सेटिंग अपडेट की गई';

  @override
  String get signOut => 'साइन आउट';

  @override
  String get signOutConfirmation => 'क्या आप वास्तव में साइन आउट करना चाहते हैं?';

  @override
  String signOutFailed(String message) {
    return 'साइन आउट विफल हुआ: $message';
  }

  @override
  String pageTitle(String title) {
    return '$title पेज';
  }

  @override
  String get addSchedule => 'शेड्यूल जोड़ें';

  @override
  String get orAddManually => 'या मैन्युअल रूप से जोड़ें';

  @override
  String get title => 'शीर्षक';

  @override
  String get category => 'श्रेणी';

  @override
  String get date => 'तारीख';

  @override
  String get startTime => 'शुरू होने का समय';

  @override
  String get durationMinutes => 'अवधि (मिनट)';

  @override
  String get csvTemplateReady => 'CSV टेम्पलेट तैयार है।';

  @override
  String unableToPrepareTemplate(String message) {
    return 'टेम्पलेट तैयार नहीं किया जा सका: $message';
  }

  @override
  String get loginBeforeImportingSchedules => 'शेड्यूल आयात करने से पहले कृपया लॉग इन करें।';

  @override
  String get noSchedulesImported => 'कोई शेड्यूल आयात नहीं किया गया।';

  @override
  String unableToImportCsv(String message) {
    return 'CSV फ़ाइल आयात नहीं की जा सकी: $message';
  }

  @override
  String get importSchedulesQuestion => 'शेड्यूल आयात करें?';

  @override
  String get importProblems => 'आयात संबंधी समस्याएँ';

  @override
  String get noValidSchedulesFound => 'कोई मान्य शेड्यूल नहीं मिला।';

  @override
  String validSchedulesFound(int count) {
    return '$count मान्य शेड्यूल मिले।';
  }

  @override
  String rowsWillBeSkipped(int count) {
    return '$count पंक्तियाँ छोड़ दी जाएँगी।';
  }

  @override
  String minutesShort(int count) {
    return '$count मिनट';
  }

  @override
  String andMore(int count) {
    return 'और $count अन्य।';
  }

  @override
  String importCount(int count) {
    return '$count आयात करें';
  }

  @override
  String get unknownCategory => 'अज्ञात श्रेणी।';

  @override
  String unknownCategoryAtRow(int row, String category) {
    return 'पंक्ति $row: अज्ञात श्रेणी \"$category\"।';
  }

  @override
  String rowError(int row, String message) {
    return 'पंक्ति $row: $message';
  }

  @override
  String schedulesImportedSuccessfully(int count) {
    return '$count शेड्यूल सफलतापूर्वक आयात किए गए।';
  }

  @override
  String schedulesImportedWithSkipped(int count, int skipped) {
    return '$count शेड्यूल सफलतापूर्वक आयात किए गए, $skipped छोड़े गए।';
  }

  @override
  String get enterScheduleTitle => 'कृपया शेड्यूल का शीर्षक दर्ज करें।';

  @override
  String get enterValidDuration => 'कृपया मान्य अवधि दर्ज करें।';

  @override
  String get loginBeforeSavingSchedule => 'शेड्यूल सेव करने से पहले कृपया लॉग इन करें।';

  @override
  String get selectFutureDateTime => 'कृपया भविष्य की तारीख और समय चुनें।';

  @override
  String get scheduleIdNotReturned => 'शेड्यूल ID वापस नहीं मिली।';

  @override
  String unableToSaveSchedule(String message) {
    return 'शेड्यूल सेव नहीं किया जा सका: $message';
  }

  @override
  String get noSchedulesAvailable => 'कोई शेड्यूल उपलब्ध नहीं है';

  @override
  String get all => 'सभी';

  @override
  String get work => 'कार्य';

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
  String get durationRequired => 'अवधि दर्ज करना आवश्यक है';

  @override
  String get enterValidNumber => 'मान्य संख्या दर्ज करें';

  @override
  String minimumDuration(int minutes) {
    return 'न्यूनतम अवधि $minutes मिनट है';
  }

  @override
  String maximumDuration(int minutes) {
    return 'अधिकतम अवधि $minutes मिनट है';
  }

  @override
  String get deleteSchedule => 'शेड्यूल हटाएँ';

  @override
  String get deepWork => 'गहन कार्य';

  @override
  String get readingMode => 'पढ़ने का मोड';

  @override
  String get exerciseMode => 'व्यायाम मोड';

  @override
  String get noFocusMode => 'कोई फोकस मोड नहीं';

  @override
  String get custom => 'कस्टम';

  @override
  String get user => 'उपयोगकर्ता';

  @override
  String notificationsUnread(int count) {
    return '$count अपठित सूचनाएँ';
  }

  @override
  String get noSchedulesForToday => 'आज के लिए कोई शेड्यूल नहीं है';

  @override
  String get pressAddToCreateSchedule => 'शेड्यूल बनाने के लिए जोड़ें दबाएँ।';

  @override
  String get scheduleUpdateFailed => 'शेड्यूल अपडेट नहीं हुआ। कृपया RLS नीति जाँचें।';

  @override
  String get scheduleDeleteFailed => 'शेड्यूल हटाया नहीं गया। कृपया RLS नीति जाँचें।';

  @override
  String get importSchedule => 'शेड्यूल आयात करें';

  @override
  String get uploadCsvDescription => 'एक साथ कई शेड्यूल जोड़ने के लिए CSV फ़ाइल अपलोड करें।';

  @override
  String selectedFile(String fileName) {
    return 'चयनित: $fileName';
  }

  @override
  String get preparingTemplate => 'टेम्पलेट तैयार किया जा रहा है...';

  @override
  String get downloadTemplate => 'टेम्पलेट डाउनलोड करें';

  @override
  String get uploadFile => 'फ़ाइल अपलोड करें';

  @override
  String get scheduleTitleRequired => 'कृपया शेड्यूल का शीर्षक दर्ज करें';

  @override
  String minimumTitleLength(int count) {
    return 'शीर्षक में कम से कम $count अक्षर होने चाहिए';
  }

  @override
  String get scheduleTitleHint => 'उदाहरण: डीप वर्क सेशन';

  @override
  String get durationHint => '60';

  @override
  String get saveSchedule => 'शेड्यूल सेव करें';

  @override
  String get noData => 'कोई डेटा नहीं';

  @override
  String get noFocusDataYet => 'अभी तक कोई फोकस डेटा नहीं';

  @override
  String get mon => 'सोम';

  @override
  String get tue => 'मंगल';

  @override
  String get wed => 'बुध';

  @override
  String get thu => 'गुरु';

  @override
  String get fri => 'शुक्र';

  @override
  String get sat => 'शनि';

  @override
  String get sun => 'रवि';

  @override
  String get jan => 'जन';

  @override
  String get feb => 'फ़र';

  @override
  String get mar => 'मार्च';

  @override
  String get apr => 'अप्रै';

  @override
  String get may => 'मई';

  @override
  String get jun => 'जून';

  @override
  String get jul => 'जुल';

  @override
  String get aug => 'अग';

  @override
  String get sep => 'सित';

  @override
  String get oct => 'अक्टू';

  @override
  String get nov => 'नव';

  @override
  String get dec => 'दिस';

  @override
  String get taskDone => 'कार्य पूरा';

  @override
  String get tasksDonePlural => 'कार्य पूरे';

  @override
  String get hoursShort => 'घं';

  @override
  String get minutesAbbreviation => 'मि';

  @override
  String get addWorldClock => 'विश्व घड़ी जोड़ें';

  @override
  String get worldClocks => 'विश्व घड़ियाँ';

  @override
  String get searchCityCountryTimezone => 'शहर, देश या समय क्षेत्र खोजें';

  @override
  String get clearSearch => 'खोज साफ़ करें';

  @override
  String get noCityFound => 'कोई शहर नहीं मिला';

  @override
  String get tryAnotherCityCountryTimezone => 'कोई दूसरा शहर, देश या समय क्षेत्र खोजें।';

  @override
  String get isAlreadyAdded => 'पहले से जोड़ा गया है';

  @override
  String get added => 'जोड़ा गया';

  @override
  String get removed => 'हटाया गया';

  @override
  String get unableToLoadWorldClocks => 'विश्व घड़ियाँ लोड नहीं हो सकीं';

  @override
  String get unableToAddClock => 'घड़ी जोड़ी नहीं जा सकी';

  @override
  String get unableToRemoveClock => 'घड़ी हटाई नहीं जा सकी';

  @override
  String get thisClockCannotBeDeleted => 'इस घड़ी को हटाया नहीं जा सकता।';

  @override
  String get deleteClock => 'घड़ी हटाएँ?';

  @override
  String get fromYourWorldClocks => 'को अपनी विश्व घड़ियों से हटाएँ?';

  @override
  String get noWorldClocksAdded => 'कोई विश्व घड़ी नहीं जोड़ी गई';

  @override
  String get tapPlusToAddCity => 'शहर खोजने और जोड़ने के लिए + बटन दबाएँ।';

  @override
  String get searchCity => 'शहर खोजें';

  @override
  String get unableToLoadProfile => 'प्रोफाइल लोड नहीं की जा सकी';

  @override
  String get profileUpdatedSuccessfully => 'प्रोफाइल सफलतापूर्वक अपडेट की गई';

  @override
  String get profileDataUnavailable => 'प्रोफाइल डेटा उपलब्ध नहीं है';

  @override
  String get citySydney => 'सिडनी';

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
  String get cityKathmandu => 'काठमांडू';

  @override
  String get cityPokhara => 'पोखरा';

  @override
  String get cityNewDelhi => 'नई दिल्ली';

  @override
  String get cityMumbai => 'मुंबई';

  @override
  String get cityBengaluru => 'बेंगलुरु';

  @override
  String get cityChennai => 'चेन्नई';

  @override
  String get cityTokyo => 'टोक्यो';

  @override
  String get cityOsaka => 'ओसाका';

  @override
  String get citySeoul => 'सियोल';

  @override
  String get cityBeijing => 'बीजिंग';

  @override
  String get cityShanghai => 'शंघाई';

  @override
  String get cityHongKong => 'हांगकांग';

  @override
  String get citySingapore => 'सिंगापुर';

  @override
  String get cityBangkok => 'बैंकॉक';

  @override
  String get cityJakarta => 'जकार्ता';

  @override
  String get cityManila => 'मनीला';

  @override
  String get cityKualaLumpur => 'कुआलालंपुर';

  @override
  String get cityDhaka => 'ढाका';

  @override
  String get cityKarachi => 'कराची';

  @override
  String get cityColombo => 'कोलंबो';

  @override
  String get cityDubai => 'दुबई';

  @override
  String get cityLondon => 'लंदन';

  @override
  String get cityParis => 'पेरिस';

  @override
  String get cityBerlin => 'बर्लिन';

  @override
  String get cityRome => 'रोम';

  @override
  String get cityMadrid => 'मैड्रिड';

  @override
  String get cityAmsterdam => 'एम्स्टर्डम';

  @override
  String get cityZurich => 'ज्यूरिख';

  @override
  String get cityAthens => 'एथेंस';

  @override
  String get cityIstanbul => 'इस्तांबुल';

  @override
  String get cityNewYork => 'न्यूयॉर्क';

  @override
  String get cityLosAngeles => 'लॉस एंजिल्स';

  @override
  String get cityChicago => 'शिकागो';

  @override
  String get cityDenver => 'डेनवर';

  @override
  String get cityHonolulu => 'होनोलूलू';

  @override
  String get cityToronto => 'टोरंटो';

  @override
  String get cityVancouver => 'वैंकूवर';

  @override
  String get citySaoPaulo => 'साओ पाउलो';

  @override
  String get cityBuenosAires => 'ब्यूनस आयर्स';

  @override
  String get cityCairo => 'काहिरा';

  @override
  String get cityNairobi => 'नैरोबी';

  @override
  String get cityJohannesburg => 'जोहान्सबर्ग';

  @override
  String get cityAuckland => 'ऑकलैंड';

  @override
  String get cityWellington => 'वेलिंगटन';

  @override
  String get countryAustralia => 'ऑस्ट्रेलिया';

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
  String get countryHongKong => 'हांगकांग';

  @override
  String get countrySingapore => 'सिंगापुर';

  @override
  String get countryThailand => 'थाईलैंड';

  @override
  String get countryIndonesia => 'इंडोनेशिया';

  @override
  String get countryPhilippines => 'फिलीपींस';

  @override
  String get countryMalaysia => 'मलेशिया';

  @override
  String get countryBangladesh => 'बांग्लादेश';

  @override
  String get countryPakistan => 'पाकिस्तान';

  @override
  String get countrySriLanka => 'श्रीलंका';

  @override
  String get countryUnitedArabEmirates => 'संयुक्त अरब अमीरात';

  @override
  String get countryUnitedKingdom => 'यूनाइटेड किंगडम';

  @override
  String get countryFrance => 'फ्रांस';

  @override
  String get countryGermany => 'जर्मनी';

  @override
  String get countryItaly => 'इटली';

  @override
  String get countrySpain => 'स्पेन';

  @override
  String get countryNetherlands => 'नीदरलैंड';

  @override
  String get countrySwitzerland => 'स्विट्जरलैंड';

  @override
  String get countryGreece => 'ग्रीस';

  @override
  String get countryTurkiye => 'तुर्किये';

  @override
  String get countryUnitedStates => 'संयुक्त राज्य अमेरिका';

  @override
  String get countryCanada => 'कनाडा';

  @override
  String get countryBrazil => 'ब्राजील';

  @override
  String get countryArgentina => 'अर्जेंटीना';

  @override
  String get countryEgypt => 'मिस्र';

  @override
  String get countryKenya => 'केन्या';

  @override
  String get countrySouthAfrica => 'दक्षिण अफ्रीका';

  @override
  String get countryNewZealand => 'न्यूजीलैंड';

  @override
  String get editProfile => 'प्रोफाइल संपादित करें';

  @override
  String get days => 'दिन';

  @override
  String get done => 'पूर्ण';

  @override
  String get hours => 'घंटे';

  @override
  String get membership => 'सदस्यता';

  @override
  String get projectUser => 'प्रोजेक्ट उपयोगकर्ता';

  @override
  String get defaultBio => 'बेहतर आदतें बनाने पर केंद्रित ✨';

  @override
  String get member => 'सदस्य';

  @override
  String get level => 'स्तर';

  @override
  String get badges => 'बैज';

  @override
  String get badge => 'बैज';

  @override
  String get earlyBird => 'सुबह जल्दी सक्रिय';

  @override
  String get nightOwl => 'रात में सक्रिय';

  @override
  String get streakSeven => '7 दिन की निरंतरता';

  @override
  String get focusOneHundredHours => '100 घंटे फोकस';

  @override
  String get plannerPro => 'योजना विशेषज्ञ';

  @override
  String get zenMaster => 'ज़ेन मास्टर';

  @override
  String get unableToLoadBadges => 'बैज लोड नहीं किए जा सके';

  @override
  String badgesEarned(int earned, int total) {
    return '$total में से $earned प्राप्त';
  }

  @override
  String get recentActivity => 'हाल की गतिविधि';

  @override
  String get refreshActivity => 'गतिविधि फिर से लोड करें';

  @override
  String get unableToLoadRecentActivity => 'हाल की गतिविधि लोड नहीं की जा सकी';

  @override
  String get noRecentActivity => 'अभी तक कोई हाल की गतिविधि नहीं है।';

  @override
  String get activity => 'गतिविधि';

  @override
  String get scheduleAddedActivity => 'शेड्यूल जोड़ा गया';

  @override
  String get scheduleCompletedActivity => 'शेड्यूल पूरा हुआ';

  @override
  String get scheduleDeletedActivity => 'शेड्यूल हटाया गया';

  @override
  String get focusCompletedActivity => 'फोकस सत्र पूरा हुआ';

  @override
  String get badgeUnlockedActivity => 'बैज प्राप्त हुआ';

  @override
  String get membershipChangedActivity => 'सदस्यता बदली गई';

  @override
  String get levelUpActivity => 'स्तर बढ़ा';

  @override
  String get streakUpdatedActivity => 'निरंतरता अपडेट हुई';

  @override
  String get justNow => 'अभी';

  @override
  String get yesterday => 'कल';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count मिनट पहले',
      one: '1 मिनट पहले',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count घंटे पहले',
      one: '1 घंटे पहले',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count दिन पहले',
      one: '1 दिन पहले',
    );
    return '$_temp0';
  }

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get bio => 'परिचय';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get pleaseEnterYourName => 'कृपया अपना नाम दर्ज करें';

  @override
  String get unableToUpdateProfile => 'प्रोफाइल अपडेट नहीं की जा सकी';

  @override
  String get livePreview => 'लाइव पूर्वावलोकन';

  @override
  String get primary => 'प्राथमिक';

  @override
  String get secondary => 'द्वितीयक';

  @override
  String get primaryButtonPreview => 'प्राथमिक बटन का पूर्वावलोकन';

  @override
  String get secondaryButtonPreview => 'द्वितीयक बटन का पूर्वावलोकन';

  @override
  String get accentColorPreviewDescription => 'आपका चुना हुआ एक्सेंट रंग पूरे ऐप में बटन, आइकन, बॉर्डर और चयनित नियंत्रणों पर इस तरह दिखाई देगा।';

  @override
  String get themeColorDescription => 'अपना एक्सेंट रंग चुनें। परिवर्तन पूरे ऐप में तुरंत लागू होंगे।';

  @override
  String get purple => 'बैंगनी';

  @override
  String get ocean => 'महासागर';

  @override
  String get sunset => 'सूर्यास्त';

  @override
  String get forest => 'वन';

  @override
  String get rose => 'गुलाबी';

  @override
  String get gold => 'सुनहरा';

  @override
  String themeApplied(String themeName) {
    return '$themeName थीम लागू हो गई';
  }

  @override
  String get unableToSaveThemeColor => 'थीम का रंग सहेजा नहीं जा सका';

  @override
  String get saving => 'सहेजा जा रहा है...';

  @override
  String get saveSettings => 'सेटिंग्स सहेजें';

  @override
  String get enableSleepMode => 'स्लीप मोड सक्षम करें';

  @override
  String get sleepModeActive => 'स्लीप मोड सक्रिय है';

  @override
  String get sleepModeOff => 'स्लीप मोड बंद है';

  @override
  String get sleepSchedule => 'नींद का शेड्यूल';

  @override
  String get sleepScheduleDescription => 'नियमित नींद की दिनचर्या बनाए रखने के लिए सोने और जागने का समय सेट करें।';

  @override
  String get bedtime => 'सोने का समय';

  @override
  String get wakeUpTime => 'जागने का समय';

  @override
  String get selectBedtime => 'सोने का समय चुनें';

  @override
  String get selectWakeUpTime => 'जागने का समय चुनें';

  @override
  String get sleepModeSettingsSaved => 'स्लीप मोड सेटिंग्स सहेज दी गई हैं।';

  @override
  String get unableToLoadSleepModeSettings => 'स्लीप मोड सेटिंग्स लोड नहीं की जा सकीं।';

  @override
  String get unableToSaveSleepModeSettings => 'स्लीप मोड सेटिंग्स सहेजी नहीं जा सकीं।';

  @override
  String get ok => 'ठीक है';

  @override
  String get blockedApps => 'ब्लॉक किए गए ऐप्स';

  @override
  String get unableToLoadFocusModeSettings => 'फोकस मोड सेटिंग्स लोड नहीं की जा सकीं।';

  @override
  String get unableToSaveFocusModeSettings => 'फोकस मोड सेटिंग्स सहेजी नहीं जा सकीं।';

  @override
  String get breakInterval => 'ब्रेक अंतराल';

  @override
  String get start => 'शुरू';

  @override
  String get end => 'समाप्त';

  @override
  String get selectDndStartTime => 'डू नॉट डिस्टर्ब शुरू होने का समय चुनें';

  @override
  String get selectDndEndTime => 'डू नॉट डिस्टर्ब समाप्त होने का समय चुनें';

  @override
  String get focusModeDescription => 'काम करते समय ध्यान भटकाने वाले ऐप्स को ब्लॉक करें';

  @override
  String get emailVerification => 'ईमेल सत्यापन';

  @override
  String get emailVerificationEnabled => 'ईमेल सत्यापन सक्षम है';

  @override
  String get emailVerified => 'आपका ईमेल सत्यापित हो गया है।';

  @override
  String verificationEnabledFor(String email) {
    return '$email के लिए सत्यापन सक्षम है।';
  }

  @override
  String get disableEmailVerification => 'ईमेल सत्यापन अक्षम करें';

  @override
  String get disabling => 'अक्षम किया जा रहा है...';

  @override
  String get verifyYourEmail => 'अपना ईमेल सत्यापित करें';

  @override
  String get verificationCodeWillBeSent => 'आपके ईमेल पर एक सत्यापन कोड भेजा जाएगा।';

  @override
  String sixDigitCodeWillBeSentTo(String email) {
    return 'हम $email पर छह अंकों का कोड भेजेंगे।';
  }

  @override
  String get sending => 'भेजा जा रहा है...';

  @override
  String get sendCode => 'कोड भेजें';

  @override
  String get resendCode => 'कोड फिर से भेजें';

  @override
  String get sixDigitVerificationCode => 'छह अंकों का सत्यापन कोड';

  @override
  String get verifyAndEnable => 'सत्यापित करके सक्षम करें';

  @override
  String get sessionExpiredLoginAgain => 'आपका सत्र समाप्त हो गया है। कृपया फिर से लॉग इन करें।';

  @override
  String get noEmailConnected => 'आपके खाते से कोई ईमेल पता जुड़ा नहीं है।';

  @override
  String get verificationCodeSent => 'सत्यापन कोड भेज दिया गया है। केवल नवीनतम कोड का उपयोग करें।';

  @override
  String get waitBeforeRequestingCode => 'दूसरा कोड मांगने से पहले लगभग 60 सेकंड प्रतीक्षा करें।';

  @override
  String get sendVerificationCodeFirst => 'कृपया पहले सत्यापन कोड भेजें।';

  @override
  String get enterCompleteSixDigitCode => 'कृपया पूरा छह अंकों का कोड दर्ज करें।';

  @override
  String get verificationCodeExpired => 'कोड अमान्य है या उसकी अवधि समाप्त हो गई है। कोड भेजें दबाकर नवीनतम ईमेल वाला कोड उपयोग करें।';

  @override
  String get verificationCodeIncorrect => 'सत्यापन कोड गलत है। नवीनतम ईमेल जांचें।';

  @override
  String get verificationCodeNotConfirmed => 'सत्यापन कोड की पुष्टि नहीं हो सकी।';

  @override
  String get verifiedEmailMismatch => 'सत्यापित ईमेल वर्तमान खाते से मेल नहीं खाता।';

  @override
  String get unableToLoadEmailVerificationSettings => 'ईमेल सत्यापन सेटिंग्स लोड नहीं की जा सकीं।';

  @override
  String get unableToSendVerificationCode => 'सत्यापन कोड नहीं भेजा जा सका।';

  @override
  String get unableToVerifyVerificationCode => 'सत्यापन कोड सत्यापित नहीं किया जा सका।';

  @override
  String get unableToDisableEmailVerification => 'ईमेल सत्यापन अक्षम नहीं किया जा सका।';

  @override
  String get unableToLoadSecuritySettings => 'सुरक्षा सेटिंग्स लोड नहीं की जा सकीं।';

  @override
  String get faceIdLogin => 'फेस आईडी लॉगिन';

  @override
  String get fingerprintLogin => 'फिंगरप्रिंट लॉगिन';

  @override
  String get biometricLogin => 'बायोमेट्रिक लॉगिन';

  @override
  String get checkingAuthentication => 'प्रमाणीकरण जांचा जा रहा है...';

  @override
  String get faceIdLoginEnabled => 'फेस आईडी लॉगिन सक्षम है';

  @override
  String get unlockUsingFaceId => 'फेस आईडी का उपयोग करके अनलॉक करें';

  @override
  String get fingerprintLoginEnabled => 'फिंगरप्रिंट लॉगिन सक्षम है';

  @override
  String get unlockUsingFingerprint => 'फिंगरप्रिंट का उपयोग करके अनलॉक करें';

  @override
  String get biometricUnavailable => 'फेस आईडी या फिंगरप्रिंट उपलब्ध नहीं है';

  @override
  String get faceIdOrFingerprint => 'फेस आईडी / फिंगरप्रिंट';

  @override
  String get faceId => 'फेस आईडी';

  @override
  String get fingerprint => 'फिंगरप्रिंट';

  @override
  String get biometric => 'बायोमेट्रिक';

  @override
  String get twoFactorAuth => 'टू-फैक्टर प्रमाणीकरण';

  @override
  String get openingEmailVerification => 'ईमेल सत्यापन खोला जा रहा है...';

  @override
  String get verifyUsingEmailOtp => 'ईमेल ओटीपी का उपयोग करके सत्यापित करें';

  @override
  String get emailVerificationEnabledSuccessfully => 'ईमेल सत्यापन सफलतापूर्वक सक्षम किया गया।';

  @override
  String get emailVerificationDisabled => 'ईमेल सत्यापन अक्षम किया गया।';

  @override
  String get unableToOpenEmailVerification => 'ईमेल सत्यापन नहीं खोला जा सका।';

  @override
  String get enterCurrentPassword => 'कृपया अपना वर्तमान पासवर्ड दर्ज करें।';

  @override
  String get enterNewPassword => 'कृपया नया पासवर्ड दर्ज करें।';

  @override
  String get newPasswordMustBeDifferent => 'नया पासवर्ड वर्तमान पासवर्ड से अलग होना चाहिए।';

  @override
  String get currentPasswordIncorrect => 'आपका वर्तमान पासवर्ड गलत है।';

  @override
  String get unableToUpdatePassword => 'आपका पासवर्ड अपडेट नहीं किया जा सका। कृपया फिर से प्रयास करें।';

  @override
  String biometricLoginDisabled(String authenticationName) {
    return '$authenticationName लॉगिन अक्षम किया गया।';
  }

  @override
  String biometricLoginEnabled(String authenticationName) {
    return '$authenticationName लॉगिन सफलतापूर्वक सक्षम किया गया।';
  }

  @override
  String get sessionExpiredBeforeBiometric => 'आपका सत्र समाप्त हो गया है। बायोमेट्रिक लॉगिन सक्षम करने से पहले फिर से लॉग इन करें।';

  @override
  String get configureBiometricsFirst => 'फेस आईडी या फिंगरप्रिंट उपलब्ध नहीं है। पहले अपनी डिवाइस सेटिंग्स में बायोमेट्रिक सेटअप करें।';

  @override
  String get noBiometricAuthenticationEnrolled => 'कोई बायोमेट्रिक प्रमाणीकरण सेटअप नहीं है। डिवाइस सेटिंग्स में फेस आईडी, टच आईडी या फिंगरप्रिंट सेटअप करें।';

  @override
  String get biometricVerificationFailed => 'बायोमेट्रिक सत्यापन सफल नहीं हुआ।';

  @override
  String get unableToUpdateBiometricLogin => 'बायोमेट्रिक लॉगिन अपडेट नहीं किया जा सका।';

  @override
  String get activityLog => 'गतिविधि लॉग';

  @override
  String get viewAccountActivity => 'अपने खाते की गतिविधि देखें';

  @override
  String get activityTrackingDisabled => 'गतिविधि ट्रैकिंग अक्षम है';

  @override
  String get activityLogEnabledMessage => 'गतिविधि लॉग सक्षम किया गया।';

  @override
  String get activityLogDisabledMessage => 'गतिविधि लॉग अक्षम किया गया।';

  @override
  String get unableToUpdateActivityLog => 'गतिविधि लॉग अपडेट नहीं किया जा सका।';

  @override
  String get dataSharing => 'डेटा साझाकरण';

  @override
  String get analyticsSharingEnabled => 'एनालिटिक्स साझाकरण सक्षम है';

  @override
  String get shareAnalyticsWithUs => 'हमारे साथ एनालिटिक्स साझा करें';

  @override
  String get dataSharingEnabledMessage => 'डेटा साझाकरण सक्षम किया गया।';

  @override
  String get dataSharingDisabledMessage => 'डेटा साझाकरण अक्षम किया गया।';

  @override
  String get unableToUpdateDataSharing => 'डेटा साझाकरण अपडेट नहीं किया जा सका।';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get updateLoginPassword => 'अपना लॉगिन पासवर्ड अपडेट करें';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmPassword => 'पासवर्ड की पुष्टि करें';

  @override
  String get updatePassword => 'पासवर्ड अपडेट करें';

  @override
  String get weakPassword => 'कमजोर पासवर्ड';

  @override
  String get mediumPassword => 'मध्यम पासवर्ड';

  @override
  String get strongPassword => 'मजबूत पासवर्ड';

  @override
  String get passwordUpdateServiceNotConnected => 'पासवर्ड अपडेट सेवा कनेक्ट नहीं है।';

  @override
  String get passwordUpdatedSuccessfully => 'पासवर्ड सफलतापूर्वक अपडेट किया गया';

  @override
  String get clearActivityLog => 'गतिविधि लॉग साफ करें';

  @override
  String get clearActivityLogQuestion => 'गतिविधि लॉग साफ करें?';

  @override
  String get allActivityRecordsDeleted => 'सभी गतिविधि रिकॉर्ड हटा दिए जाएंगे।';

  @override
  String get clear => 'साफ करें';

  @override
  String get activityLogCleared => 'गतिविधि लॉग साफ कर दिया गया।';

  @override
  String get unableToLoadActivityLog => 'गतिविधि लॉग लोड नहीं किया जा सका।';

  @override
  String get unableToClearActivityLog => 'गतिविधि लॉग साफ नहीं किया जा सका।';

  @override
  String get noActivityRecordedYet => 'अभी तक कोई गतिविधि रिकॉर्ड नहीं की गई है।';

  @override
  String get back => 'वापस';

  @override
  String get pleaseLogInToViewNotifications => 'सूचनाएं देखने के लिए कृपया लॉगिन करें।';

  @override
  String get unableToLoadNotifications => 'सूचनाएं लोड नहीं की जा सकीं।';

  @override
  String get unableToMarkNotificationAsRead => 'सूचना को पढ़ा हुआ चिह्नित नहीं किया जा सका';

  @override
  String get unableToMarkNotificationAsUnread => 'सूचना को बिना पढ़ा हुआ चिह्नित नहीं किया जा सका';

  @override
  String get allNotificationsMarkedAsRead => 'सभी सूचनाएं पढ़ी हुई चिह्नित कर दी गई हैं।';

  @override
  String get unableToMarkAllAsRead => 'सभी को पढ़ा हुआ चिह्नित नहीं किया जा सका';

  @override
  String get notificationDeleted => 'सूचना हटा दी गई।';

  @override
  String get unableToDeleteNotification => 'सूचना हटाई नहीं जा सकी';

  @override
  String get deleteAllNotificationsQuestion => 'सभी सूचनाएं हटाएं?';

  @override
  String get deleteAllNotificationsDescription => 'यह आपके इनबॉक्स से सभी सूचनाओं को स्थायी रूप से हटा देगा।';

  @override
  String get deleteAll => 'सभी हटाएं';

  @override
  String get allNotificationsDeleted => 'सभी सूचनाएं हटा दी गईं।';

  @override
  String get unableToDeleteAllNotifications => 'सभी सूचनाएं हटाई नहीं जा सकीं';

  @override
  String get markAsUnread => 'बिना पढ़ा हुआ चिह्नित करें';

  @override
  String get markAsRead => 'पढ़ा हुआ चिह्नित करें';

  @override
  String get deleteNotification => 'सूचना हटाएं';

  @override
  String todayWithTime(String time) {
    return 'आज • $time';
  }

  @override
  String yesterdayWithTime(String time) {
    return 'कल • $time';
  }

  @override
  String get markAllRead => 'सभी को पढ़ा हुआ करें';

  @override
  String get refresh => 'रीफ्रेश करें';

  @override
  String get noNotificationsYet => 'अभी तक कोई सूचना नहीं है';

  @override
  String get notificationInboxEmptyDescription => 'आपके शेड्यूल रिमाइंडर और कार्य अपडेट यहां दिखाई देंगे।';

  @override
  String get notification => 'सूचना';

  @override
  String get moreOptions => 'अधिक विकल्प';

  @override
  String get notificationChannels => 'सूचना माध्यम';

  @override
  String get notificationAlerts => 'अलर्ट';

  @override
  String get notificationDisplay => 'डिस्प्ले';

  @override
  String get couldNotLoadNotificationSettings => 'सूचना सेटिंग लोड नहीं की जा सकीं।';

  @override
  String get couldNotSaveNotificationSetting => 'सूचना सेटिंग सेव नहीं की जा सकी।';

  @override
  String get pushNotifications => 'पुश सूचनाएं';

  @override
  String get emailNotifications => 'ईमेल सूचनाएं';

  @override
  String get scheduleReminders => 'शेड्यूल रिमाइंडर';

  @override
  String get breakAlerts => 'ब्रेक अलर्ट';

  @override
  String get achievements => 'उपलब्धियां';

  @override
  String get weeklyReport => 'साप्ताहिक रिपोर्ट';

  @override
  String get notificationSounds => 'सूचना ध्वनि';

  @override
  String get appBadges => 'ऐप बैज';

  @override
  String get realTimeAlertsOnYourDevice => 'आपके डिवाइस पर रियल-टाइम अलर्ट';

  @override
  String get digestToYourInbox => 'आपके इनबॉक्स में सारांश';

  @override
  String get beforeEventsStart => 'कार्यक्रम शुरू होने से पहले';

  @override
  String get remindToTakeBreaks => 'ब्रेक लेने की याद दिलाएं';

  @override
  String get badgesAndMilestones => 'बैज और उपलब्धि चरण';

  @override
  String get sundaySummaryEmail => 'रविवार का सारांश ईमेल';

  @override
  String get audioForAlerts => 'अलर्ट के लिए ध्वनि';

  @override
  String get unreadCountOnIcon => 'आइकन पर बिना पढ़ी सूचनाओं की संख्या';
}
