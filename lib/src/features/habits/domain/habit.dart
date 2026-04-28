import 'package:flutter/material.dart';

enum SeedHabitKind { quran, book, pushups, english, programming, water }

class Habit {
  const Habit({
    required this.id,
    required this.name,
    required this.category,
    required this.streak,
    required this.targetPerDay,
    required this.completedToday,
    required this.reminderEnabled,
    required this.createdAt,
    required this.updatedAt,
    this.reminderTime,
    this.seedKind,
  });

  final String id;
  final String name;
  final String category;
  final int streak;
  final int targetPerDay;
  final int completedToday;
  final bool reminderEnabled;
  final TimeOfDay? reminderTime;
  final DateTime createdAt;
  final DateTime updatedAt;
  final SeedHabitKind? seedKind;

  double get progress {
    if (targetPerDay == 0) {
      return 0;
    }
    return (completedToday / targetPerDay).clamp(0, 1);
  }

  bool get isCompletedToday => completedToday >= targetPerDay;

  Habit copyWith({
    String? id,
    String? name,
    String? category,
    int? streak,
    int? targetPerDay,
    int? completedToday,
    bool? reminderEnabled,
    TimeOfDay? reminderTime,
    DateTime? createdAt,
    DateTime? updatedAt,
    SeedHabitKind? seedKind,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      streak: streak ?? this.streak,
      targetPerDay: targetPerDay ?? this.targetPerDay,
      completedToday: completedToday ?? this.completedToday,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      seedKind: seedKind ?? this.seedKind,
    );
  }
}
