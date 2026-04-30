import 'package:baraka_ai_mobile/src/features/prayer/data/prayer_repository.dart';
import 'package:baraka_ai_mobile/src/features/prayer/domain/prayer_time.dart';
import 'package:baraka_ai_mobile/src/features/settings/domain/user_settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('prayer schedule applies city, madhhab, and manual offsets', () {
    final repository = PrayerRepository();
    const base = PrayerSettings(
      city: 'karaganda',
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      madhhab: Madhhab.hanafi,
      useGeolocation: false,
      notificationsEnabled: true,
      soundEnabled: true,
      vibrationEnabled: true,
      adhanEnabled: false,
      manualOffsetsEnabled: false,
      manualOffsets: PrayerOffsets.zero,
    );

    final karaganda = repository.loadTodaySchedule(base);
    final almaty = repository.loadTodaySchedule(base.copyWith(city: 'almaty'));
    final shafii = repository.loadTodaySchedule(
      base.copyWith(madhhab: Madhhab.shafii),
    );
    final corrected = repository.loadTodaySchedule(
      base.copyWith(
        manualOffsetsEnabled: true,
        manualOffsets: const PrayerOffsets(fajrOffsetMinutes: 5),
      ),
    );

    expect(karaganda, hasLength(6));
    expect(
      _timeFor(karaganda, PrayerType.fajr),
      isNot(equals(_timeFor(almaty, PrayerType.fajr))),
    );
    expect(
      _timeFor(karaganda, PrayerType.asr),
      isNot(equals(_timeFor(shafii, PrayerType.asr))),
    );
    expect(
      _timeFor(
        corrected,
        PrayerType.fajr,
      ).difference(_timeFor(karaganda, PrayerType.fajr)),
      const Duration(minutes: 5),
    );
  });
}

DateTime _timeFor(List<PrayerTimeItem> schedule, PrayerType type) {
  return schedule.firstWhere((item) => item.type == type).time;
}
