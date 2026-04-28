import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../domain/task_item.dart';

class TasksRepository {
  TasksRepository(this._database);

  final AppDatabase _database;

  Stream<List<TaskItem>> watchTasks() async* {
    await ensureSeedData();
    yield* (_database.select(_database.taskRecords)..orderBy([
          (task) => OrderingTerm.desc(task.date),
          (task) => OrderingTerm.desc(task.updatedAt),
        ]))
        .watch()
        .map((records) => records.map(_fromRecord).toList());
  }

  Future<void> ensureSeedData() async {
    final existing = await (_database.select(
      _database.taskRecords,
    )..limit(1)).get();
    if (existing.isNotEmpty) {
      return;
    }
    final now = DateTime.now();
    final today = dateOnly(now);
    final seedTasks = [
      TaskItem(
        id: 'task-quran',
        title: 'read_quran',
        description: 'read_quran_desc',
        date: today,
        time: const TimeOfDay(hour: 7, minute: 30),
        isCompleted: false,
        priority: TaskPriority.high,
        category: 'worship',
        reminderEnabled: true,
        reminderTime: today.add(const Duration(hours: 7)),
        repeatType: RepeatType.daily,
        createdAt: now,
        updatedAt: now,
        seedKind: SeedTaskKind.readQuran,
      ),
      TaskItem(
        id: 'task-pushups',
        title: 'pushups',
        description: 'pushups_desc',
        date: today,
        time: const TimeOfDay(hour: 18, minute: 10),
        isCompleted: false,
        priority: TaskPriority.medium,
        category: 'health',
        reminderEnabled: true,
        reminderTime: today.add(const Duration(hours: 18)),
        repeatType: RepeatType.daily,
        createdAt: now,
        updatedAt: now,
        seedKind: SeedTaskKind.pushups,
      ),
      TaskItem(
        id: 'task-book',
        title: 'read_book',
        description: 'read_book_desc',
        date: today,
        time: const TimeOfDay(hour: 21, minute: 0),
        isCompleted: true,
        priority: TaskPriority.low,
        category: 'growth',
        reminderEnabled: false,
        repeatType: RepeatType.none,
        completedAt: now,
        createdAt: now,
        updatedAt: now,
        seedKind: SeedTaskKind.readBook,
      ),
    ];

    await _database.batch((batch) {
      batch.insertAll(
        _database.taskRecords,
        seedTasks.map(_toCompanion).toList(),
        mode: InsertMode.insertOrIgnore,
      );
    });
  }

  Future<void> addTask(TaskItem task) {
    return _database
        .into(_database.taskRecords)
        .insertOnConflictUpdate(_toCompanion(task));
  }

  Future<void> updateTask(TaskItem task) {
    return _database
        .into(_database.taskRecords)
        .insertOnConflictUpdate(_toCompanion(task));
  }

  Future<void> toggleComplete(TaskItem task) {
    final now = DateTime.now();
    final completed = !task.isCompleted;
    return updateTask(
      task.copyWith(
        isCompleted: completed,
        completedAt: completed ? now : null,
        clearCompletedAt: !completed,
        updatedAt: now,
      ),
    );
  }

  Future<void> deleteTask(String id) {
    return (_database.delete(
      _database.taskRecords,
    )..where((t) => t.id.equals(id))).go();
  }

  TaskRecordsCompanion _toCompanion(TaskItem task) {
    return TaskRecordsCompanion(
      id: Value(task.id),
      title: Value(task.title),
      description: Value(task.description),
      date: Value(dateOnly(task.date)),
      timeMinutes: Value(_timeToMinutes(task.time)),
      isCompleted: Value(task.isCompleted),
      priority: Value(task.priority.name),
      category: Value(task.category),
      reminderEnabled: Value(task.reminderEnabled),
      reminderTime: Value(task.reminderTime),
      repeatType: Value(task.repeatType.name),
      completedAt: Value(task.completedAt),
      seedKind: Value(task.seedKind?.name),
      createdAt: Value(task.createdAt),
      updatedAt: Value(task.updatedAt),
    );
  }

  TaskItem _fromRecord(TaskRecord record) {
    return TaskItem(
      id: record.id,
      title: record.title,
      description: record.description,
      date: record.date,
      time: _minutesToTime(record.timeMinutes),
      isCompleted: record.isCompleted,
      priority: _enumByName(TaskPriority.values, record.priority),
      category: record.category,
      reminderEnabled: record.reminderEnabled,
      reminderTime: record.reminderTime,
      repeatType: _enumByName(RepeatType.values, record.repeatType),
      completedAt: record.completedAt,
      createdAt: record.createdAt,
      updatedAt: record.updatedAt,
      seedKind: record.seedKind == null
          ? null
          : _enumByName(SeedTaskKind.values, record.seedKind!),
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
