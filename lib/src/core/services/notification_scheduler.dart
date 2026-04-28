import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/habits/application/habits_controller.dart';
import '../../features/habits/domain/habit.dart';
import '../../features/prayer/application/prayer_controller.dart';
import '../../features/prayer/domain/prayer_time.dart';
import '../../features/settings/application/settings_controller.dart';
import '../../features/settings/domain/user_settings.dart';
import '../../features/tasks/application/tasks_controller.dart';
import '../../features/tasks/domain/task_item.dart';
import 'notification_service.dart';

final notificationSchedulerProvider = Provider<void>((ref) {
  final scheduler = NotificationScheduler(
    ref.read(notificationServiceProvider),
  );
  Timer? debounce;

  void queueReschedule() {
    debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 350), () {
      unawaited(
        scheduler.rescheduleAll(
          settings: ref.read(settingsControllerProvider),
          tasks: ref.read(tasksControllerProvider),
          habits: ref.read(habitsControllerProvider),
          prayers: ref.read(prayerControllerProvider),
        ),
      );
    });
  }

  ref
    ..listen(settingsControllerProvider, (_, _) => queueReschedule())
    ..listen(tasksControllerProvider, (_, _) => queueReschedule())
    ..listen(habitsControllerProvider, (_, _) => queueReschedule())
    ..listen(prayerControllerProvider, (_, _) => queueReschedule())
    ..onDispose(() => debounce?.cancel());

  queueReschedule();
});

class NotificationScheduler {
  NotificationScheduler(this._service);

  final NotificationService _service;
  int _generation = 0;

  Future<void> rescheduleAll({
    required UserSettings settings,
    required List<TaskItem> tasks,
    required List<Habit> habits,
    required List<PrayerTimeItem> prayers,
  }) async {
    final generation = ++_generation;
    await _service.cancelPendingForReschedule();

    if (generation != _generation || !settings.notificationsEnabled) {
      return;
    }

    await _scheduleTasks(settings, tasks);
    await _scheduleHabits(settings, habits);
    await _schedulePrayers(settings, prayers);
  }

  Future<void> _scheduleTasks(
    UserSettings settings,
    List<TaskItem> tasks,
  ) async {
    for (final task in tasks) {
      if (!task.reminderEnabled) {
        continue;
      }
      if (task.isCompleted && task.repeatType == RepeatType.none) {
        continue;
      }

      final scheduledAt = _taskScheduledAt(task);
      if (scheduledAt == null) {
        continue;
      }

      final title = _copy(settings.language).taskTitle;
      final body = _copy(
        settings.language,
      ).taskBody(_taskName(settings.language, task));
      final id = notificationId('task:${task.id}');

      switch (task.repeatType) {
        case RepeatType.none:
          await _service.scheduleOneShot(
            id: id,
            title: title,
            body: body,
            scheduledAt: scheduledAt,
            channel: AppNotificationChannel.tasks,
            payload: 'task:${task.id}',
          );
        case RepeatType.daily:
          await _service.scheduleDaily(
            id: id,
            title: title,
            body: body,
            firstAt: task.isCompleted
                ? scheduledAt.add(const Duration(days: 1))
                : scheduledAt,
            channel: AppNotificationChannel.tasks,
            payload: 'task:${task.id}',
          );
        case RepeatType.weekly:
          await _service.scheduleWeekly(
            id: id,
            title: title,
            body: body,
            firstAt: task.isCompleted
                ? scheduledAt.add(const Duration(days: 7))
                : scheduledAt,
            channel: AppNotificationChannel.tasks,
            payload: 'task:${task.id}',
          );
        case RepeatType.monthly:
          await _service.scheduleMonthly(
            id: id,
            title: title,
            body: body,
            firstAt: task.isCompleted ? _addMonth(scheduledAt) : scheduledAt,
            channel: AppNotificationChannel.tasks,
            payload: 'task:${task.id}',
          );
      }
    }
  }

  Future<void> _scheduleHabits(
    UserSettings settings,
    List<Habit> habits,
  ) async {
    for (final habit in habits) {
      if (!habit.reminderEnabled || habit.reminderTime == null) {
        continue;
      }

      final now = DateTime.now();
      final scheduledAt = DateTime(
        now.year,
        now.month,
        now.day,
        habit.reminderTime!.hour,
        habit.reminderTime!.minute,
      );

      await _service.scheduleDaily(
        id: notificationId('habit:${habit.id}'),
        title: _copy(settings.language).habitTitle,
        body: _copy(
          settings.language,
        ).habitBody(_habitName(settings.language, habit)),
        firstAt: scheduledAt,
        channel: AppNotificationChannel.habits,
        payload: 'habit:${habit.id}',
      );
    }
  }

  Future<void> _schedulePrayers(
    UserSettings settings,
    List<PrayerTimeItem> prayers,
  ) async {
    if (!settings.prayer.notificationsEnabled) {
      return;
    }

    final now = DateTime.now();
    for (final prayer in prayers) {
      if (!prayer.time.isAfter(now)) {
        continue;
      }

      await _service.scheduleOneShot(
        id: notificationId('prayer:${prayer.type.name}'),
        title: _copy(settings.language).prayerTitle,
        body: _copy(
          settings.language,
        ).prayerBody(_prayerName(settings.language, prayer.type)),
        scheduledAt: prayer.time,
        channel: AppNotificationChannel.prayer,
        soundEnabled:
            settings.prayer.soundEnabled || settings.prayer.adhanEnabled,
        vibrationEnabled: settings.prayer.vibrationEnabled,
        payload: 'prayer:${prayer.type.name}',
      );
    }
  }

  DateTime? _taskScheduledAt(TaskItem task) {
    final base = task.reminderTime ?? _dateAndTime(task.date, task.time);
    if (base == null) {
      return null;
    }
    return base;
  }

  DateTime? _dateAndTime(DateTime date, dynamic time) {
    if (time == null) {
      return null;
    }
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  DateTime _addMonth(DateTime value) {
    final nextMonth = value.month == 12 ? 1 : value.month + 1;
    final nextYear = value.month == 12 ? value.year + 1 : value.year;
    final maxDay = DateTime(nextYear, nextMonth + 1, 0).day;
    return DateTime(
      nextYear,
      nextMonth,
      value.day.clamp(1, maxDay),
      value.hour,
      value.minute,
    );
  }

  String _taskName(AppLanguage language, TaskItem task) {
    return switch (task.seedKind) {
      SeedTaskKind.readQuran => _copy(language).readQuran,
      SeedTaskKind.pushups => _copy(language).pushups,
      SeedTaskKind.readBook => _copy(language).readBook,
      SeedTaskKind.english => _copy(language).english,
      null => task.title,
    };
  }

  String _habitName(AppLanguage language, Habit habit) {
    return switch (habit.seedKind) {
      SeedHabitKind.quran => _copy(language).readQuran,
      SeedHabitKind.book => _copy(language).readBook,
      SeedHabitKind.pushups => _copy(language).pushups,
      SeedHabitKind.english => _copy(language).english,
      SeedHabitKind.programming => _copy(language).programming,
      SeedHabitKind.water => _copy(language).water,
      null => habit.name,
    };
  }

  String _prayerName(AppLanguage language, PrayerType type) {
    final copy = _copy(language);
    return switch (type) {
      PrayerType.fajr => copy.fajr,
      PrayerType.sunrise => copy.sunrise,
      PrayerType.dhuhr => copy.dhuhr,
      PrayerType.asr => copy.asr,
      PrayerType.maghrib => copy.maghrib,
      PrayerType.isha => copy.isha,
    };
  }

  _NotificationCopy _copy(AppLanguage language) {
    return switch (language) {
      AppLanguage.en => _NotificationCopy.en,
      AppLanguage.kk => _NotificationCopy.kk,
      AppLanguage.ru => _NotificationCopy.ru,
    };
  }
}

int notificationId(String key) {
  var hash = 0;
  for (final codeUnit in key.codeUnits) {
    hash = (hash * 31 + codeUnit) & 0x7fffffff;
  }
  return hash;
}

class _NotificationCopy {
  const _NotificationCopy({
    required this.taskTitle,
    required this.habitTitle,
    required this.prayerTitle,
    required this.readQuran,
    required this.pushups,
    required this.readBook,
    required this.english,
    required this.programming,
    required this.water,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.taskBody,
    required this.habitBody,
    required this.prayerBody,
  });

  final String taskTitle;
  final String habitTitle;
  final String prayerTitle;
  final String readQuran;
  final String pushups;
  final String readBook;
  final String english;
  final String programming;
  final String water;
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String Function(String item) taskBody;
  final String Function(String item) habitBody;
  final String Function(String item) prayerBody;

  static final ru = _NotificationCopy(
    taskTitle: 'Задача',
    habitTitle: 'Привычка',
    prayerTitle: 'Намаз',
    readQuran: 'Читать Коран',
    pushups: '10 отжиманий',
    readBook: 'Читать книгу',
    english: 'Учить английский',
    programming: 'Учить программирование',
    water: 'Пить воду',
    fajr: 'Фаджр',
    sunrise: 'Восход',
    dhuhr: 'Зухр',
    asr: 'Аср',
    maghrib: 'Магриб',
    isha: 'Иша',
    taskBody: (item) => 'Пора закрыть: $item',
    habitBody: (item) => 'Время для привычки: $item',
    prayerBody: (item) => '$item сейчас. Остановись на пару минут.',
  );

  static final en = _NotificationCopy(
    taskTitle: 'Task',
    habitTitle: 'Habit',
    prayerTitle: 'Prayer',
    readQuran: 'Read Quran',
    pushups: '10 push-ups',
    readBook: 'Read a book',
    english: 'Learn English',
    programming: 'Learn programming',
    water: 'Drink water',
    fajr: 'Fajr',
    sunrise: 'Sunrise',
    dhuhr: 'Dhuhr',
    asr: 'Asr',
    maghrib: 'Maghrib',
    isha: 'Isha',
    taskBody: (item) => 'Time to close: $item',
    habitBody: (item) => 'Time for your habit: $item',
    prayerBody: (item) => '$item is now. Pause for a moment.',
  );

  static final kk = _NotificationCopy(
    taskTitle: 'Тапсырма',
    habitTitle: 'Әдет',
    prayerTitle: 'Намаз',
    readQuran: 'Құран оқу',
    pushups: '10 рет итерілу',
    readBook: 'Кітап оқу',
    english: 'Ағылшын оқу',
    programming: 'Бағдарламалау оқу',
    water: 'Су ішу',
    fajr: 'Фаджр',
    sunrise: 'Күн шығу',
    dhuhr: 'Зухр',
    asr: 'Аср',
    maghrib: 'Магриб',
    isha: 'Иша',
    taskBody: (item) => 'Орындау уақыты: $item',
    habitBody: (item) => 'Әдет уақыты: $item',
    prayerBody: (item) => '$item уақыты кірді. Бір сәт тоқта.',
  );
}
