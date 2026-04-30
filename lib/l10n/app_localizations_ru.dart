// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Baraka AI';

  @override
  String get homeTab => 'Главная';

  @override
  String get tasksTab => 'Задачи';

  @override
  String get prayerTab => 'Намаз';

  @override
  String get aiTab => 'AI';

  @override
  String get moreTab => 'Еще';

  @override
  String get notesTitle => 'Заметки';

  @override
  String get habitsTitle => 'Привычки';

  @override
  String get statsTitle => 'Статистика';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get onboardingTitle => 'Настрой намерение';

  @override
  String get onboardingSubtitle =>
      'Спокойное мобильное пространство для намаза, задач, привычек, заметок, streak и уважительного AI-наставника.';

  @override
  String get yourName => 'Имя';

  @override
  String get language => 'Язык';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Темная';

  @override
  String get prayerSetup => 'Настройка намаза';

  @override
  String get city => 'Город';

  @override
  String get geolocation => 'Использовать геолокацию';

  @override
  String get calculationMethod => 'Метод расчета';

  @override
  String get madhhab => 'Мазхаб';

  @override
  String get hanafi => 'Ханафи';

  @override
  String get shafii => 'Шафии';

  @override
  String get aiMentorMode => 'Режим AI-наставника';

  @override
  String get aiModeOff => 'Выключен';

  @override
  String get aiModeSoft => 'Мягкий';

  @override
  String get aiModeNormal => 'Средний';

  @override
  String get aiModeStrict => 'Жесткий';

  @override
  String get activeMentor => 'Активный AI-наставник';

  @override
  String get activeMentorHint =>
      'Дополнительные напоминания, если игнорировать задачи или намаз.';

  @override
  String get activeMentorAntiSpam =>
      'Максимум 2 доп. напоминания на пункт и соблюдение тихих часов.';

  @override
  String get requestNotifications => 'Разрешить уведомления';

  @override
  String get startApp => 'Начать';

  @override
  String greetingName(String name) {
    return 'Ассаляму алейкум, $name';
  }

  @override
  String get days => 'дней';

  @override
  String get motivationOne => 'Маленькие искренние шаги тоже считаются.';

  @override
  String get motivationTwo => 'Защити день, пока он не убежал.';

  @override
  String get motivationThree => 'Начни с самого маленького полезного действия.';

  @override
  String get motivationFour => 'Дисциплина легче после первых двух минут.';

  @override
  String get nextPrayer => 'Следующий намаз';

  @override
  String get tasksToday => 'Задачи на сегодня';

  @override
  String taskProgress(int completed, int total) {
    return '$completed/$total выполнено';
  }

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get addTask => 'Добавить задачу';

  @override
  String get addNote => 'Добавить заметку';

  @override
  String get openAi => 'Открыть AI';

  @override
  String get openPrayer => 'Открыть намаз';

  @override
  String get openStats => 'Открыть статистику';

  @override
  String get today => 'Сегодня';

  @override
  String get emptyTasks => 'Пока нет задач.';

  @override
  String get tasksTitle => 'Задачи';

  @override
  String get tasksSubtitle => 'Управляй планами на сегодня';

  @override
  String get completedTasks => 'Выполненные';

  @override
  String get emptyCompleted => 'Выполненные задачи появятся здесь.';

  @override
  String get missedTasks => 'Пропущенные';

  @override
  String get noMissedTasks => 'Пропущенных задач нет.';

  @override
  String get editTask => 'Редактировать задачу';

  @override
  String get taskTitleField => 'Название задачи';

  @override
  String get description => 'Описание';

  @override
  String get category => 'Категория';

  @override
  String get priority => 'Приоритет';

  @override
  String get priorityLow => 'Низкий';

  @override
  String get priorityMedium => 'Средний';

  @override
  String get priorityHigh => 'Высокий';

  @override
  String get repeat => 'Повтор';

  @override
  String get repeatNone => 'Нет';

  @override
  String get repeatDaily => 'Ежедневно';

  @override
  String get repeatWeekly => 'Еженедельно';

  @override
  String get repeatMonthly => 'Ежемесячно';

  @override
  String get reminder => 'Напоминание';

  @override
  String get reminderEnabled => 'Напоминание включено';

  @override
  String get noTime => 'Время не выбрано';

  @override
  String get choose => 'Выбрать';

  @override
  String get save => 'Сохранить';

  @override
  String get cancel => 'Отмена';

  @override
  String get edit => 'Изменить';

  @override
  String get delete => 'Удалить';

  @override
  String get taskReadQuranTitle => 'Читать Коран';

  @override
  String get taskReadQuranDesc =>
      'Прочитать хотя бы одну страницу внимательно.';

  @override
  String get taskPushupsTitle => '10 отжиманий';

  @override
  String get taskPushupsDesc => 'Быстрая перезагрузка тела.';

  @override
  String get taskReadBookTitle => 'Читать книгу';

  @override
  String get taskReadBookDesc => 'Десять спокойных страниц перед отдыхом.';

  @override
  String get prayerTitle => 'Намаз';

  @override
  String get todaySchedule => 'Расписание на сегодня';

  @override
  String get prayerSettings => 'Настройки намаза';

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
  String get statusUpcoming => 'Предстоит';

  @override
  String get statusCurrent => 'Сейчас';

  @override
  String get statusPast => 'Прошел';

  @override
  String get notifications => 'Уведомления';

  @override
  String get sound => 'Звук';

  @override
  String get vibration => 'Вибрация';

  @override
  String get adhan => 'Азан';

  @override
  String timeUntilPrayer(String duration, String prayer) {
    return '$duration до $prayer';
  }

  @override
  String get habitQuran => 'Читать Коран';

  @override
  String get habitBook => 'Читать книгу';

  @override
  String get habitPushups => 'Отжимания';

  @override
  String get habitEnglish => 'Учить английский';

  @override
  String get habitProgramming => 'Учить программирование';

  @override
  String get habitWater => 'Пить воду';

  @override
  String get addHabit => 'Добавить привычку';

  @override
  String get editHabit => 'Редактировать привычку';

  @override
  String get emptyHabits => 'Пока нет привычек.';

  @override
  String get habitName => 'Название привычки';

  @override
  String get targetPerDay => 'Цель на день';

  @override
  String habitProgress(int completed, int target) {
    return '$completed/$target сегодня';
  }

  @override
  String streakDays(int count) {
    return 'streak $count дней';
  }

  @override
  String get search => 'Поиск';

  @override
  String get emptyNotes => 'Пока нет заметок.';

  @override
  String get editNote => 'Редактировать заметку';

  @override
  String get noteTitleField => 'Название заметки';

  @override
  String get noteContentField => 'Содержание';

  @override
  String get tags => 'Теги';

  @override
  String get noteToTask => 'В задачу';

  @override
  String get tasksDoneToday => 'Задач выполнено сегодня';

  @override
  String get tasksMissed => 'Задач пропущено';

  @override
  String get completion => 'Выполнение';

  @override
  String get weekActivity => 'Активность за неделю';

  @override
  String get streaks => 'Streak';

  @override
  String taskStreak(int count) {
    return 'Задачи: $countд';
  }

  @override
  String habitStreak(int count) {
    return 'Привычки: $countд';
  }

  @override
  String prayerStreak(int count) {
    return 'Намаз: $countд';
  }

  @override
  String appStreak(int count) {
    return 'Приложение: $countд';
  }

  @override
  String perfectDayStreak(int count) {
    return 'Идеальные дни: $countд';
  }

  @override
  String get insights => 'Инсайты';

  @override
  String get bestWeekday => 'Лучший день недели';

  @override
  String get stableHabit => 'Самая стабильная привычка';

  @override
  String get mostMissedTask => 'Самая пропускаемая задача';

  @override
  String get noData => 'Нет данных';

  @override
  String get monday => 'Понедельник';

  @override
  String get tuesday => 'Вторник';

  @override
  String get wednesday => 'Среда';

  @override
  String get thursday => 'Четверг';

  @override
  String get friday => 'Пятница';

  @override
  String get saturday => 'Суббота';

  @override
  String get sunday => 'Воскресенье';

  @override
  String get statsSubtitle => 'Твой прогресс за сегодня и неделю';

  @override
  String get statsDone => 'Выполнено';

  @override
  String get statsMissed => 'Пропущено';

  @override
  String get statsProgress => 'Прогресс';

  @override
  String get statsTodayNoActivity =>
      'Сегодня ещё нет активности. Начни с одной маленькой задачи.';

  @override
  String get statsStartSmall => 'Начни с одной маленькой задачи.';

  @override
  String get statsNoTasksToday => 'Нет задач на сегодня';

  @override
  String statsTasksCount(int completed, int total) {
    return '$completed из $total задач';
  }

  @override
  String get statsWeeklyNoData => 'Данные появятся после выполнения задач.';

  @override
  String get statsMondayShort => 'Пн';

  @override
  String get statsTuesdayShort => 'Вт';

  @override
  String get statsWednesdayShort => 'Ср';

  @override
  String get statsThursdayShort => 'Чт';

  @override
  String get statsFridayShort => 'Пт';

  @override
  String get statsSaturdayShort => 'Сб';

  @override
  String get statsSundayShort => 'Вс';

  @override
  String get statsTaskStreakTitle => 'Задачи';

  @override
  String get statsHabitStreakTitle => 'Привычки';

  @override
  String get statsPrayerStreakTitle => 'Намаз';

  @override
  String get statsAppStreakTitle => 'Приложение';

  @override
  String get statsPerfectDayStreakTitle => 'Идеальный день';

  @override
  String get statsTaskStreakHint => 'Выполняй задачи ежедневно';

  @override
  String get statsHabitStreakHint => 'Держи привычки стабильно';

  @override
  String get statsPrayerStreakHint => 'Береги ритм намаза';

  @override
  String get statsAppStreakHint => 'Возвращайся каждый день';

  @override
  String get statsPerfectDayStreakHint => 'Задача, привычка и намаз';

  @override
  String statsDaysCount(int count) {
    return '$count дней';
  }

  @override
  String statsBestStreakInsight(String label, int count) {
    return 'Лучший streak сейчас: $label — $count дней';
  }

  @override
  String get statsCloseDayOneTask =>
      'Сегодня можно закрыть день одной маленькой задачей.';

  @override
  String get statsGreatProgress => 'Хороший прогресс. Держи спокойный ритм.';

  @override
  String get statsPerfectDayInsight =>
      'Идеальный день: выполни задачу, привычку и не пропусти намаз.';

  @override
  String get statsInsightsEmpty =>
      'Инсайты появятся после нескольких дней активности.';

  @override
  String get aiTitle => 'AI-наставник';

  @override
  String get clearAiHistory => 'Очистить историю AI';

  @override
  String get aiEmpty =>
      'Спроси про день, лень, задачи, время намаза или маленький следующий шаг.';

  @override
  String get aiInputHint => 'Напиши наставнику...';

  @override
  String get aiOffReply => 'AI-наставник выключен в настройках.';

  @override
  String aiLazyReply(String prayer, String duration, int streak) {
    return 'Понимаю. Не делай все сразу, сделай один маленький шаг. До $prayer осталось $duration. Сделай 2 минуты и сохрани streak $streak дней.';
  }

  @override
  String aiSoftReply(
    String name,
    int openTasks,
    String prayer,
    String duration,
  ) {
    return '$name, у тебя открыто задач: $openTasks. Следующий намаз $prayer через $duration. Выбери самую маленькую и закрой спокойно.';
  }

  @override
  String aiNormalReply(
    int completedTasks,
    int openTasks,
    String prayer,
    String duration,
  ) {
    return 'Ты выполнил задач: $completedTasks, осталось: $openTasks. $prayer через $duration. Закрой одно маленькое действие сейчас, потом отдых будет спокойнее.';
  }

  @override
  String aiStrictReply(int openTasks, String prayer, String duration) {
    return 'Бро, открытых задач: $openTasks. $prayer через $duration. Сделай 2 минуты сейчас. Это для тебя, не для кого-то.';
  }

  @override
  String get aiContextTitle => 'Живой контекст';

  @override
  String aiContextTasks(int completed, int total) {
    return '$completed/$total задач';
  }

  @override
  String aiContextHabits(int completed, int total) {
    return '$completed/$total привычек';
  }

  @override
  String aiContextNextPrayer(String prayer, String duration) {
    return '$prayer через $duration';
  }

  @override
  String aiContextStreak(int count) {
    return 'streak $countд';
  }

  @override
  String get aiTyping => 'Наставник думает...';

  @override
  String get aiQuickLazy => 'Мне лень';

  @override
  String get aiQuickPlanDay => 'Спланируй день';

  @override
  String get aiQuickSummary => 'Итог дня';

  @override
  String get aiQuickMotivate => 'Мотивируй меня';

  @override
  String get aiErrorPrefix => 'Ошибка AI';

  @override
  String get aiUnavailable => 'AI временно недоступен. Попробуй позже.';

  @override
  String get aiModeOffNotice =>
      'AI-режим выключен. Его можно включить в настройках.';

  @override
  String get profile => 'Профиль';

  @override
  String get prayerNotifications => 'Уведомления намаза';

  @override
  String get aiSettings => 'Настройки AI';

  @override
  String get aiAssistantToggle => 'AI Assistant';

  @override
  String get aiBackendConnected => 'Connected via backend';

  @override
  String get aiPrivacyNote =>
      'AI использует только данные, которые нужны для советов: задачи, привычки, streak, намаз и статистику.';

  @override
  String get aiAlwaysOn => 'AI всегда включен';

  @override
  String get backgroundStyle => 'Фон приложения';

  @override
  String get backgroundAurora => 'Аврора';

  @override
  String get backgroundSteppe => 'Степь';

  @override
  String get backgroundParticles => 'Звезды';

  @override
  String get prayerCorrectionTitle => 'Коррекция времени намаза';

  @override
  String get syncWithSajda => 'Синхронизация с Sajda / местной мечетью';

  @override
  String get manualPrayerCorrection => 'Ручная коррекция';

  @override
  String get prayerCorrectionExplanation =>
      'Время намаза может отличаться в разных приложениях из-за метода расчета и местных расписаний. Вы можете настроить коррекцию, чтобы совпадало с Sajda или местной мечетью.';

  @override
  String get resetPrayerCorrection => 'Сбросить коррекцию';

  @override
  String get voiceSettings => 'Голос';

  @override
  String get voiceInput => 'Голосовой ввод';

  @override
  String get voiceReply => 'Голосовой ответ';

  @override
  String get autoSpeakAiReply => 'Автоматически озвучивать ответ AI';

  @override
  String get voiceRate => 'Скорость голоса';

  @override
  String get voicePitch => 'Тон голоса';

  @override
  String get microphonePermissionRequired => 'Нужно разрешение на микрофон';

  @override
  String get listening => 'Слушаю...';

  @override
  String get tapToSpeak => 'Нажмите, чтобы говорить';

  @override
  String get stopSpeaking => 'Остановить озвучку';

  @override
  String get speechRecognitionUnavailable => 'Распознавание речи недоступно';

  @override
  String get voiceLanguageUnavailable => 'Язык голоса недоступен';

  @override
  String get ttsUnavailable => 'Озвучка недоступна';

  @override
  String get noSpeechDetected => 'Речь не распознана';

  @override
  String get privacy => 'Приватность';

  @override
  String get exportData => 'Экспорт данных';

  @override
  String get deleteAccount => 'Удалить аккаунт';

  @override
  String get restartOnboarding => 'Запустить onboarding заново';

  @override
  String get smartSearch => 'Умный поиск';

  @override
  String get searchByMeaning => 'Поиск по смыслу';

  @override
  String get noResults => 'Нет результатов';

  @override
  String get indexing => 'Индексация...';

  @override
  String get rebuildIndex => 'Пересобрать индекс';

  @override
  String get rebuildAiMemoryIndex => 'Пересобрать индекс AI-памяти';

  @override
  String get searchNotesAndTasks => 'Искать заметки и задачи';

  @override
  String get rerankingResults => 'Переранжирование результатов';

  @override
  String get smartSearchPrivacyNote =>
      'Умный поиск отправляет текст заметок и задач на AI backend для создания embeddings и reranking. API ключ хранится только на backend.';

  @override
  String get indexFailed =>
      'Не удалось проиндексировать часть данных. Проверь настройки embedder на backend.';

  @override
  String get sourceNote => 'Заметка';

  @override
  String get sourceTask => 'Задача';

  @override
  String get sourceHabit => 'Привычка';

  @override
  String get stub => 'Будет позже';

  @override
  String get done => 'Готово';
}
