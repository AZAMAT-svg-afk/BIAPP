import 'dart:async';

import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../../settings/domain/user_settings.dart';
import '../domain/prayer_time.dart';

class PrayerRepository {
  List<PrayerTimeItem> loadTodaySchedule(PrayerSettings settings) {
    return _calculate(settings, _todayInCity(settings)).finalSchedule;
  }

  Future<List<PrayerTimeItem>> fetchTodaySchedule(
    PrayerSettings settings,
  ) async {
    return Future.value(loadTodaySchedule(settings));
  }

  PrayerTimeItem nextFajrTomorrow(PrayerSettings settings) {
    final today = _todayInCity(settings);
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    return _calculate(settings, tomorrow).finalSchedule.first;
  }

  PrayerCalculationDebug debugTodaySchedule(PrayerSettings settings) {
    return _calculate(settings, _todayInCity(settings)).debug;
  }

  PrayerCalculationResult _calculate(PrayerSettings settings, DateTime day) {
    _ensureTimeZones();
    final city = PrayerCityProfiles.resolve(settings.city);
    final date = DateTime(day.year, day.month, day.day);
    final prayerTimes = adhan.PrayerTimes(
      coordinates: adhan.Coordinates(city.latitude, city.longitude),
      date: date,
      calculationParameters: _parameters(settings, city),
      precision: false,
    );

    final rawSchedule = [
      _localItem(PrayerType.fajr, prayerTimes.fajr, city),
      _localItem(PrayerType.sunrise, prayerTimes.sunrise, city),
      _localItem(PrayerType.dhuhr, prayerTimes.dhuhr, city),
      _localItem(PrayerType.asr, prayerTimes.asr, city),
      _localItem(PrayerType.maghrib, prayerTimes.maghrib, city),
      _localItem(PrayerType.isha, prayerTimes.isha, city),
    ];

    final userOffsets = settings.manualOffsetsEnabled
        ? settings.manualOffsets
        : PrayerOffsets.zero;
    final totalOffsets = city.sajdaOffsets + userOffsets;
    final finalSchedule = [
      for (final item in rawSchedule)
        item.copyWith(
          time: item.time.add(
            Duration(minutes: totalOffsets.forType(item.type)),
          ),
        ),
    ];

    return PrayerCalculationResult(
      finalSchedule: finalSchedule,
      debug: PrayerCalculationDebug(
        city: city,
        madhhab: settings.madhhab,
        calculationMethod: _effectiveCalculationMethod(settings, city),
        rawSchedule: rawSchedule,
        cityOffsets: city.sajdaOffsets,
        userOffsets: userOffsets,
        finalSchedule: finalSchedule,
      ),
    );
  }

  adhan.CalculationParameters _parameters(
    PrayerSettings settings,
    PrayerCityProfile city,
  ) {
    final method = _effectiveCalculationMethod(settings, city).toLowerCase();
    final params = method.contains('karachi')
        ? adhan.CalculationMethodParameters.karachi()
        : method.contains('world') || method.contains('mwl')
        ? adhan.CalculationMethodParameters.muslimWorldLeague()
        : adhan.CalculationParameters(
            method: adhan.CalculationMethod.egyptian,
            fajrAngle: city.fajrAngle,
            ishaAngle: city.ishaAngle,
            ishaInterval: city.ishaInterval,
            highLatitudeRule: city.highLatitudeRule,
            madhab: _madhab(settings.madhhab),
            methodAdjustments: const {
              adhan.Prayer.fajr: 0,
              adhan.Prayer.sunrise: 0,
              adhan.Prayer.dhuhr: 0,
              adhan.Prayer.asr: 0,
              adhan.Prayer.maghrib: 0,
              adhan.Prayer.isha: 0,
            },
          );

    params.highLatitudeRule = city.highLatitudeRule;
    params.madhab = _madhab(settings.madhhab);
    return params;
  }

  String _effectiveCalculationMethod(
    PrayerSettings settings,
    PrayerCityProfile city,
  ) {
    final configured = settings.calculationMethod.trim();
    if (configured.isEmpty) {
      return city.calculationMethod;
    }
    return configured;
  }

  PrayerTimeItem _localItem(
    PrayerType type,
    DateTime utcTime,
    PrayerCityProfile city,
  ) {
    final location = _locationFor(city);
    final local = tz.TZDateTime.from(utcTime.toUtc(), location);
    return PrayerTimeItem(
      type: type,
      time: DateTime(
        local.year,
        local.month,
        local.day,
        local.hour,
        local.minute,
      ),
      isCompleted: false,
    );
  }

  DateTime _todayInCity(PrayerSettings settings) {
    _ensureTimeZones();
    final city = PrayerCityProfiles.resolve(settings.city);
    final now = tz.TZDateTime.from(DateTime.now().toUtc(), _locationFor(city));
    return DateTime(now.year, now.month, now.day);
  }

  tz.Location _locationFor(PrayerCityProfile city) {
    try {
      return tz.getLocation(city.timezone);
    } on Object {
      return tz.local;
    }
  }

  adhan.Madhab _madhab(Madhhab madhhab) {
    return madhhab == Madhhab.hanafi ? adhan.Madhab.hanafi : adhan.Madhab.shafi;
  }

  void _ensureTimeZones() {
    if (_timeZonesInitialized) {
      return;
    }
    tz_data.initializeTimeZones();
    _timeZonesInitialized = true;
  }

  static bool _timeZonesInitialized = false;
}

class PrayerCalculationResult {
  const PrayerCalculationResult({
    required this.finalSchedule,
    required this.debug,
  });

  final List<PrayerTimeItem> finalSchedule;
  final PrayerCalculationDebug debug;
}

class PrayerCalculationDebug {
  const PrayerCalculationDebug({
    required this.city,
    required this.madhhab,
    required this.calculationMethod,
    required this.rawSchedule,
    required this.cityOffsets,
    required this.userOffsets,
    required this.finalSchedule,
  });

  final PrayerCityProfile city;
  final Madhhab madhhab;
  final String calculationMethod;
  final List<PrayerTimeItem> rawSchedule;
  final PrayerOffsets cityOffsets;
  final PrayerOffsets userOffsets;
  final List<PrayerTimeItem> finalSchedule;

  String toMultilineString() {
    return [
      'Prayer debug',
      'city=${city.id} (${city.englishName})',
      'coordinates=${city.latitude}, ${city.longitude}',
      'timezone=${city.timezone}',
      'madhhab=${madhhab.name}',
      'calculationMethod=$calculationMethod',
      'raw=${_format(rawSchedule)}',
      'citySajdaOffsets=${cityOffsets.toDebugString()}',
      'userManualOffsets=${userOffsets.toDebugString()}',
      'final=${_format(finalSchedule)}',
    ].join('\n');
  }

  String _format(List<PrayerTimeItem> schedule) {
    return schedule
        .map((item) => '${item.type.name}:${_time(item.time)}')
        .join(', ');
  }

  String _time(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

enum PrayerRoundingRule { nearestMinute }

class PrayerCityProfile {
  const PrayerCityProfile({
    required this.id,
    required this.russianName,
    required this.kazakhName,
    required this.englishName,
    required this.aliases,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.defaultMadhhab,
    required this.calculationMethod,
    required this.fajrAngle,
    required this.ishaAngle,
    required this.highLatitudeRule,
    required this.roundingRule,
    required this.sajdaOffsets,
    this.ishaInterval,
  });

  final String id;
  final String russianName;
  final String kazakhName;
  final String englishName;
  final List<String> aliases;
  final double latitude;
  final double longitude;
  final String timezone;
  final Madhhab defaultMadhhab;
  final String calculationMethod;
  final double fajrAngle;
  final double ishaAngle;
  final int? ishaInterval;
  final adhan.HighLatitudeRule highLatitudeRule;
  final PrayerRoundingRule roundingRule;
  final PrayerOffsets sajdaOffsets;

  String localizedName(String localeName) {
    return switch (localeName) {
      'kk' => kazakhName,
      'en' => englishName,
      _ => russianName,
    };
  }
}

class PrayerCalculationProfiles {
  const PrayerCalculationProfiles._();

  static const dumkSajdaKazakhstan = 'DUMK / Sajda Kazakhstan';
  static const muslimWorldLeague = 'Muslim World League';
  static const karachi = 'Karachi';

  static const values = [dumkSajdaKazakhstan, muslimWorldLeague, karachi];
}

class PrayerCityProfiles {
  const PrayerCityProfiles._();

  static const _defaultOffsets = PrayerOffsets.zero;

  static const cities = [
    PrayerCityProfile(
      id: 'astana',
      russianName: 'Астана',
      kazakhName: 'Астана',
      englishName: 'Astana',
      aliases: ['nur-sultan', 'nursultan', 'нур-султан', 'астана'],
      latitude: 51.1694,
      longitude: 71.4491,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'almaty',
      russianName: 'Алматы',
      kazakhName: 'Алматы',
      englishName: 'Almaty',
      aliases: ['alma-ata', 'алма-ата'],
      latitude: 43.2220,
      longitude: 76.8512,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'shymkent',
      russianName: 'Шымкент',
      kazakhName: 'Шымкент',
      englishName: 'Shymkent',
      aliases: ['шимкент'],
      latitude: 42.3417,
      longitude: 69.5901,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'karaganda',
      russianName: 'Караганда',
      kazakhName: 'Қарағанды',
      englishName: 'Karaganda',
      aliases: ['qaragandy', 'қарағанды'],
      latitude: 49.8068,
      longitude: 73.0851,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'aktobe',
      russianName: 'Актобе',
      kazakhName: 'Ақтөбе',
      englishName: 'Aktobe',
      aliases: ['aqtobe', 'ақтөбе'],
      latitude: 50.2839,
      longitude: 57.1660,
      timezone: 'Asia/Aqtobe',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'atyrau',
      russianName: 'Атырау',
      kazakhName: 'Атырау',
      englishName: 'Atyrau',
      aliases: [],
      latitude: 47.0945,
      longitude: 51.9238,
      timezone: 'Asia/Atyrau',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'aktau',
      russianName: 'Актау',
      kazakhName: 'Ақтау',
      englishName: 'Aktau',
      aliases: ['aqtau', 'ақтау'],
      latitude: 43.6532,
      longitude: 51.1975,
      timezone: 'Asia/Aqtau',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'pavlodar',
      russianName: 'Павлодар',
      kazakhName: 'Павлодар',
      englishName: 'Pavlodar',
      aliases: [],
      latitude: 52.2873,
      longitude: 76.9674,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'kostanay',
      russianName: 'Костанай',
      kazakhName: 'Қостанай',
      englishName: 'Kostanay',
      aliases: ['qostanay', 'қостанай'],
      latitude: 53.2144,
      longitude: 63.6246,
      timezone: 'Asia/Qostanay',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'petropavl',
      russianName: 'Петропавл',
      kazakhName: 'Петропавл',
      englishName: 'Petropavl',
      aliases: ['petropavlovsk', 'петропавловск'],
      latitude: 54.8728,
      longitude: 69.1430,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'oral',
      russianName: 'Уральск',
      kazakhName: 'Орал',
      englishName: 'Oral',
      aliases: ['uralsk', 'уралск', 'оральск', 'oral'],
      latitude: 51.2278,
      longitude: 51.3865,
      timezone: 'Asia/Oral',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'semey',
      russianName: 'Семей',
      kazakhName: 'Семей',
      englishName: 'Semey',
      aliases: ['semipalatinsk', 'семипалатинск'],
      latitude: 50.4111,
      longitude: 80.2275,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'oskemen',
      russianName: 'Усть-Каменогорск',
      kazakhName: 'Өскемен',
      englishName: 'Oskemen',
      aliases: ['ust-kamenogorsk', 'oskemen', 'өскемен'],
      latitude: 49.9483,
      longitude: 82.6275,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'taraz',
      russianName: 'Тараз',
      kazakhName: 'Тараз',
      englishName: 'Taraz',
      aliases: ['zhambyl', 'джамбул'],
      latitude: 42.8999,
      longitude: 71.3674,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'turkistan',
      russianName: 'Туркестан',
      kazakhName: 'Түркістан',
      englishName: 'Turkistan',
      aliases: ['түркістан'],
      latitude: 43.2973,
      longitude: 68.2518,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'kokshetau',
      russianName: 'Кокшетау',
      kazakhName: 'Көкшетау',
      englishName: 'Kokshetau',
      aliases: ['көкшетау'],
      latitude: 53.2833,
      longitude: 69.3833,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'taldykorgan',
      russianName: 'Талдыкорган',
      kazakhName: 'Талдықорған',
      englishName: 'Taldykorgan',
      aliases: ['taldyqorgan', 'талдықорған'],
      latitude: 45.0177,
      longitude: 78.3804,
      timezone: 'Asia/Almaty',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
    PrayerCityProfile(
      id: 'qyzylorda',
      russianName: 'Кызылорда',
      kazakhName: 'Қызылорда',
      englishName: 'Qyzylorda',
      aliases: ['kyzylorda', 'қызылорда'],
      latitude: 44.8479,
      longitude: 65.4999,
      timezone: 'Asia/Qyzylorda',
      defaultMadhhab: Madhhab.hanafi,
      calculationMethod: PrayerCalculationProfiles.dumkSajdaKazakhstan,
      fajrAngle: 19.5,
      ishaAngle: 17.5,
      highLatitudeRule: adhan.HighLatitudeRule.middleOfTheNight,
      roundingRule: PrayerRoundingRule.nearestMinute,
      sajdaOffsets: _defaultOffsets,
    ),
  ];

  static PrayerCityProfile resolve(String input) {
    final normalized = _normalize(input);
    for (final city in cities) {
      if (_matches(city, normalized)) {
        return city;
      }
    }
    for (final city in cities) {
      if (city.aliases.any((alias) {
        final normalizedAlias = _normalize(alias);
        return normalizedAlias.contains(normalized) ||
            normalized.contains(normalizedAlias);
      })) {
        return city;
      }
    }
    return cities.firstWhere((city) => city.id == 'qyzylorda');
  }

  static bool _matches(PrayerCityProfile city, String normalized) {
    return _normalize(city.id) == normalized ||
        _normalize(city.russianName) == normalized ||
        _normalize(city.kazakhName) == normalized ||
        _normalize(city.englishName) == normalized ||
        city.aliases.any((alias) => _normalize(alias) == normalized);
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[\s\-_]'), '')
        .replaceAll('ә', 'a')
        .replaceAll('ғ', 'g')
        .replaceAll('қ', 'k')
        .replaceAll('ң', 'n')
        .replaceAll('ө', 'o')
        .replaceAll('ұ', 'u')
        .replaceAll('ү', 'u')
        .replaceAll('һ', 'h')
        .replaceAll('і', 'i')
        .replaceAll('ы', 'y')
        .replaceAll('ё', 'е');
  }
}

extension PrayerOffsetsX on PrayerOffsets {
  int forType(PrayerType type) {
    return switch (type) {
      PrayerType.fajr => fajrOffsetMinutes,
      PrayerType.sunrise => sunriseOffsetMinutes,
      PrayerType.dhuhr => dhuhrOffsetMinutes,
      PrayerType.asr => asrOffsetMinutes,
      PrayerType.maghrib => maghribOffsetMinutes,
      PrayerType.isha => ishaOffsetMinutes,
    };
  }

  PrayerOffsets copyForType(PrayerType type, int minutes) {
    return switch (type) {
      PrayerType.fajr => copyWith(fajrOffsetMinutes: minutes),
      PrayerType.sunrise => copyWith(sunriseOffsetMinutes: minutes),
      PrayerType.dhuhr => copyWith(dhuhrOffsetMinutes: minutes),
      PrayerType.asr => copyWith(asrOffsetMinutes: minutes),
      PrayerType.maghrib => copyWith(maghribOffsetMinutes: minutes),
      PrayerType.isha => copyWith(ishaOffsetMinutes: minutes),
    };
  }

  String toDebugString() {
    return 'fajr=$fajrOffsetMinutes, sunrise=$sunriseOffsetMinutes, '
        'dhuhr=$dhuhrOffsetMinutes, asr=$asrOffsetMinutes, '
        'maghrib=$maghribOffsetMinutes, isha=$ishaOffsetMinutes';
  }
}
