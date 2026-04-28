import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService.instance,
);

enum AppNotificationChannel {
  tasks('baraka_tasks', 'Tasks'),
  habits('baraka_habits', 'Habits'),
  prayer('baraka_prayer', 'Prayer'),
  aiMentor('baraka_ai_mentor', 'AI mentor'),
  dailySummary('baraka_daily_summary', 'Daily summary');

  const AppNotificationChannel(this.id, this.title);

  final String id;
  final String title;
}

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  Future<void>? _initializing;

  Future<void> initialize() async {
    if (_isInitialized) {
      return;
    }
    if (_initializing != null) {
      return _initializing;
    }

    _initializing = _doInitialize();
    try {
      await _initializing;
    } finally {
      if (!_isInitialized) {
        _initializing = null;
      }
    }
  }

  Future<void> _doInitialize() async {
    await _configureTimezone();
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const settings = InitializationSettings(android: android, iOS: darwin);
    await _plugin.initialize(settings: settings);
    _isInitialized = true;
    _initializing = null;
  }

  Future<bool> requestPermissions() async {
    await initialize();
    final android = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
    final ios = await _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    return android ?? ios ?? true;
  }

  Future<bool> requestExactAlarmPermission() async {
    await initialize();
    final android = await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestExactAlarmsPermission();

    return android ?? false;
  }

  Future<void> cancelPendingForReschedule() async {
    await initialize();
    return _plugin.cancelAllPendingNotifications();
  }

  Future<void> cancel({required int id}) async {
    await initialize();
    return _plugin.cancel(id: id);
  }

  Future<void> cancelAll() async {
    await initialize();
    return _plugin.cancelAll();
  }

  Future<void> scheduleOneShot({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required AppNotificationChannel channel,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
    String? payload,
  }) async {
    await initialize();
    final next = _nextFutureDate(scheduledAt);
    if (next == null) {
      await cancel(id: id);
      return;
    }

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(next, tz.local),
      notificationDetails: _details(
        channel: channel,
        soundEnabled: soundEnabled,
        vibrationEnabled: vibrationEnabled,
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> scheduleDaily({
    required int id,
    required String title,
    required String body,
    required DateTime firstAt,
    required AppNotificationChannel channel,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
    String? payload,
  }) async {
    await initialize();
    return _scheduleRepeating(
      id: id,
      title: title,
      body: body,
      scheduledAt: _nextDaily(firstAt),
      channel: channel,
      matchDateTimeComponents: DateTimeComponents.time,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      payload: payload,
    );
  }

  Future<void> scheduleWeekly({
    required int id,
    required String title,
    required String body,
    required DateTime firstAt,
    required AppNotificationChannel channel,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
    String? payload,
  }) async {
    await initialize();
    return _scheduleRepeating(
      id: id,
      title: title,
      body: body,
      scheduledAt: _nextWeekly(firstAt),
      channel: channel,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      payload: payload,
    );
  }

  Future<void> scheduleMonthly({
    required int id,
    required String title,
    required String body,
    required DateTime firstAt,
    required AppNotificationChannel channel,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
    String? payload,
  }) async {
    await initialize();
    return _scheduleRepeating(
      id: id,
      title: title,
      body: body,
      scheduledAt: _nextMonthly(firstAt),
      channel: channel,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      soundEnabled: soundEnabled,
      vibrationEnabled: vibrationEnabled,
      payload: payload,
    );
  }

  Future<void> showTaskReminder({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();
    return _show(
      id: id,
      title: title,
      body: body,
      channel: AppNotificationChannel.tasks,
    );
  }

  Future<void> showPrayerReminder({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();
    return _show(
      id: id,
      title: title,
      body: body,
      channel: AppNotificationChannel.prayer,
    );
  }

  Future<void> showHabitReminder({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();
    return _show(
      id: id,
      title: title,
      body: body,
      channel: AppNotificationChannel.habits,
    );
  }

  Future<void> showAiReminder({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();
    return _show(
      id: id,
      title: title,
      body: body,
      channel: AppNotificationChannel.aiMentor,
    );
  }

  Future<void> showDailySummary({
    required int id,
    required String title,
    required String body,
  }) async {
    await initialize();
    return _show(
      id: id,
      title: title,
      body: body,
      channel: AppNotificationChannel.dailySummary,
    );
  }

  Future<void> _scheduleRepeating({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledAt,
    required AppNotificationChannel channel,
    required DateTimeComponents matchDateTimeComponents,
    required bool soundEnabled,
    required bool vibrationEnabled,
    String? payload,
  }) {
    return _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
      notificationDetails: _details(
        channel: channel,
        soundEnabled: soundEnabled,
        vibrationEnabled: vibrationEnabled,
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: matchDateTimeComponents,
    );
  }

  Future<void> _show({
    required int id,
    required String title,
    required String body,
    required AppNotificationChannel channel,
  }) {
    return _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _details(channel: channel),
    );
  }

  NotificationDetails _details({
    required AppNotificationChannel channel,
    bool soundEnabled = true,
    bool vibrationEnabled = true,
  }) {
    final channelId = soundEnabled ? channel.id : '${channel.id}_silent';

    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channel.title,
        channelDescription: 'Baraka AI ${channel.title} notifications',
        importance: Importance.high,
        priority: Priority.high,
        playSound: soundEnabled,
        enableVibration: vibrationEnabled,
        // TODO: Add raw Android sound resources later, e.g. res/raw/adhan.mp3,
        // and set RawResourceAndroidNotificationSound('adhan') for prayer.
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: soundEnabled,
      ),
    );
  }

  Future<void> _configureTimezone() async {
    tz_data.initializeTimeZones();
    try {
      final localTimezone = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(localTimezone.identifier));
    } on Object {
      tz.setLocalLocation(tz.getLocation('UTC'));
    }
  }

  DateTime? _nextFutureDate(DateTime scheduledAt) {
    if (scheduledAt.isAfter(DateTime.now())) {
      return scheduledAt;
    }
    return null;
  }

  DateTime _nextDaily(DateTime scheduledAt) {
    var next = scheduledAt;
    final now = DateTime.now();
    while (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }
    return next;
  }

  DateTime _nextWeekly(DateTime scheduledAt) {
    var next = scheduledAt;
    final now = DateTime.now();
    while (!next.isAfter(now)) {
      next = next.add(const Duration(days: 7));
    }
    return next;
  }

  DateTime _nextMonthly(DateTime scheduledAt) {
    var next = scheduledAt;
    final now = DateTime.now();
    while (!next.isAfter(now)) {
      final nextMonth = next.month == 12 ? 1 : next.month + 1;
      final nextYear = next.month == 12 ? next.year + 1 : next.year;
      final maxDay = DateTime(nextYear, nextMonth + 1, 0).day;
      next = DateTime(
        nextYear,
        nextMonth,
        next.day.clamp(1, maxDay),
        next.hour,
        next.minute,
      );
    }
    return next;
  }
}
