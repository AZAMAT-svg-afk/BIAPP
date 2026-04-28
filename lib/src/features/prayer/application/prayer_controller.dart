import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/prayer_repository.dart';
import '../domain/prayer_time.dart';
import '../../settings/application/settings_controller.dart';

final prayerRepositoryProvider = Provider<PrayerRepository>(
  (ref) => PrayerRepository(),
);

final prayerControllerProvider =
    NotifierProvider<PrayerController, List<PrayerTimeItem>>(
      PrayerController.new,
    );

final nextPrayerProvider = Provider<PrayerTimeItem>((ref) {
  final schedule = ref.watch(prayerControllerProvider);
  final settings = ref.watch(settingsControllerProvider);
  final now = DateTime.now();
  return schedule.firstWhere(
    (item) => item.time.isAfter(now),
    orElse: () {
      return ref
          .read(prayerRepositoryProvider)
          .nextFajrTomorrow(settings.prayer);
    },
  );
});

class PrayerController extends Notifier<List<PrayerTimeItem>> {
  @override
  List<PrayerTimeItem> build() {
    final settings = ref.watch(settingsControllerProvider);
    return ref
        .read(prayerRepositoryProvider)
        .loadTodaySchedule(settings.prayer);
  }

  void markCompleted(PrayerType type) {
    state = [
      for (final item in state)
        if (item.type == type)
          item.copyWith(isCompleted: !item.isCompleted)
        else
          item,
    ];
  }
}

PrayerStatus statusForPrayer(
  PrayerTimeItem item,
  List<PrayerTimeItem> schedule,
  DateTime now,
) {
  final index = schedule.indexWhere((candidate) => candidate.type == item.type);
  final next = index >= 0 && index < schedule.length - 1
      ? schedule[index + 1].time
      : item.time.add(const Duration(hours: 2));

  if (now.isAfter(item.time) && now.isBefore(next)) {
    return PrayerStatus.current;
  }
  if (now.isBefore(item.time)) {
    return PrayerStatus.upcoming;
  }
  return PrayerStatus.past;
}
