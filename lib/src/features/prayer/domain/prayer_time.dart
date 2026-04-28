enum PrayerType { fajr, sunrise, dhuhr, asr, maghrib, isha }

enum PrayerStatus { upcoming, current, past }

class PrayerTimeItem {
  const PrayerTimeItem({
    required this.type,
    required this.time,
    required this.isCompleted,
  });

  final PrayerType type;
  final DateTime time;
  final bool isCompleted;

  PrayerTimeItem copyWith({
    PrayerType? type,
    DateTime? time,
    bool? isCompleted,
  }) {
    return PrayerTimeItem(
      type: type ?? this.type,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
