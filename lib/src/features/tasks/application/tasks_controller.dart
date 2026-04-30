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
  final today = dateOnly(now);
  return tasks.where((task) {
    return !task.isCompleted &&
        dateOnly(task.date) == today &&
        !isTaskMissed(task, now);
  }).toList()..sort(compareTasksByDueDate);
});

final upcomingTasksProvider = Provider<List<TaskItem>>((ref) {
  final tasks = ref.watch(tasksControllerProvider);
  final today = dateOnly(DateTime.now());
  return tasks.where((task) {
    return !task.isCompleted && dateOnly(task.date).isAfter(today);
  }).toList()..sort(compareTasksByDueDate);
});

final completedTasksProvider = Provider<List<TaskItem>>((ref) {
  return ref.watch(tasksControllerProvider).where((task) {
    return task.isCompleted;
  }).toList()..sort((a, b) {
    final left = a.completedAt ?? a.updatedAt;
    final right = b.completedAt ?? b.updatedAt;
    return right.compareTo(left);
  });
});

final missedTasksProvider = Provider<List<TaskItem>>((ref) {
  final now = DateTime.now();
  return ref.watch(tasksControllerProvider).where((task) {
    return isTaskMissed(task, now);
  }).toList()..sort((a, b) => taskDueDateTime(b).compareTo(taskDueDateTime(a)));
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
      date: dateOnly(date ?? now),
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

DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

DateTime taskDueDateTime(TaskItem task) {
  final date = dateOnly(task.date);
  final time = task.time;
  if (time != null) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  final reminderTime = task.reminderEnabled ? task.reminderTime : null;
  if (reminderTime != null) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      reminderTime.hour,
      reminderTime.minute,
    );
  }

  return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
}

bool isTaskMissed(TaskItem task, DateTime now) {
  return !task.isCompleted && taskDueDateTime(task).isBefore(now);
}

int compareTasksByDueDate(TaskItem a, TaskItem b) {
  final byDueDate = taskDueDateTime(a).compareTo(taskDueDateTime(b));
  if (byDueDate != 0) {
    return byDueDate;
  }
  return b.updatedAt.compareTo(a.updatedAt);
}
