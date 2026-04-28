import '../../../../l10n/app_localizations.dart';
import '../../settings/domain/user_settings.dart';
import '../domain/prayer_time.dart';

class PrayerLabels {
  static String name(AppLocalizations l10n, PrayerType type) {
    return switch (type) {
      PrayerType.fajr => l10n.prayerFajr,
      PrayerType.sunrise => l10n.prayerSunrise,
      PrayerType.dhuhr => l10n.prayerDhuhr,
      PrayerType.asr => l10n.prayerAsr,
      PrayerType.maghrib => l10n.prayerMaghrib,
      PrayerType.isha => l10n.prayerIsha,
    };
  }

  static String status(AppLocalizations l10n, PrayerStatus status) {
    return switch (status) {
      PrayerStatus.upcoming => l10n.statusUpcoming,
      PrayerStatus.current => l10n.statusCurrent,
      PrayerStatus.past => l10n.statusPast,
    };
  }

  static String madhhab(AppLocalizations l10n, Madhhab madhhab) {
    return switch (madhhab) {
      Madhhab.hanafi => l10n.hanafi,
      Madhhab.shafii => l10n.shafii,
    };
  }
}
