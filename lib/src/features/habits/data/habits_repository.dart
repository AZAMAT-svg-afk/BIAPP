import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../domain/habit.dart';

class HabitsRepository {
  HabitsRepository(this._database);

  final AppDatabase _database;

  Stream<List<Habit>> watchHabits() async* {
    await ensureSeedData();
    yield* (_database.select(_database.habitRecords)
          ..orderBy([(habit) => OrderingTerm.desc(habit.updatedAt)]))
        .watch()
        .asyncMap(_mapRecords);
  }

  Future<void> ensureSeedData() async {
    final existing = await (_database.select(
      _database.habitRecords,
    )..limit(1)).get();
    if (existing.isNotEmpty) {
      return;
    }

    final now = DateTime.now();
    final habits = [
      Habit(
        id: 'habit-quran',
        name: 'quran',
        category: 'worship',
        streak: 8,
        targetPerDay: 1,
        completedToday: 0,
        reminderEnabled: true,
        reminderTime: const TimeOfDay(hour: 7, minute: 20),
        createdAt: now,
        updatedAt: now,
        seedKind: SeedHabitKind.quran,
      ),
      Habit(
        id: 'habit-water',
        name: 'water',
        category: 'health',
        streak: 5,
        targetPerDay: 6,
        completedToday: 3,
        reminderEnabled: true,
        reminderTime: const TimeOfDay(hour: 10, minute: 0),
        createdAt: now,
        updatedAt: now,
        seedKind: SeedHabitKind.water,
      ),
      Habit(
        id: 'habit-programming',
        name: 'programming',
        category: 'growth',
        streak: 12,
        targetPerDay: 1,
        completedToday: 1,
        reminderEnabled: false,
        createdAt: now,
        updatedAt: now,
        seedKind: SeedHabitKind.programming,
      ),
    ];

    await _database.batch((batch) {
      batch.insertAll(
        _database.habitRecords,
        habits.map(_toRecordCompanion).toList(),
        mode: InsertMode.insertOrIgnore,
      );
    });

    await _seedHabitHistory('habit-quran', 8, 1);
    await _seedHabitHistory('habit-water', 5, 6);
    await _seedHabitHistory('habit-programming', 12, 1, includeToday: true);
    await _upsertCheckIn('habit-water', dateOnly(DateTime.now()), 3);
  }

  Future<void> addHabit(Habit habit) {
    return _database
        .into(_database.habitRecords)
        .insertOnConflictUpdate(_toRecordCompanion(habit));
  }

  Future<void> updateHabit(Habit habit) {
    return _database
        .into(_database.habitRecords)
        .insertOnConflictUpdate(_toRecordCompanion(habit));
  }

  Future<void> checkHabit(Habit habit) async {
    final today = dateOnly(DateTime.now());
    final existing =
        await (_database.select(_database.habitCheckInRecords)..where(
              (row) => row.habitId.equals(habit.id) & row.date.equals(today),
            ))
            .getSingleOrNull();
    final nextCount = ((existing?.count ?? 0) + 1).clamp(0, habit.targetPerDay);
    await _upsertCheckIn(habit.id, today, nextCount);
    await updateHabit(
      habit.copyWith(updatedAt: DateTime.now(), seedKind: null),
    );
  }

  Future<void> deleteHabit(String id) async {
    await (_database.delete(
      _database.habitCheckInRecords,
    )..where((row) => row.habitId.equals(id))).go();
    await (_database.delete(
      _database.habitRecords,
    )..where((row) => row.id.equals(id))).go();
  }

  Future<List<Habit>> _mapRecords(List<HabitRecord> records) async {
    final checkIns = await _database
        .select(_database.habitCheckInRecords)
        .get();
    return [for (final record in records) _fromRecord(record, checkIns)];
  }

  Habit _fromRecord(HabitRecord record, List<HabitCheckInRecord> checkIns) {
    final related = checkIns
        .where((item) => item.habitId == record.id)
        .toList();
    final today = dateOnly(DateTime.now());
    final todayCount = related
        .where((item) => item.date == today)
        .fold<int>(0, (total, item) => total + item.count);

    return Habit(
      id: record.id,
      name: record.name,
      category: record.category,
      streak: _calculateStreak(related, record.targetPerDay, today),
      targetPerDay: record.targetPerDay,
      completedToday: todayCount.clamp(0, record.targetPerDay),
      reminderEnabled: record.reminderEnabled,
      reminderTime: _minutesToTime(record.reminderMinutes),
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      seedKind: record.seedKind == null
          ? null
          : _enumByName(SeedHabitKind.values, record.seedKind!),
    );
  }

  int _calculateStreak(
    List<HabitCheckInRecord> checkIns,
    int targetPerDay,
    DateTime today,
  ) {
    final completedDates = {
      for (final item in checkIns)
        if (item.count >= targetPerDay) dateOnly(item.date),
    };
    var cursor = completedDates.contains(today)
        ? today
        : today.subtract(const Duration(days: 1));
    var streak = 0;
    while (completedDates.contains(cursor)) {
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return streak;
  }

  HabitRecordsCompanion _toRecordCompanion(Habit habit) {
    return HabitRecordsCompanion(
      id: Value(habit.id),
      name: Value(habit.name),
      category: Value(habit.category),
      targetPerDay: Value(habit.targetPerDay),
      reminderEnabled: Value(habit.reminderEnabled),
      reminderMinutes: Value(_timeToMinutes(habit.reminderTime)),
      seedKind: Value(habit.seedKind?.name),
      createdAt: Value(habit.createdAt),
      updatedAt: Value(habit.updatedAt),
    );
  }

  Future<void> _seedHabitHistory(
    String habitId,
    int days,
    int count, {
    bool includeToday = false,
  }) async {
    final today = dateOnly(DateTime.now());
    final startOffset = includeToday ? 0 : 1;
    for (var offset = startOffset; offset < days + startOffset; offset++) {
      await _upsertCheckIn(
        habitId,
        today.subtract(Duration(days: offset)),
        count,
      );
    }
  }

  Future<void> _upsertCheckIn(String habitId, DateTime date, int count) {
    return _database
        .into(_database.habitCheckInRecords)
        .insertOnConflictUpdate(
          HabitCheckInRecordsCompanion(
            habitId: Value(habitId),
            date: Value(dateOnly(date)),
            count: Value(count),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  int? _timeToMinutes(TimeOfDay? time) {
    if (time == null) {
      return null;
    }
    return time.hour * 60 + time.minute;
  }

  TimeOfDay? _minutesToTime(int? value) {
    if (value == null) {
      return null;
    }
    return TimeOfDay(hour: value ~/ 60, minute: value % 60);
  }

  T _enumByName<T extends Enum>(List<T> values, String name) {
    return values.firstWhere(
      (value) => value.name == name,
      orElse: () => values.first,
    );
  }
}
