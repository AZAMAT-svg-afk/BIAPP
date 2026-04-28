import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../data/habits_repository.dart';
import '../domain/habit.dart';

final habitsRepositoryProvider = Provider<HabitsRepository>(
  (ref) => HabitsRepository(ref.watch(appDatabaseProvider)),
);

final habitsControllerProvider =
    NotifierProvider<HabitsController, List<Habit>>(HabitsController.new);

final completedHabitsTodayProvider = Provider<int>((ref) {
  return ref.watch(habitsControllerProvider).where((habit) {
    return habit.isCompletedToday;
  }).length;
});

class HabitsController extends Notifier<List<Habit>> {
  @override
  List<Habit> build() {
    final repository = ref.read(habitsRepositoryProvider);
    final subscription = repository.watchHabits().listen((habits) {
      state = habits;
    });
    ref.onDispose(subscription.cancel);
    unawaited(repository.ensureSeedData());
    return const [];
  }

  void addHabit({
    required String name,
    String category = '',
    int targetPerDay = 1,
    bool reminderEnabled = false,
    TimeOfDay? reminderTime,
  }) {
    final now = DateTime.now();
    final habit = Habit(
      id: const Uuid().v4(),
      name: name.trim(),
      category: category.trim(),
      streak: 0,
      targetPerDay: targetPerDay,
      completedToday: 0,
      reminderEnabled: reminderEnabled,
      reminderTime: reminderTime,
      createdAt: now,
      updatedAt: now,
    );
    unawaited(ref.read(habitsRepositoryProvider).addHabit(habit));
  }

  void checkHabit(String id) {
    Habit? habit;
    for (final candidate in state) {
      if (candidate.id == id) {
        habit = candidate;
        break;
      }
    }
    if (habit == null) {
      return;
    }
    unawaited(ref.read(habitsRepositoryProvider).checkHabit(habit));
  }

  void updateHabit(Habit updated) {
    unawaited(
      ref
          .read(habitsRepositoryProvider)
          .updateHabit(
            updated.copyWith(updatedAt: DateTime.now(), seedKind: null),
          ),
    );
  }

  void deleteHabit(String id) {
    unawaited(ref.read(habitsRepositoryProvider).deleteHabit(id));
  }
}
