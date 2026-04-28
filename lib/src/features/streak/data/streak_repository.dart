import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/streak_summary.dart';

class StreakRepository {
  StreakRepository(this._database);

  final AppDatabase _database;

  Stream<StreakSummary> watchSummary() async* {
    await markAppOpened();
    yield* (_database.select(_database.appActivityRecords)
          ..orderBy([(record) => OrderingTerm.desc(record.date)]))
        .watch()
        .map(_buildSummary);
  }

  Future<void> markAppOpened() async {
    final today = dateOnly(DateTime.now());
    final existing = await (_database.select(
      _database.appActivityRecords,
    )..where((record) => record.date.equals(today))).getSingleOrNull();

    await _database
        .into(_database.appActivityRecords)
        .insertOnConflictUpdate(
          AppActivityRecordsCompanion(
            date: Value(today),
            appOpened: const Value(true),
            tasksCompleted: Value(existing?.tasksCompleted ?? 0),
            habitsCompleted: Value(existing?.habitsCompleted ?? 0),
            prayersCompleted: Value(existing?.prayersCompleted ?? 0),
            perfectDay: Value(existing?.perfectDay ?? false),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<void> updateTodayMetrics({
    required int tasksCompleted,
    required int habitsCompleted,
    required int prayersCompleted,
    required bool perfectDay,
  }) async {
    final today = dateOnly(DateTime.now());
    await _database
        .into(_database.appActivityRecords)
        .insertOnConflictUpdate(
          AppActivityRecordsCompanion(
            date: Value(today),
            appOpened: const Value(true),
            tasksCompleted: Value(tasksCompleted),
            habitsCompleted: Value(habitsCompleted),
            prayersCompleted: Value(prayersCompleted),
            perfectDay: Value(perfectDay),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  StreakSummary _buildSummary(List<AppActivityRecord> records) {
    final byDate = {
      for (final record in records) dateOnly(record.date): record,
    };
    final today = dateOnly(DateTime.now());
    return StreakSummary(
      appStreak: _calculateBoolStreak(
        byDate,
        today,
        (record) => record.appOpened,
      ),
      perfectDayStreak: _calculateBoolStreak(
        byDate,
        today,
        (record) => record.perfectDay,
      ),
      weeklyActivity: _weeklyActivity(byDate, today),
    );
  }

  int _calculateBoolStreak(
    Map<DateTime, AppActivityRecord> byDate,
    DateTime today,
    bool Function(AppActivityRecord record) predicate,
  ) {
    var cursor = predicate(byDate[today] ?? _emptyActivity(today))
        ? today
        : today.subtract(const Duration(days: 1));
    var streak = 0;
    while (true) {
      final record = byDate[cursor];
      if (record == null || !predicate(record)) {
        return streak;
      }
      streak++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
  }

  List<double> _weeklyActivity(
    Map<DateTime, AppActivityRecord> byDate,
    DateTime today,
  ) {
    return [
      for (var offset = 6; offset >= 0; offset--)
        _activityScore(byDate[today.subtract(Duration(days: offset))]),
    ];
  }

  double _activityScore(AppActivityRecord? record) {
    if (record == null) {
      return 0.08;
    }
    final score =
        (record.appOpened ? 0.25 : 0) +
        record.tasksCompleted * 0.18 +
        record.habitsCompleted * 0.18 +
        record.prayersCompleted * 0.08;
    return score.clamp(0.08, 1);
  }

  AppActivityRecord _emptyActivity(DateTime date) {
    return AppActivityRecord(
      date: date,
      appOpened: false,
      tasksCompleted: 0,
      habitsCompleted: 0,
      prayersCompleted: 0,
      perfectDay: false,
      updatedAt: date,
    );
  }
}
