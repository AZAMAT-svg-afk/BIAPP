import 'package:adhan_dart/adhan_dart.dart' as adhan;

import '../../settings/domain/user_settings.dart';
import '../domain/prayer_time.dart';

class PrayerRepository {
  List<PrayerTimeItem> loadTodaySchedule(PrayerSettings settings) {
    final now = DateTime.now();
    final date = DateTime(now.year, now.month, now.day);
    final city = KazakhstanPrayerCity.resolve(settings.city);
    final prayerTimes = adhan.PrayerTimes(
      coordinates: adhan.Coordinates(city.latitude, city.longitude),
      date: date,
      calculationParameters: _parameters(settings),
      precision: false,
    );

    return [
      _item(PrayerType.fajr, prayerTimes.fajr),
      _item(PrayerType.sunrise, prayerTimes.sunrise),
      _item(PrayerType.dhuhr, prayerTimes.dhuhr),
      _item(PrayerType.asr, prayerTimes.asr),
      _item(PrayerType.maghrib, prayerTimes.maghrib),
      _item(PrayerType.isha, prayerTimes.isha),
    ];
  }

  PrayerTimeItem nextFajrTomorrow(PrayerSettings settings) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final city = KazakhstanPrayerCity.resolve(settings.city);
    final prayerTimes = adhan.PrayerTimes(
      coordinates: adhan.Coordinates(city.latitude, city.longitude),
      date: tomorrow,
      calculationParameters: _parameters(settings),
      precision: false,
    );
    return _item(PrayerType.fajr, prayerTimes.fajr);
  }

  adhan.CalculationParameters _parameters(PrayerSettings settings) {
    final method = settings.calculationMethod.toLowerCase();
    final params = switch (method) {
      final value when value.contains('umm') || value.contains('умм') =>
        adhan.CalculationMethodParameters.ummAlQura(),
      final value when value.contains('karachi') || value.contains('карачи') =>
        adhan.CalculationMethodParameters.karachi(),
      final value
          when value.contains('turkiye') ||
              value.contains('diyanet') ||
              value.contains('түркия') ||
              value.contains('турция') =>
        adhan.CalculationMethodParameters.turkiye(),
      final value
          when value.contains('kazakhstan') ||
              value.contains('qazaqstan') ||
              value.contains('қазақстан') ||
              value.contains('казахстан') ||
              value.contains('muftiyat') ||
              value.contains('мүфтият') ||
              value.contains('муфтият') =>
        _kazakhstanParameters(),
      _ => _kazakhstanParameters(),
    };
    params.madhab = settings.madhhab == Madhhab.hanafi
        ? adhan.Madhab.hanafi
        : adhan.Madhab.shafi;
    return params;
  }

  adhan.CalculationParameters _kazakhstanParameters() {
    final params = adhan.CalculationMethodParameters.muslimWorldLeague();
    params.highLatitudeRule = adhan.HighLatitudeRule.middleOfTheNight;
    return params;
  }

  PrayerTimeItem _item(PrayerType type, DateTime utcTime) {
    return PrayerTimeItem(
      type: type,
      time: utcTime.toLocal(),
      isCompleted: false,
    );
  }
}

class KazakhstanPrayerCity {
  const KazakhstanPrayerCity({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.aliases,
  });

  final String name;
  final double latitude;
  final double longitude;
  final List<String> aliases;

  static const cities = [
    KazakhstanPrayerCity(
      name: 'Astana',
      latitude: 51.1605,
      longitude: 71.4704,
      aliases: ['astana', 'астана', 'нұр-сұлтан', 'нур-султан', 'nur-sultan'],
    ),
    KazakhstanPrayerCity(
      name: 'Almaty',
      latitude: 43.2220,
      longitude: 76.8512,
      aliases: ['almaty', 'алматы', 'алма-ата', 'alma-ata'],
    ),
    KazakhstanPrayerCity(
      name: 'Shymkent',
      latitude: 42.3155,
      longitude: 69.5869,
      aliases: ['shymkent', 'шимкент', 'шымкент'],
    ),
    KazakhstanPrayerCity(
      name: 'Qyzylorda',
      latitude: 44.8479,
      longitude: 65.4999,
      aliases: ['qyzylorda', 'kyzylorda', 'қызылорда', 'кызылорда'],
    ),
    KazakhstanPrayerCity(
      name: 'Aktobe',
      latitude: 50.2839,
      longitude: 57.1670,
      aliases: ['aktobe', 'ақтөбе', 'актобе'],
    ),
    KazakhstanPrayerCity(
      name: 'Atyrau',
      latitude: 47.1164,
      longitude: 51.8839,
      aliases: ['atyrau', 'атырау'],
    ),
    KazakhstanPrayerCity(
      name: 'Aktau',
      latitude: 43.6532,
      longitude: 51.1975,
      aliases: ['aktau', 'ақтау', 'актау'],
    ),
    KazakhstanPrayerCity(
      name: 'Karaganda',
      latitude: 49.8068,
      longitude: 73.0851,
      aliases: ['karaganda', 'қарағанды', 'караганда'],
    ),
    KazakhstanPrayerCity(
      name: 'Pavlodar',
      latitude: 52.2870,
      longitude: 76.9674,
      aliases: ['pavlodar', 'павлодар'],
    ),
    KazakhstanPrayerCity(
      name: 'Kostanay',
      latitude: 53.2198,
      longitude: 63.6354,
      aliases: ['kostanay', 'қостанай', 'костанай'],
    ),
    KazakhstanPrayerCity(
      name: 'Petropavl',
      latitude: 54.8728,
      longitude: 69.1430,
      aliases: ['petropavl', 'петропавл', 'петропавловск'],
    ),
    KazakhstanPrayerCity(
      name: 'Oral',
      latitude: 51.2278,
      longitude: 51.3865,
      aliases: ['oral', 'орал', 'уральск', 'uralsk'],
    ),
    KazakhstanPrayerCity(
      name: 'Semey',
      latitude: 50.4111,
      longitude: 80.2275,
      aliases: ['semey', 'семей', 'семипалатинск'],
    ),
    KazakhstanPrayerCity(
      name: 'Oskemen',
      latitude: 49.9483,
      longitude: 82.6275,
      aliases: ['oskemen', 'өскемен', 'усть-каменогорск', 'ust-kamenogorsk'],
    ),
    KazakhstanPrayerCity(
      name: 'Taraz',
      latitude: 42.8999,
      longitude: 71.3674,
      aliases: ['taraz', 'тараз'],
    ),
    KazakhstanPrayerCity(
      name: 'Turkistan',
      latitude: 43.2973,
      longitude: 68.2518,
      aliases: ['turkistan', 'түркістан', 'туркестан'],
    ),
    KazakhstanPrayerCity(
      name: 'Kokshetau',
      latitude: 53.2833,
      longitude: 69.3833,
      aliases: ['kokshetau', 'көкшетау', 'кокшетау'],
    ),
    KazakhstanPrayerCity(
      name: 'Taldykorgan',
      latitude: 45.0177,
      longitude: 78.3804,
      aliases: ['taldykorgan', 'талдықорған', 'талдыкорган'],
    ),
  ];

  static KazakhstanPrayerCity resolve(String input) {
    final normalized = _normalize(input);
    for (final city in cities) {
      if (city.aliases.any((alias) => _normalize(alias) == normalized)) {
        return city;
      }
    }
    for (final city in cities) {
      if (city.aliases.any((alias) {
        final cityAlias = _normalize(alias);
        return cityAlias.contains(normalized) || normalized.contains(cityAlias);
      })) {
        return city;
      }
    }
    return cities.firstWhere((city) => city.name == 'Qyzylorda');
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .replaceAll('ё', 'е')
        .replaceAll('ү', 'у')
        .replaceAll('ұ', 'у')
        .replaceAll('қ', 'к')
        .replaceAll('ң', 'н')
        .replaceAll('ғ', 'г')
        .replaceAll('ә', 'а')
        .replaceAll('і', 'и')
        .replaceAll('ө', 'о');
  }
}
