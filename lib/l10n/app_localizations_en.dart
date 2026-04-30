// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Baraka AI';

  @override
  String get homeTab => 'Home';

  @override
  String get tasksTab => 'Tasks';

  @override
  String get prayerTab => 'Prayer';

  @override
  String get aiTab => 'AI';

  @override
  String get moreTab => 'More';

  @override
  String get notesTitle => 'Notes';

  @override
  String get habitsTitle => 'Habits';

  @override
  String get statsTitle => 'Stats';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get onboardingTitle => 'Set your niyyah';

  @override
  String get onboardingSubtitle =>
      'A calm mobile space for prayer, tasks, habits, notes, streaks, and a respectful AI mentor.';

  @override
  String get yourName => 'Your name';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get prayerSetup => 'Prayer setup';

  @override
  String get city => 'City';

  @override
  String get geolocation => 'Use geolocation';

  @override
  String get calculationMethod => 'Calculation method';

  @override
  String get madhhab => 'Madhhab';

  @override
  String get hanafi => 'Hanafi';

  @override
  String get shafii => 'Shafi\'i';

  @override
  String get aiMentorMode => 'AI mentor mode';

  @override
  String get aiModeOff => 'Off';

  @override
  String get aiModeSoft => 'Soft';

  @override
  String get aiModeNormal => 'Medium';

  @override
  String get aiModeStrict => 'Hard';

  @override
  String get activeMentor => 'Active AI mentor';

  @override
  String get activeMentorHint =>
      'Extra reminders if you ignore prayer or task alerts.';

  @override
  String get activeMentorAntiSpam =>
      'Max 2 extra reminders per item and quiet hours are respected.';

  @override
  String get requestNotifications => 'Allow notifications';

  @override
  String get startApp => 'Start';

  @override
  String greetingName(String name) {
    return 'Assalamu alaikum, $name';
  }

  @override
  String get days => 'days';

  @override
  String get motivationOne => 'Small sincere steps still count.';

  @override
  String get motivationTwo => 'Protect the day before the day runs away.';

  @override
  String get motivationThree => 'Start with the smallest useful action.';

  @override
  String get motivationFour =>
      'Discipline feels lighter after the first two minutes.';

  @override
  String get nextPrayer => 'Next prayer';

  @override
  String get tasksToday => 'Today\'s tasks';

  @override
  String taskProgress(int completed, int total) {
    return '$completed/$total completed';
  }

  @override
  String get quickActions => 'Quick actions';

  @override
  String get addTask => 'Add task';

  @override
  String get addNote => 'Add note';

  @override
  String get openAi => 'Open AI';

  @override
  String get openPrayer => 'Open prayer';

  @override
  String get openStats => 'Open stats';

  @override
  String get today => 'Today';

  @override
  String get emptyTasks => 'No tasks yet.';

  @override
  String get tasksTitle => 'Tasks';

  @override
  String get tasksSubtitle => 'Organize your plans for today';

  @override
  String get completedTasks => 'Completed';

  @override
  String get emptyCompleted => 'Completed tasks will appear here.';

  @override
  String get missedTasks => 'Missed';

  @override
  String get noMissedTasks => 'No missed tasks.';

  @override
  String get editTask => 'Edit task';

  @override
  String get taskTitleField => 'Task title';

  @override
  String get description => 'Description';

  @override
  String get category => 'Category';

  @override
  String get priority => 'Priority';

  @override
  String get priorityLow => 'Low';

  @override
  String get priorityMedium => 'Medium';

  @override
  String get priorityHigh => 'High';

  @override
  String get repeat => 'Repeat';

  @override
  String get repeatNone => 'None';

  @override
  String get repeatDaily => 'Daily';

  @override
  String get repeatWeekly => 'Weekly';

  @override
  String get repeatMonthly => 'Monthly';

  @override
  String get reminder => 'Reminder';

  @override
  String get reminderEnabled => 'Reminder enabled';

  @override
  String get noTime => 'No time';

  @override
  String get choose => 'Choose';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get taskReadQuranTitle => 'Read Quran';

  @override
  String get taskReadQuranDesc => 'Read at least one page with focus.';

  @override
  String get taskPushupsTitle => '10 push-ups';

  @override
  String get taskPushupsDesc => 'A quick body reset.';

  @override
  String get taskReadBookTitle => 'Read a book';

  @override
  String get taskReadBookDesc => 'Ten quiet pages before rest.';

  @override
  String get prayerTitle => 'Prayer';

  @override
  String get todaySchedule => 'Today schedule';

  @override
  String get prayerSettings => 'Prayer settings';

  @override
  String get prayerFajr => 'Fajr';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'Dhuhr';

  @override
  String get prayerAsr => 'Asr';

  @override
  String get prayerMaghrib => 'Maghrib';

  @override
  String get prayerIsha => 'Isha';

  @override
  String get statusUpcoming => 'Upcoming';

  @override
  String get statusCurrent => 'Now';

  @override
  String get statusPast => 'Passed';

  @override
  String get notifications => 'Notifications';

  @override
  String get sound => 'Sound';

  @override
  String get vibration => 'Vibration';

  @override
  String get adhan => 'Adhan';

  @override
  String timeUntilPrayer(String duration, String prayer) {
    return '$duration until $prayer';
  }

  @override
  String get habitQuran => 'Read Quran';

  @override
  String get habitBook => 'Read a book';

  @override
  String get habitPushups => 'Push-ups';

  @override
  String get habitEnglish => 'Learn English';

  @override
  String get habitProgramming => 'Learn programming';

  @override
  String get habitWater => 'Drink water';

  @override
  String get addHabit => 'Add habit';

  @override
  String get editHabit => 'Edit habit';

  @override
  String get emptyHabits => 'No habits yet.';

  @override
  String get habitName => 'Habit name';

  @override
  String get targetPerDay => 'Target per day';

  @override
  String habitProgress(int completed, int target) {
    return '$completed/$target today';
  }

  @override
  String streakDays(int count) {
    return '$count day streak';
  }

  @override
  String get search => 'Search';

  @override
  String get emptyNotes => 'No notes yet.';

  @override
  String get editNote => 'Edit note';

  @override
  String get noteTitleField => 'Note title';

  @override
  String get noteContentField => 'Content';

  @override
  String get tags => 'Tags';

  @override
  String get noteToTask => 'Make task';

  @override
  String get tasksDoneToday => 'Tasks done today';

  @override
  String get tasksMissed => 'Tasks missed';

  @override
  String get completion => 'Completion';

  @override
  String get weekActivity => 'Week activity';

  @override
  String get streaks => 'Streaks';

  @override
  String taskStreak(int count) {
    return 'Tasks: ${count}d';
  }

  @override
  String habitStreak(int count) {
    return 'Habits: ${count}d';
  }

  @override
  String prayerStreak(int count) {
    return 'Prayer: ${count}d';
  }

  @override
  String appStreak(int count) {
    return 'App: ${count}d';
  }

  @override
  String perfectDayStreak(int count) {
    return 'Perfect days: ${count}d';
  }

  @override
  String get insights => 'Insights';

  @override
  String get bestWeekday => 'Best weekday';

  @override
  String get stableHabit => 'Most stable habit';

  @override
  String get mostMissedTask => 'Most missed task';

  @override
  String get noData => 'No data';

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
  String get aiTitle => 'AI mentor';

  @override
  String get clearAiHistory => 'Clear AI history';

  @override
  String get aiEmpty =>
      'Ask about your day, laziness, tasks, prayer time, or a tiny next step.';

  @override
  String get aiInputHint => 'Message your mentor...';

  @override
  String get aiOffReply => 'AI mentor is turned off in settings.';

  @override
  String aiLazyReply(String prayer, String duration, int streak) {
    return 'I get it. Do not do everything, do one tiny step. Before $prayer in $duration, finish 2 minutes and keep your $streak-day streak alive.';
  }

  @override
  String aiSoftReply(
    String name,
    int openTasks,
    String prayer,
    String duration,
  ) {
    return '$name, you have $openTasks open tasks. Next prayer is $prayer in $duration. Pick the smallest one and close it calmly.';
  }

  @override
  String aiNormalReply(
    int completedTasks,
    int openTasks,
    String prayer,
    String duration,
  ) {
    return 'You completed $completedTasks tasks and still have $openTasks. $prayer is in $duration. Close one small action now, then rest cleaner.';
  }

  @override
  String aiStrictReply(int openTasks, String prayer, String duration) {
    return 'Bro, $openTasks tasks are still open. $prayer is in $duration. Do 2 minutes now. This is for you, not for anyone else.';
  }

  @override
  String get aiContextTitle => 'Live context';

  @override
  String aiContextTasks(int completed, int total) {
    return '$completed/$total tasks';
  }

  @override
  String aiContextHabits(int completed, int total) {
    return '$completed/$total habits';
  }

  @override
  String aiContextNextPrayer(String prayer, String duration) {
    return '$prayer in $duration';
  }

  @override
  String aiContextStreak(int count) {
    return '${count}d streak';
  }

  @override
  String get aiTyping => 'Mentor is thinking...';

  @override
  String get aiQuickLazy => 'I\'m lazy';

  @override
  String get aiQuickPlanDay => 'Plan my day';

  @override
  String get aiQuickSummary => 'Daily summary';

  @override
  String get aiQuickMotivate => 'Motivate me';

  @override
  String get aiErrorPrefix => 'AI error';

  @override
  String get aiUnavailable => 'AI is temporarily unavailable. Try again later.';

  @override
  String get aiModeOffNotice =>
      'AI mode is off. You can enable it in settings.';

  @override
  String get profile => 'Profile';

  @override
  String get prayerNotifications => 'Prayer notifications';

  @override
  String get aiSettings => 'AI settings';

  @override
  String get aiAssistantToggle => 'AI Assistant';

  @override
  String get aiBackendConnected => 'Connected via backend';

  @override
  String get aiPrivacyNote =>
      'AI uses only the data needed for advice: tasks, habits, streak, prayer, and statistics.';

  @override
  String get aiAlwaysOn => 'AI is always enabled';

  @override
  String get backgroundStyle => 'App background';

  @override
  String get backgroundAurora => 'Aurora';

  @override
  String get backgroundSteppe => 'Steppe';

  @override
  String get backgroundParticles => 'Stars';

  @override
  String get prayerCorrectionTitle => 'Prayer time correction';

  @override
  String get syncWithSajda => 'Sync with Sajda / local mosque';

  @override
  String get manualPrayerCorrection => 'Manual correction';

  @override
  String get prayerCorrectionExplanation =>
      'Prayer times may differ between apps because of calculation methods and local timetables. Adjust these offsets to match Sajda or your local mosque.';

  @override
  String get resetPrayerCorrection => 'Reset correction';

  @override
  String get voiceSettings => 'Voice';

  @override
  String get voiceInput => 'Voice input';

  @override
  String get voiceReply => 'Voice reply';

  @override
  String get autoSpeakAiReply => 'Auto speak AI reply';

  @override
  String get voiceRate => 'Voice rate';

  @override
  String get voicePitch => 'Voice pitch';

  @override
  String get microphonePermissionRequired => 'Microphone permission required';

  @override
  String get listening => 'Listening...';

  @override
  String get tapToSpeak => 'Tap to speak';

  @override
  String get stopSpeaking => 'Stop speaking';

  @override
  String get speechRecognitionUnavailable => 'Speech recognition unavailable';

  @override
  String get voiceLanguageUnavailable => 'Voice language unavailable';

  @override
  String get ttsUnavailable => 'Text-to-speech unavailable';

  @override
  String get noSpeechDetected => 'No speech detected';

  @override
  String get privacy => 'Privacy';

  @override
  String get exportData => 'Export data';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get restartOnboarding => 'Restart onboarding';

  @override
  String get stub => 'Coming later';

  @override
  String get done => 'Done';
}
