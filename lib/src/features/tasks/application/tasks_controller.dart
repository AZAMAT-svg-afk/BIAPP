import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../data/tasks_repository.dart';
import '../domain/task_item.dart';

final tasksRepositoryProvider = Provider<TasksRepository>(
  (ref) => TasksRepository(ref.watch(appDatabaseProvider)),
);

final tasksControllerProvider =
    NotifierProvider<TasksController, List<TaskItem>>(TasksController.new);

final todayTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = ref.watch(tasksControllerProvider);
  final now = DateTime.now();
  return tasks.where((task) => _isSameDay(task.date, now)).toList();
});

final completedTasksProvider = Provider<List<TaskItem>>((ref) {
  return ref.watch(tasksControllerProvider).where((task) {
    return task.isCompleted;
  }).toList();
});

final missedTasksProvider = Provider<List<TaskItem>>((ref) {
  final today = DateTime.now();
  return ref.watch(tasksControllerProvider).where((task) {
    return task.date.isBefore(DateTime(today.year, today.month, today.day)) &&
        !task.isCompleted;
  }).toList();
});

class TasksController extends Notifier<List<TaskItem>> {
  @override
  List<TaskItem> build() {
    final repository = ref.read(tasksRepositoryProvider);
    final subscription = repository.watchTasks().listen((tasks) {
      state = tasks;
    });
    ref.onDispose(subscription.cancel);
    unawaited(repository.ensureSeedData());
    return const [];
  }

  void addTask({
    required String title,
    String description = '',
    DateTime? date,
    TimeOfDay? time,
    TaskPriority priority = TaskPriority.medium,
    String category = '',
    bool reminderEnabled = false,
    DateTime? reminderTime,
    RepeatType repeatType = RepeatType.none,
  }) {
    final now = DateTime.now();
    final item = TaskItem(
      id: const Uuid().v4(),
      title: title.trim(),
      description: description.trim(),
      date: date ?? DateTime(now.year, now.month, now.day),
      time: time,
      isCompleted: false,
      priority: priority,
      category: category.trim(),
      reminderEnabled: reminderEnabled,
      reminderTime: reminderTime,
      repeatType: repeatType,
      createdAt: now,
      updatedAt: now,
    );
    unawaited(ref.read(tasksRepositoryProvider).addTask(item));
  }

  void updateTask(TaskItem updated) {
    unawaited(
      ref
          .read(tasksRepositoryProvider)
          .updateTask(
            updated.copyWith(updatedAt: DateTime.now(), seedKind: null),
          ),
    );
  }

  void toggleComplete(String id) {
    TaskItem? task;
    for (final candidate in state) {
      if (candidate.id == id) {
        task = candidate;
        break;
      }
    }
    if (task == null) {
      return;
    }
    unawaited(ref.read(tasksRepositoryProvider).toggleComplete(task));
  }

  void deleteTask(String id) {
    unawaited(ref.read(tasksRepositoryProvider).deleteTask(id));
  }
}

bool _isSameDay(DateTime first, DateTime second) {
  return first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
}
