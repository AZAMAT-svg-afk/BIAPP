import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_kk.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('kk'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Baraka AI'**
  String get appTitle;

  /// No description provided for @homeTab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTab;

  /// No description provided for @tasksTab.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTab;

  /// No description provided for @prayerTab.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get prayerTab;

  /// No description provided for @aiTab.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get aiTab;

  /// No description provided for @moreTab.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTab;

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTitle;

  /// No description provided for @habitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Habits'**
  String get habitsTitle;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get statsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Set your niyyah'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A calm mobile space for prayer, tasks, habits, notes, streaks, and a respectful AI mentor.'**
  String get onboardingSubtitle;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get yourName;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @prayerSetup.
  ///
  /// In en, this message translates to:
  /// **'Prayer setup'**
  String get prayerSetup;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @geolocation.
  ///
  /// In en, this message translates to:
  /// **'Use geolocation'**
  String get geolocation;

  /// No description provided for @calculationMethod.
  ///
  /// In en, this message translates to:
  /// **'Calculation method'**
  String get calculationMethod;

  /// No description provided for @madhhab.
  ///
  /// In en, this message translates to:
  /// **'Madhhab'**
  String get madhhab;

  /// No description provided for @hanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get hanafi;

  /// No description provided for @shafii.
  ///
  /// In en, this message translates to:
  /// **'Shafi\'i'**
  String get shafii;

  /// No description provided for @aiMentorMode.
  ///
  /// In en, this message translates to:
  /// **'AI mentor mode'**
  String get aiMentorMode;

  /// No description provided for @aiModeOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get aiModeOff;

  /// No description provided for @aiModeSoft.
  ///
  /// In en, this message translates to:
  /// **'Soft'**
  String get aiModeSoft;

  /// No description provided for @aiModeNormal.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get aiModeNormal;

  /// No description provided for @aiModeStrict.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get aiModeStrict;

  /// No description provided for @activeMentor.
  ///
  /// In en, this message translates to:
  /// **'Active AI mentor'**
  String get activeMentor;

  /// No description provided for @activeMentorHint.
  ///
  /// In en, this message translates to:
  /// **'Extra reminders if you ignore prayer or task alerts.'**
  String get activeMentorHint;

  /// No description provided for @activeMentorAntiSpam.
  ///
  /// In en, this message translates to:
  /// **'Max 2 extra reminders per item and quiet hours are respected.'**
  String get activeMentorAntiSpam;

  /// No description provided for @requestNotifications.
  ///
  /// In en, this message translates to:
  /// **'Allow notifications'**
  String get requestNotifications;

  /// No description provided for @startApp.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startApp;

  /// No description provided for @greetingName.
  ///
  /// In en, this message translates to:
  /// **'Assalamu alaikum, {name}'**
  String greetingName(String name);

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @motivationOne.
  ///
  /// In en, this message translates to:
  /// **'Small sincere steps still count.'**
  String get motivationOne;

  /// No description provided for @motivationTwo.
  ///
  /// In en, this message translates to:
  /// **'Protect the day before the day runs away.'**
  String get motivationTwo;

  /// No description provided for @motivationThree.
  ///
  /// In en, this message translates to:
  /// **'Start with the smallest useful action.'**
  String get motivationThree;

  /// No description provided for @motivationFour.
  ///
  /// In en, this message translates to:
  /// **'Discipline feels lighter after the first two minutes.'**
  String get motivationFour;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next prayer'**
  String get nextPrayer;

  /// No description provided for @tasksToday.
  ///
  /// In en, this message translates to:
  /// **'Today\'s tasks'**
  String get tasksToday;

  /// No description provided for @taskProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} completed'**
  String taskProgress(int completed, int total);

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get quickActions;

  /// No description provided for @addTask.
  ///
  /// In en, this message translates to:
  /// **'Add task'**
  String get addTask;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @openAi.
  ///
  /// In en, this message translates to:
  /// **'Open AI'**
  String get openAi;

  /// No description provided for @openPrayer.
  ///
  /// In en, this message translates to:
  /// **'Open prayer'**
  String get openPrayer;

  /// No description provided for @openStats.
  ///
  /// In en, this message translates to:
  /// **'Open stats'**
  String get openStats;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @emptyTasks.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet.'**
  String get emptyTasks;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasksTitle;

  /// No description provided for @tasksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize your plans for today'**
  String get tasksSubtitle;

  /// No description provided for @completedTasks.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedTasks;

  /// No description provided for @emptyCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed tasks will appear here.'**
  String get emptyCompleted;

  /// No description provided for @missedTasks.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get missedTasks;

  /// No description provided for @noMissedTasks.
  ///
  /// In en, this message translates to:
  /// **'No missed tasks.'**
  String get noMissedTasks;

  /// No description provided for @editTask.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get editTask;

  /// No description provided for @taskTitleField.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get taskTitleField;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @priorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get priorityLow;

  /// No description provided for @priorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get priorityMedium;

  /// No description provided for @priorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get priorityHigh;

  /// No description provided for @repeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get repeat;

  /// No description provided for @repeatNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get repeatNone;

  /// No description provided for @repeatDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get repeatDaily;

  /// No description provided for @repeatWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get repeatWeekly;

  /// No description provided for @repeatMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get repeatMonthly;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @reminderEnabled.
  ///
  /// In en, this message translates to:
  /// **'Reminder enabled'**
  String get reminderEnabled;

  /// No description provided for @noTime.
  ///
  /// In en, this message translates to:
  /// **'No time'**
  String get noTime;

  /// No description provided for @choose.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get choose;

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

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @taskReadQuranTitle.
  ///
  /// In en, this message translates to:
  /// **'Read Quran'**
  String get taskReadQuranTitle;

  /// No description provided for @taskReadQuranDesc.
  ///
  /// In en, this message translates to:
  /// **'Read at least one page with focus.'**
  String get taskReadQuranDesc;

  /// No description provided for @taskPushupsTitle.
  ///
  /// In en, this message translates to:
  /// **'10 push-ups'**
  String get taskPushupsTitle;

  /// No description provided for @taskPushupsDesc.
  ///
  /// In en, this message translates to:
  /// **'A quick body reset.'**
  String get taskPushupsDesc;

  /// No description provided for @taskReadBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Read a book'**
  String get taskReadBookTitle;

  /// No description provided for @taskReadBookDesc.
  ///
  /// In en, this message translates to:
  /// **'Ten quiet pages before rest.'**
  String get taskReadBookDesc;

  /// No description provided for @prayerTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get prayerTitle;

  /// No description provided for @todaySchedule.
  ///
  /// In en, this message translates to:
  /// **'Today schedule'**
  String get todaySchedule;

  /// No description provided for @prayerSettings.
  ///
  /// In en, this message translates to:
  /// **'Prayer settings'**
  String get prayerSettings;

  /// No description provided for @prayerFajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// No description provided for @prayerSunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// No description provided for @prayerDhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// No description provided for @prayerAsr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// No description provided for @prayerMaghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// No description provided for @prayerIsha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// No description provided for @statusUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get statusUpcoming;

  /// No description provided for @statusCurrent.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get statusCurrent;

  /// No description provided for @statusPast.
  ///
  /// In en, this message translates to:
  /// **'Passed'**
  String get statusPast;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @adhan.
  ///
  /// In en, this message translates to:
  /// **'Adhan'**
  String get adhan;

  /// No description provided for @timeUntilPrayer.
  ///
  /// In en, this message translates to:
  /// **'{duration} until {prayer}'**
  String timeUntilPrayer(String duration, String prayer);

  /// No description provided for @habitQuran.
  ///
  /// In en, this message translates to:
  /// **'Read Quran'**
  String get habitQuran;

  /// No description provided for @habitBook.
  ///
  /// In en, this message translates to:
  /// **'Read a book'**
  String get habitBook;

  /// No description provided for @habitPushups.
  ///
  /// In en, this message translates to:
  /// **'Push-ups'**
  String get habitPushups;

  /// No description provided for @habitEnglish.
  ///
  /// In en, this message translates to:
  /// **'Learn English'**
  String get habitEnglish;

  /// No description provided for @habitProgramming.
  ///
  /// In en, this message translates to:
  /// **'Learn programming'**
  String get habitProgramming;

  /// No description provided for @habitWater.
  ///
  /// In en, this message translates to:
  /// **'Drink water'**
  String get habitWater;

  /// No description provided for @addHabit.
  ///
  /// In en, this message translates to:
  /// **'Add habit'**
  String get addHabit;

  /// No description provided for @editHabit.
  ///
  /// In en, this message translates to:
  /// **'Edit habit'**
  String get editHabit;

  /// No description provided for @emptyHabits.
  ///
  /// In en, this message translates to:
  /// **'No habits yet.'**
  String get emptyHabits;

  /// No description provided for @habitName.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitName;

  /// No description provided for @targetPerDay.
  ///
  /// In en, this message translates to:
  /// **'Target per day'**
  String get targetPerDay;

  /// No description provided for @habitProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{target} today'**
  String habitProgress(int completed, int target);

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} day streak'**
  String streakDays(int count);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @emptyNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet.'**
  String get emptyNotes;

  /// No description provided for @editNote.
  ///
  /// In en, this message translates to:
  /// **'Edit note'**
  String get editNote;

  /// No description provided for @noteTitleField.
  ///
  /// In en, this message translates to:
  /// **'Note title'**
  String get noteTitleField;

  /// No description provided for @noteContentField.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get noteContentField;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @noteToTask.
  ///
  /// In en, this message translates to:
  /// **'Make task'**
  String get noteToTask;

  /// No description provided for @tasksDoneToday.
  ///
  /// In en, this message translates to:
  /// **'Tasks done today'**
  String get tasksDoneToday;

  /// No description provided for @tasksMissed.
  ///
  /// In en, this message translates to:
  /// **'Tasks missed'**
  String get tasksMissed;

  /// No description provided for @completion.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get completion;

  /// No description provided for @weekActivity.
  ///
  /// In en, this message translates to:
  /// **'Week activity'**
  String get weekActivity;

  /// No description provided for @streaks.
  ///
  /// In en, this message translates to:
  /// **'Streaks'**
  String get streaks;

  /// No description provided for @taskStreak.
  ///
  /// In en, this message translates to:
  /// **'Tasks: {count}d'**
  String taskStreak(int count);

  /// No description provided for @habitStreak.
  ///
  /// In en, this message translates to:
  /// **'Habits: {count}d'**
  String habitStreak(int count);

  /// No description provided for @prayerStreak.
  ///
  /// In en, this message translates to:
  /// **'Prayer: {count}d'**
  String prayerStreak(int count);

  /// No description provided for @appStreak.
  ///
  /// In en, this message translates to:
  /// **'App: {count}d'**
  String appStreak(int count);

  /// No description provided for @perfectDayStreak.
  ///
  /// In en, this message translates to:
  /// **'Perfect days: {count}d'**
  String perfectDayStreak(int count);

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @bestWeekday.
  ///
  /// In en, this message translates to:
  /// **'Best weekday'**
  String get bestWeekday;

  /// No description provided for @stableHabit.
  ///
  /// In en, this message translates to:
  /// **'Most stable habit'**
  String get stableHabit;

  /// No description provided for @mostMissedTask.
  ///
  /// In en, this message translates to:
  /// **'Most missed task'**
  String get mostMissedTask;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

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

  /// No description provided for @aiTitle.
  ///
  /// In en, this message translates to:
  /// **'AI mentor'**
  String get aiTitle;

  /// No description provided for @clearAiHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear AI history'**
  String get clearAiHistory;

  /// No description provided for @aiEmpty.
  ///
  /// In en, this message translates to:
  /// **'Ask about your day, laziness, tasks, prayer time, or a tiny next step.'**
  String get aiEmpty;

  /// No description provided for @aiInputHint.
  ///
  /// In en, this message translates to:
  /// **'Message your mentor...'**
  String get aiInputHint;

  /// No description provided for @aiOffReply.
  ///
  /// In en, this message translates to:
  /// **'AI mentor is turned off in settings.'**
  String get aiOffReply;

  /// No description provided for @aiLazyReply.
  ///
  /// In en, this message translates to:
  /// **'I get it. Do not do everything, do one tiny step. Before {prayer} in {duration}, finish 2 minutes and keep your {streak}-day streak alive.'**
  String aiLazyReply(String prayer, String duration, int streak);

  /// No description provided for @aiSoftReply.
  ///
  /// In en, this message translates to:
  /// **'{name}, you have {openTasks} open tasks. Next prayer is {prayer} in {duration}. Pick the smallest one and close it calmly.'**
  String aiSoftReply(
    String name,
    int openTasks,
    String prayer,
    String duration,
  );

  /// No description provided for @aiNormalReply.
  ///
  /// In en, this message translates to:
  /// **'You completed {completedTasks} tasks and still have {openTasks}. {prayer} is in {duration}. Close one small action now, then rest cleaner.'**
  String aiNormalReply(
    int completedTasks,
    int openTasks,
    String prayer,
    String duration,
  );

  /// No description provided for @aiStrictReply.
  ///
  /// In en, this message translates to:
  /// **'Bro, {openTasks} tasks are still open. {prayer} is in {duration}. Do 2 minutes now. This is for you, not for anyone else.'**
  String aiStrictReply(int openTasks, String prayer, String duration);

  /// No description provided for @aiContextTitle.
  ///
  /// In en, this message translates to:
  /// **'Live context'**
  String get aiContextTitle;

  /// No description provided for @aiContextTasks.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} tasks'**
  String aiContextTasks(int completed, int total);

  /// No description provided for @aiContextHabits.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{total} habits'**
  String aiContextHabits(int completed, int total);

  /// No description provided for @aiContextNextPrayer.
  ///
  /// In en, this message translates to:
  /// **'{prayer} in {duration}'**
  String aiContextNextPrayer(String prayer, String duration);

  /// No description provided for @aiContextStreak.
  ///
  /// In en, this message translates to:
  /// **'{count}d streak'**
  String aiContextStreak(int count);

  /// No description provided for @aiTyping.
  ///
  /// In en, this message translates to:
  /// **'Mentor is thinking...'**
  String get aiTyping;

  /// No description provided for @aiQuickLazy.
  ///
  /// In en, this message translates to:
  /// **'I\'m lazy'**
  String get aiQuickLazy;

  /// No description provided for @aiQuickPlanDay.
  ///
  /// In en, this message translates to:
  /// **'Plan my day'**
  String get aiQuickPlanDay;

  /// No description provided for @aiQuickSummary.
  ///
  /// In en, this message translates to:
  /// **'Daily summary'**
  String get aiQuickSummary;

  /// No description provided for @aiQuickMotivate.
  ///
  /// In en, this message translates to:
  /// **'Motivate me'**
  String get aiQuickMotivate;

  /// No description provided for @aiErrorPrefix.
  ///
  /// In en, this message translates to:
  /// **'AI error'**
  String get aiErrorPrefix;

  /// No description provided for @aiUnavailable.
  ///
  /// In en, this message translates to:
  /// **'AI is temporarily unavailable. Try again later.'**
  String get aiUnavailable;

  /// No description provided for @aiModeOffNotice.
  ///
  /// In en, this message translates to:
  /// **'AI mode is off. You can enable it in settings.'**
  String get aiModeOffNotice;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @prayerNotifications.
  ///
  /// In en, this message translates to:
  /// **'Prayer notifications'**
  String get prayerNotifications;

  /// No description provided for @aiSettings.
  ///
  /// In en, this message translates to:
  /// **'AI settings'**
  String get aiSettings;

  /// No description provided for @aiAssistantToggle.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistantToggle;

  /// No description provided for @aiBackendConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected via backend'**
  String get aiBackendConnected;

  /// No description provided for @aiPrivacyNote.
  ///
  /// In en, this message translates to:
  /// **'AI uses only the data needed for advice: tasks, habits, streak, prayer, and statistics.'**
  String get aiPrivacyNote;

  /// No description provided for @aiAlwaysOn.
  ///
  /// In en, this message translates to:
  /// **'AI is always enabled'**
  String get aiAlwaysOn;

  /// No description provided for @backgroundStyle.
  ///
  /// In en, this message translates to:
  /// **'App background'**
  String get backgroundStyle;

  /// No description provided for @backgroundAurora.
  ///
  /// In en, this message translates to:
  /// **'Aurora'**
  String get backgroundAurora;

  /// No description provided for @backgroundSteppe.
  ///
  /// In en, this message translates to:
  /// **'Steppe'**
  String get backgroundSteppe;

  /// No description provided for @backgroundParticles.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get backgroundParticles;

  /// No description provided for @prayerCorrectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer time correction'**
  String get prayerCorrectionTitle;

  /// No description provided for @syncWithSajda.
  ///
  /// In en, this message translates to:
  /// **'Sync with Sajda / local mosque'**
  String get syncWithSajda;

  /// No description provided for @manualPrayerCorrection.
  ///
  /// In en, this message translates to:
  /// **'Manual correction'**
  String get manualPrayerCorrection;

  /// No description provided for @prayerCorrectionExplanation.
  ///
  /// In en, this message translates to:
  /// **'Prayer times may differ between apps because of calculation methods and local timetables. Adjust these offsets to match Sajda or your local mosque.'**
  String get prayerCorrectionExplanation;

  /// No description provided for @resetPrayerCorrection.
  ///
  /// In en, this message translates to:
  /// **'Reset correction'**
  String get resetPrayerCorrection;

  /// No description provided for @voiceSettings.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voiceSettings;

  /// No description provided for @voiceInput.
  ///
  /// In en, this message translates to:
  /// **'Voice input'**
  String get voiceInput;

  /// No description provided for @voiceReply.
  ///
  /// In en, this message translates to:
  /// **'Voice reply'**
  String get voiceReply;

  /// No description provided for @autoSpeakAiReply.
  ///
  /// In en, this message translates to:
  /// **'Auto speak AI reply'**
  String get autoSpeakAiReply;

  /// No description provided for @voiceRate.
  ///
  /// In en, this message translates to:
  /// **'Voice rate'**
  String get voiceRate;

  /// No description provided for @voicePitch.
  ///
  /// In en, this message translates to:
  /// **'Voice pitch'**
  String get voicePitch;

  /// No description provided for @microphonePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission required'**
  String get microphonePermissionRequired;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @tapToSpeak.
  ///
  /// In en, this message translates to:
  /// **'Tap to speak'**
  String get tapToSpeak;

  /// No description provided for @stopSpeaking.
  ///
  /// In en, this message translates to:
  /// **'Stop speaking'**
  String get stopSpeaking;

  /// No description provided for @speechRecognitionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition unavailable'**
  String get speechRecognitionUnavailable;

  /// No description provided for @voiceLanguageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Voice language unavailable'**
  String get voiceLanguageUnavailable;

  /// No description provided for @ttsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Text-to-speech unavailable'**
  String get ttsUnavailable;

  /// No description provided for @noSpeechDetected.
  ///
  /// In en, this message translates to:
  /// **'No speech detected'**
  String get noSpeechDetected;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get exportData;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @restartOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Restart onboarding'**
  String get restartOnboarding;

  /// No description provided for @stub.
  ///
  /// In en, this message translates to:
  /// **'Coming later'**
  String get stub;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'kk', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'kk':
      return AppLocalizationsKk();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
