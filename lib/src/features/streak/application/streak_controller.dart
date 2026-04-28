import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../data/streak_repository.dart';
import '../domain/streak_summary.dart';

final streakRepositoryProvider = Provider<StreakRepository>(
  (ref) => StreakRepository(ref.watch(appDatabaseProvider)),
);

final streakSummaryProvider = NotifierProvider<StreakController, StreakSummary>(
  StreakController.new,
);

class StreakController extends Notifier<StreakSummary> {
  @override
  StreakSummary build() {
    final repository = ref.read(streakRepositoryProvider);
    final subscription = repository.watchSummary().listen((summary) {
      state = summary;
    });
    ref.onDispose(subscription.cancel);
    unawaited(repository.markAppOpened());
    return StreakSummary.empty;
  }

  void updateTodayMetrics({
    required int tasksCompleted,
    required int habitsCompleted,
    required int prayersCompleted,
    required bool perfectDay,
  }) {
    unawaited(
      ref
          .read(streakRepositoryProvider)
          .updateTodayMetrics(
            tasksCompleted: tasksCompleted,
            habitsCompleted: habitsCompleted,
            prayersCompleted: prayersCompleted,
            perfectDay: perfectDay,
          ),
    );
  }
}
