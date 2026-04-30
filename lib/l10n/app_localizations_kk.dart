// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kazakh (`kk`).
class AppLocalizationsKk extends AppLocalizations {
  AppLocalizationsKk([String locale = 'kk']) : super(locale);

  @override
  String get appTitle => 'Baraka AI';

  @override
  String get homeTab => 'Басты';

  @override
  String get tasksTab => 'Тапсырма';

  @override
  String get prayerTab => 'Намаз';

  @override
  String get aiTab => 'AI';

  @override
  String get moreTab => 'Тағы';

  @override
  String get notesTitle => 'Жазбалар';

  @override
  String get habitsTitle => 'Әдеттер';

  @override
  String get statsTitle => 'Статистика';

  @override
  String get settingsTitle => 'Баптаулар';

  @override
  String get onboardingTitle => 'Ниетіңді бапта';

  @override
  String get onboardingSubtitle =>
      'Намаз, тапсырма, әдет, жазба, streak және сыпайы AI-наставник үшін тыныш мобильді кеңістік.';

  @override
  String get yourName => 'Атыңыз';

  @override
  String get language => 'Тіл';

  @override
  String get theme => 'Тақырып';

  @override
  String get themeSystem => 'Жүйелік';

  @override
  String get themeLight => 'Жарық';

  @override
  String get themeDark => 'Қараңғы';

  @override
  String get prayerSetup => 'Намаз баптауы';

  @override
  String get city => 'Қала';

  @override
  String get geolocation => 'Геолокацияны қолдану';

  @override
  String get calculationMethod => 'Есептеу әдісі';

  @override
  String get madhhab => 'Мазһаб';

  @override
  String get hanafi => 'Ханафи';

  @override
  String get shafii => 'Шафиғи';

  @override
  String get aiMentorMode => 'AI-наставник режимі';

  @override
  String get aiModeOff => 'Өшірулі';

  @override
  String get aiModeSoft => 'Жұмсақ';

  @override
  String get aiModeNormal => 'Орта';

  @override
  String get aiModeStrict => 'Қатал';

  @override
  String get activeMentor => 'Белсенді AI-наставник';

  @override
  String get activeMentorHint =>
      'Тапсырма немесе намаз ескертуін елемесеңіз, қосымша еске салады.';

  @override
  String get activeMentorAntiSpam =>
      'Бір пунктке ең көбі 2 қосымша ескерту және тыныш уақыт сақталады.';

  @override
  String get requestNotifications => 'Хабарламаларға рұқсат беру';

  @override
  String get startApp => 'Бастау';

  @override
  String greetingName(String name) {
    return 'Ассаляму алейкум, $name';
  }

  @override
  String get days => 'күн';

  @override
  String get motivationOne => 'Кішкентай шынайы қадам да есептеледі.';

  @override
  String get motivationTwo => 'Күн өтіп кетпей тұрып, оны қорға.';

  @override
  String get motivationThree => 'Ең кішкентай пайдалы әрекеттен баста.';

  @override
  String get motivationFour => 'Алғашқы екі минуттан кейін тәртіп жеңілдейді.';

  @override
  String get nextPrayer => 'Келесі намаз';

  @override
  String get tasksToday => 'Бүгінгі тапсырмалар';

  @override
  String taskProgress(int completed, int total) {
    return '$completed/$total орындалды';
  }

  @override
  String get quickActions => 'Жылдам әрекеттер';

  @override
  String get addTask => 'Тапсырма қосу';

  @override
  String get addNote => 'Жазба қосу';

  @override
  String get openAi => 'AI ашу';

  @override
  String get openPrayer => 'Намазды ашу';

  @override
  String get openStats => 'Статистиканы ашу';

  @override
  String get today => 'Бүгін';

  @override
  String get emptyTasks => 'Әзірге тапсырма жоқ.';

  @override
  String get tasksTitle => 'Тапсырмалар';

  @override
  String get tasksSubtitle => 'Бүгінгі жоспарларыңды ретте';

  @override
  String get completedTasks => 'Орындалған';

  @override
  String get emptyCompleted => 'Орындалған тапсырмалар осында шығады.';

  @override
  String get missedTasks => 'Өтіп кеткен';

  @override
  String get noMissedTasks => 'Өтіп кеткен тапсырма жоқ.';

  @override
  String get editTask => 'Тапсырманы өзгерту';

  @override
  String get taskTitleField => 'Тапсырма атауы';

  @override
  String get description => 'Сипаттама';

  @override
  String get category => 'Санат';

  @override
  String get priority => 'Маңыздылық';

  @override
  String get priorityLow => 'Төмен';

  @override
  String get priorityMedium => 'Орта';

  @override
  String get priorityHigh => 'Жоғары';

  @override
  String get repeat => 'Қайталау';

  @override
  String get repeatNone => 'Жоқ';

  @override
  String get repeatDaily => 'Күн сайын';

  @override
  String get repeatWeekly => 'Апта сайын';

  @override
  String get repeatMonthly => 'Ай сайын';

  @override
  String get reminder => 'Ескерту';

  @override
  String get reminderEnabled => 'Ескерту қосулы';

  @override
  String get noTime => 'Уақыт таңдалмаған';

  @override
  String get choose => 'Таңдау';

  @override
  String get save => 'Сақтау';

  @override
  String get cancel => 'Болдырмау';

  @override
  String get edit => 'Өзгерту';

  @override
  String get delete => 'Жою';

  @override
  String get taskReadQuranTitle => 'Құран оқу';

  @override
  String get taskReadQuranDesc => 'Кемінде бір бетті зейінмен оқу.';

  @override
  String get taskPushupsTitle => '10 рет итерілу';

  @override
  String get taskPushupsDesc => 'Денені тез сергіту.';

  @override
  String get taskReadBookTitle => 'Кітап оқу';

  @override
  String get taskReadBookDesc => 'Демалыс алдында он тыныш бет.';

  @override
  String get prayerTitle => 'Намаз';

  @override
  String get todaySchedule => 'Бүгінгі кесте';

  @override
  String get prayerSettings => 'Намаз баптаулары';

  @override
  String get prayerFajr => 'Бозданғыш (Фажр)';

  @override
  String get prayerSunrise => 'Күн шығу';

  @override
  String get prayerDhuhr => 'Бесін (Зухр)';

  @override
  String get prayerAsr => 'Екінті (Аср)';

  @override
  String get prayerMaghrib => 'Ақшам (Мағриб)';

  @override
  String get prayerIsha => 'Құптан (Иша)';

  @override
  String get statusUpcoming => 'Алда';

  @override
  String get statusCurrent => 'Қазір';

  @override
  String get statusPast => 'Өтті';

  @override
  String get notifications => 'Хабарламалар';

  @override
  String get sound => 'Дыбыс';

  @override
  String get vibration => 'Діріл';

  @override
  String get adhan => 'Азан';

  @override
  String timeUntilPrayer(String duration, String prayer) {
    return '$prayer дейін $duration';
  }

  @override
  String get habitQuran => 'Құран оқу';

  @override
  String get habitBook => 'Кітап оқу';

  @override
  String get habitPushups => 'Итерілу';

  @override
  String get habitEnglish => 'Ағылшын оқу';

  @override
  String get habitProgramming => 'Бағдарламалау оқу';

  @override
  String get habitWater => 'Су ішу';

  @override
  String get addHabit => 'Әдет қосу';

  @override
  String get editHabit => 'Әдетті өзгерту';

  @override
  String get emptyHabits => 'Әзірге әдет жоқ.';

  @override
  String get habitName => 'Әдет атауы';

  @override
  String get targetPerDay => 'Күндік мақсат';

  @override
  String habitProgress(int completed, int target) {
    return '$completed/$target бүгін';
  }

  @override
  String streakDays(int count) {
    return '$count күн streak';
  }

  @override
  String get search => 'Іздеу';

  @override
  String get emptyNotes => 'Әзірге жазба жоқ.';

  @override
  String get editNote => 'Жазбаны өзгерту';

  @override
  String get noteTitleField => 'Жазба атауы';

  @override
  String get noteContentField => 'Мазмұны';

  @override
  String get tags => 'Тегтер';

  @override
  String get noteToTask => 'Тапсырмаға айналдыру';

  @override
  String get tasksDoneToday => 'Бүгін орындалған тапсырма';

  @override
  String get tasksMissed => 'Өтіп кеткен тапсырма';

  @override
  String get completion => 'Орындалу';

  @override
  String get weekActivity => 'Апталық белсенділік';

  @override
  String get streaks => 'Streak';

  @override
  String taskStreak(int count) {
    return 'Тапсырма: $countк';
  }

  @override
  String habitStreak(int count) {
    return 'Әдет: $countк';
  }

  @override
  String prayerStreak(int count) {
    return 'Намаз: $countк';
  }

  @override
  String appStreak(int count) {
    return 'Қолданба: $countк';
  }

  @override
  String perfectDayStreak(int count) {
    return 'Мінсіз күн: $countк';
  }

  @override
  String get insights => 'Инсайттар';

  @override
  String get bestWeekday => 'Ең жақсы күн';

  @override
  String get stableHabit => 'Ең тұрақты әдет';

  @override
  String get mostMissedTask => 'Ең жиі қалатын тапсырма';

  @override
  String get noData => 'Дерек жоқ';

  @override
  String get monday => 'Дүйсенбі';

  @override
  String get tuesday => 'Сейсенбі';

  @override
  String get wednesday => 'Сәрсенбі';

  @override
  String get thursday => 'Бейсенбі';

  @override
  String get friday => 'Жұма';

  @override
  String get saturday => 'Сенбі';

  @override
  String get sunday => 'Жексенбі';

  @override
  String get statsSubtitle => 'Бүгінгі және апталық прогресің';

  @override
  String get statsDone => 'Орындалды';

  @override
  String get statsMissed => 'Өткізілді';

  @override
  String get statsProgress => 'Прогресс';

  @override
  String get statsTodayNoActivity =>
      'Бүгін әзірге белсенділік жоқ. Бір кішкентай қадамнан баста.';

  @override
  String get statsStartSmall => 'Бір кішкентай қадамнан баста.';

  @override
  String get statsNoTasksToday => 'Бүгінге тапсырма жоқ';

  @override
  String statsTasksCount(int completed, int total) {
    return '$completed/$total тапсырма';
  }

  @override
  String get statsWeeklyNoData =>
      'Дерек тапсырмалар орындалғаннан кейін пайда болады.';

  @override
  String get statsMondayShort => 'Дс';

  @override
  String get statsTuesdayShort => 'Сс';

  @override
  String get statsWednesdayShort => 'Ср';

  @override
  String get statsThursdayShort => 'Бс';

  @override
  String get statsFridayShort => 'Жм';

  @override
  String get statsSaturdayShort => 'Сн';

  @override
  String get statsSundayShort => 'Жс';

  @override
  String get statsTaskStreakTitle => 'Тапсырма';

  @override
  String get statsHabitStreakTitle => 'Әдет';

  @override
  String get statsPrayerStreakTitle => 'Намаз';

  @override
  String get statsAppStreakTitle => 'Қолданба';

  @override
  String get statsPerfectDayStreakTitle => 'Мінсіз күн';

  @override
  String get statsTaskStreakHint => 'Күн сайын тапсырма орында';

  @override
  String get statsHabitStreakHint => 'Әдеттерді тұрақты ұста';

  @override
  String get statsPrayerStreakHint => 'Намаз ырғағын сақта';

  @override
  String get statsAppStreakHint => 'Күн сайын орал';

  @override
  String get statsPerfectDayStreakHint => 'Тапсырма, әдет және намаз';

  @override
  String statsDaysCount(int count) {
    return '$count күн';
  }

  @override
  String statsBestStreakInsight(String label, int count) {
    return 'Қазір ең жақсы streak: $label — $count күн';
  }

  @override
  String get statsCloseDayOneTask =>
      'Бүгін күнді бір кішкентай тапсырмамен жабуға болады.';

  @override
  String get statsGreatProgress => 'Жақсы прогресс. Ырғақты тыныш сақта.';

  @override
  String get statsPerfectDayInsight =>
      'Мінсіз күн: тапсырма, әдет орында және намазды өткізбе.';

  @override
  String get statsInsightsEmpty =>
      'Инсайттар бірнеше күндік белсенділіктен кейін пайда болады.';

  @override
  String get aiTitle => 'AI-наставник';

  @override
  String get clearAiHistory => 'AI тарихын тазалау';

  @override
  String get aiEmpty =>
      'Күн, жалқаулық, тапсырмалар, намаз уақыты немесе шағын келесі қадам туралы сұра.';

  @override
  String get aiInputHint => 'Наставникке жаз...';

  @override
  String get aiOffReply => 'AI-наставник баптауларда өшірілген.';

  @override
  String aiLazyReply(String prayer, String duration, int streak) {
    return 'Түсінемін. Барлығын емес, бір кішкентай қадам жаса. $prayer дейін $duration. 2 минут жасап, $streak күн streak сақта.';
  }

  @override
  String aiSoftReply(
    String name,
    int openTasks,
    String prayer,
    String duration,
  ) {
    return '$name, ашық тапсырма: $openTasks. Келесі намаз $prayer $duration кейін. Ең кішісін таңдап, тыныш аяқта.';
  }

  @override
  String aiNormalReply(
    int completedTasks,
    int openTasks,
    String prayer,
    String duration,
  ) {
    return 'Орындалған тапсырма: $completedTasks, қалғаны: $openTasks. $prayer $duration кейін. Қазір бір шағын әрекетті бітір, кейін демалыс жеңіл болады.';
  }

  @override
  String aiStrictReply(int openTasks, String prayer, String duration) {
    return 'Бро, ашық тапсырма: $openTasks. $prayer $duration кейін. Қазір 2 минут жаса. Бұл өзің үшін.';
  }

  @override
  String get aiContextTitle => 'Тірі контекст';

  @override
  String aiContextTasks(int completed, int total) {
    return '$completed/$total тапсырма';
  }

  @override
  String aiContextHabits(int completed, int total) {
    return '$completed/$total әдет';
  }

  @override
  String aiContextNextPrayer(String prayer, String duration) {
    return '$prayer $duration кейін';
  }

  @override
  String aiContextStreak(int count) {
    return '$countк streak';
  }

  @override
  String get aiTyping => 'Наставник ойлануда...';

  @override
  String get aiQuickLazy => 'Маған жалқау';

  @override
  String get aiQuickPlanDay => 'Күнді жоспарла';

  @override
  String get aiQuickSummary => 'Күн қорытындысы';

  @override
  String get aiQuickMotivate => 'Мотивация бер';

  @override
  String get aiErrorPrefix => 'AI қатесі';

  @override
  String get aiUnavailable => 'AI уақытша қолжетімсіз. Кейін қайталап көр.';

  @override
  String get aiModeOffNotice =>
      'AI режимі өшірулі. Оны баптаулардан қосуға болады.';

  @override
  String get profile => 'Профиль';

  @override
  String get prayerNotifications => 'Намаз хабарламалары';

  @override
  String get aiSettings => 'AI баптаулары';

  @override
  String get aiAssistantToggle => 'AI Assistant';

  @override
  String get aiBackendConnected => 'Backend арқылы қосылған';

  @override
  String get aiPrivacyNote =>
      'AI кеңес беру үшін қажет деректерді ғана қолданады: тапсырмалар, әдеттер, streak, намаз және статистика.';

  @override
  String get aiAlwaysOn => 'AI әрқашан қосулы';

  @override
  String get backgroundStyle => 'Қолданба фоны';

  @override
  String get backgroundAurora => 'Аврора';

  @override
  String get backgroundSteppe => 'Дала';

  @override
  String get backgroundParticles => 'Жұлдыздар';

  @override
  String get prayerCorrectionTitle => 'Намаз уақытын түзету';

  @override
  String get syncWithSajda => 'Sajda / жергілікті мешітпен сәйкестендіру';

  @override
  String get manualPrayerCorrection => 'Қолмен түзету';

  @override
  String get prayerCorrectionExplanation =>
      'Намаз уақыты есептеу әдісі мен жергілікті кестеге байланысты қолданбаларда әртүрлі болуы мүмкін. Sajda немесе жергілікті мешітпен сәйкестендіру үшін түзету енгізе аласыз.';

  @override
  String get resetPrayerCorrection => 'Түзетуді қалпына келтіру';

  @override
  String get voiceSettings => 'Дауыс';

  @override
  String get voiceInput => 'Дауыспен енгізу';

  @override
  String get voiceReply => 'Дауысты жауап';

  @override
  String get autoSpeakAiReply => 'AI жауабын автоматты оқу';

  @override
  String get voiceRate => 'Дауыс жылдамдығы';

  @override
  String get voicePitch => 'Дауыс үні';

  @override
  String get microphonePermissionRequired => 'Микрофонға рұқсат қажет';

  @override
  String get listening => 'Тыңдап тұрмын...';

  @override
  String get tapToSpeak => 'Сөйлеу үшін басыңыз';

  @override
  String get stopSpeaking => 'Оқуды тоқтату';

  @override
  String get speechRecognitionUnavailable => 'Сөйлеуді тану қолжетімсіз';

  @override
  String get voiceLanguageUnavailable => 'Дауыс тілі қолжетімсіз';

  @override
  String get ttsUnavailable => 'Дауыстап оқу қолжетімсіз';

  @override
  String get noSpeechDetected => 'Сөйлеу анықталмады';

  @override
  String get privacy => 'Құпиялық';

  @override
  String get exportData => 'Деректерді экспорттау';

  @override
  String get deleteAccount => 'Аккаунтты жою';

  @override
  String get restartOnboarding => 'Onboarding қайта бастау';

  @override
  String get smartSearch => 'Ақылды іздеу';

  @override
  String get searchByMeaning => 'Мағынасы бойынша іздеу';

  @override
  String get noResults => 'Нәтиже жоқ';

  @override
  String get indexing => 'Индекстеу...';

  @override
  String get rebuildIndex => 'Индексті қайта құру';

  @override
  String get rebuildAiMemoryIndex => 'AI жады индексін қайта құру';

  @override
  String get searchNotesAndTasks => 'Жазбалар мен тапсырмалардан іздеу';

  @override
  String get rerankingResults => 'Нәтижелерді reranking жасау';

  @override
  String get smartSearchPrivacyNote =>
      'Ақылды іздеу жазбалар мен тапсырмалар мәтінін embeddings және reranking жасау үшін AI backend-ке жібереді. API кілт тек backend ішінде сақталады.';

  @override
  String get indexFailed =>
      'Кейбір деректер индекстелмеді. Backend embedder баптауларын тексеріңіз.';

  @override
  String get sourceNote => 'Жазба';

  @override
  String get sourceTask => 'Тапсырма';

  @override
  String get sourceHabit => 'Әдет';

  @override
  String get stub => 'Кейін қосылады';

  @override
  String get done => 'Дайын';
}
