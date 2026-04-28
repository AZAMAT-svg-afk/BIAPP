import 'package:flutter/material.dart';

enum TaskPriority { low, medium, high }

enum RepeatType { none, daily, weekly, monthly }

enum SeedTaskKind { readQuran, pushups, readBook, english }

class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
    required this.priority,
    required this.category,
    required this.reminderEnabled,
    required this.repeatType,
    required this.createdAt,
    required this.updatedAt,
    this.time,
    this.reminderTime,
    this.completedAt,
    this.seedKind,
  });

  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay? time;
  final bool isCompleted;
  final TaskPriority priority;
  final String category;
  final bool reminderEnabled;
  final DateTime? reminderTime;
  final RepeatType repeatType;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SeedTaskKind? seedKind;

  TaskItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? date,
    TimeOfDay? time,
    bool? isCompleted,
    TaskPriority? priority,
    String? category,
    bool? reminderEnabled,
    DateTime? reminderTime,
    RepeatType? repeatType,
    DateTime? completedAt,
    bool clearCompletedAt = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    SeedTaskKind? seedKind,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      repeatType: repeatType ?? this.repeatType,
      completedAt: clearCompletedAt ? null : completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      seedKind: seedKind ?? this.seedKind,
    );
  }
}
