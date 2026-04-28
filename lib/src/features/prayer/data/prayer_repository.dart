import 'dart:async';
import 'dart:convert';

import 'package:adhan_dart/adhan_dart.dart' as adhan;
import 'package:http/http.dart' as http;

import '../../settings/domain/user_settings.dart';
import '../domain/prayer_time.dart';

class PrayerRepository {
  PrayerRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  List<PrayerTimeItem> loadTodaySchedule(PrayerSettings settings) {
    return _calculateLocalSchedule(settings, DateTime.now());
  }

  Future<List<PrayerTimeItem>> fetchTodaySchedule(
    PrayerSettings settings,
  ) async {
    final city = KazakhstanPrayerCity.resolve(settings.city);
    final now = DateTime.now();
    final date = _apiDate(now);
    final uri = Uri.https('api.aladhan.com', '/v1/timingsByCity/$date', {
      'city': city.apiCity,
      'country': 'KZ',
      'method': _apiMethod(settings),
      'school': settings.madhhab == Madhhab.hanafi ? '1' : '0',
      'timezonestring': city.timezone,
    });

    final response = await _client
        .get(uri)
        .timeout(const Duration(seconds: 10));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw PrayerApiException('Aladhan returned ${response.statusCode}');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    final data = decoded is Map ? decoded['data'] : null;
    final timings = data is Map ? data['timings'] : null;
    if (timings is! Map) {
      throw const PrayerApiException('Invalid Aladhan response');
    }

    return [
      _apiItem(PrayerType.fajr, timings['Fajr'], now),
      _apiItem(PrayerType.sunrise, timings['Sunrise'], now),
      _apiItem(PrayerType.dhuhr, timings['Dhuhr'], now),
      _apiItem(PrayerType.asr, timings['Asr'], now),
      _apiItem(PrayerType.maghrib, timings['Maghrib'], now),
      _apiItem(PrayerType.isha, timings['Isha'], now),
    ];
  }

  PrayerTimeItem nextFajrTomorrow(PrayerSettings settings) {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return _calculateLocalSchedule(settings, tomorrow).first;
  }

  List<PrayerTimeItem> _calculateLocalSchedule(
    PrayerSettings settings,
    DateTime day,
  ) {
    final date = DateTime(day.year, day.month, day.day);
    final city = KazakhstanPrayerCity.resolve(settings.city);
    final prayerTimes = adhan.PrayerTimes(
      coordinates: adhan.Coordinates(city.latitude, city.longitude),
      date: date,
      calculationParameters: _parameters(settings),
      precision: false,
    );

    return [
      _localItem(PrayerType.fajr, prayerTimes.fajr),
      _localItem(PrayerType.sunrise, prayerTimes.sunrise),
      _localItem(PrayerType.dhuhr, prayerTimes.dhuhr),
      _localItem(PrayerType.asr, prayerTimes.asr),
      _localItem(PrayerType.maghrib, prayerTimes.maghrib),
      _localItem(PrayerType.isha, prayerTimes.isha),
    ];
  }

  adhan.CalculationParameters _parameters(PrayerSettings settings) {
    final method = settings.calculationMethod.toLowerCase();
    final params = method.contains('karachi') || method.contains('карачи')
        ? adhan.CalculationMethodParameters.karachi()
        : adhan.CalculationMethodParameters.muslimWorldLeague();
    params.highLatitudeRule = adhan.HighLatitudeRule.middleOfTheNight;
    params.madhab = settings.madhhab == Madhhab.hanafi
        ? adhan.Madhab.hanafi
        : adhan.Madhab.shafi;
    return params;
  }

  String _apiMethod(PrayerSettings settings) {
    final method = settings.calculationMethod.toLowerCase();
    return method.contains('karachi') || method.contains('карачи')
        ? '14'
        : '12';
  }

  String _apiDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day-$month-${date.year}';
  }

  PrayerTimeItem _apiItem(PrayerType type, Object? rawTime, DateTime day) {
    final time = _parseApiTime(rawTime?.toString() ?? '', day);
    return PrayerTimeItem(type: type, time: time, isCompleted: false);
  }

  DateTime _parseApiTime(String rawTime, DateTime day) {
    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(rawTime);
    if (match == null) {
      throw PrayerApiException('Invalid prayer time: $rawTime');
    }
    return DateTime(
      day.year,
      day.month,
      day.day,
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
    );
  }

  PrayerTimeItem _localItem(PrayerType type, DateTime utcTime) {
    return PrayerTimeItem(
      type: type,
      time: utcTime.toLocal(),
      isCompleted: false,
    );
  }
}

class PrayerApiException implements Exception {
  const PrayerApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class KazakhstanPrayerCity {
  const KazakhstanPrayerCity({
    required this.displayName,
    required this.apiCity,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.aliases,
  });

  final String displayName;
  final String apiCity;
  final double latitude;
  final double longitude;
  final String timezone;
  final List<String> aliases;

  static const cities = [
    KazakhstanPrayerCity(
      displayName: 'Алматы',
      apiCity: 'Almaty',
      latitude: 43.2220,
      longitude: 76.8512,
      timezone: 'Asia/Almaty',
      aliases: ['алматы', 'almaty', 'alma-ata', 'алма-ата'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Астана (Нұр-Сұлтан)',
      apiCity: 'Astana',
      latitude: 51.1605,
      longitude: 71.4704,
      timezone: 'Asia/Almaty',
      aliases: ['астана', 'нұр-сұлтан', 'нур-султан', 'astana', 'nur-sultan'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Шымкент',
      apiCity: 'Shymkent',
      latitude: 42.3155,
      longitude: 69.5869,
      timezone: 'Asia/Almaty',
      aliases: ['шымкент', 'шимкент', 'shymkent'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Қарағанды',
      apiCity: 'Karaganda',
      latitude: 49.8068,
      longitude: 73.0851,
      timezone: 'Asia/Almaty',
      aliases: ['қарағанды', 'караганда', 'karaganda'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Ақтөбе',
      apiCity: 'Aktobe',
      latitude: 50.2839,
      longitude: 57.1670,
      timezone: 'Asia/Aqtau',
      aliases: ['ақтөбе', 'актобе', 'aktobe'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Тараз',
      apiCity: 'Taraz',
      latitude: 42.8999,
      longitude: 71.3674,
      timezone: 'Asia/Almaty',
      aliases: ['тараз', 'taraz'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Павлодар',
      apiCity: 'Pavlodar',
      latitude: 52.2870,
      longitude: 76.9674,
      timezone: 'Asia/Almaty',
      aliases: ['павлодар', 'pavlodar'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Өскемен',
      apiCity: 'Ust-Kamenogorsk',
      latitude: 49.9483,
      longitude: 82.6275,
      timezone: 'Asia/Almaty',
      aliases: ['өскемен', 'оскемен', 'усть-каменогорск', 'oskemen'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Семей',
      apiCity: 'Semey',
      latitude: 50.4111,
      longitude: 80.2275,
      timezone: 'Asia/Almaty',
      aliases: ['семей', 'semey', 'семипалатинск'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Атырау',
      apiCity: 'Atyrau',
      latitude: 47.1164,
      longitude: 51.8839,
      timezone: 'Asia/Aqtau',
      aliases: ['атырау', 'atyrau'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Орал',
      apiCity: 'Uralsk',
      latitude: 51.2278,
      longitude: 51.3865,
      timezone: 'Asia/Aqtau',
      aliases: ['орал', 'уральск', 'oral', 'uralsk'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Қостанай',
      apiCity: 'Kostanay',
      latitude: 53.2198,
      longitude: 63.6354,
      timezone: 'Asia/Almaty',
      aliases: ['қостанай', 'костанай', 'kostanay'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Петропавл',
      apiCity: 'Petropavlovsk',
      latitude: 54.8728,
      longitude: 69.1430,
      timezone: 'Asia/Almaty',
      aliases: ['петропавл', 'петропавловск', 'petropavl'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Түркістан',
      apiCity: 'Turkistan',
      latitude: 43.2973,
      longitude: 68.2518,
      timezone: 'Asia/Almaty',
      aliases: ['түркістан', 'туркестан', 'turkistan'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Қызылорда',
      apiCity: 'Kyzylorda',
      latitude: 44.8479,
      longitude: 65.4999,
      timezone: 'Asia/Qyzylorda',
      aliases: ['қызылорда', 'кызылорда', 'qyzylorda', 'kyzylorda'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Ақтау',
      apiCity: 'Aktau',
      latitude: 43.6532,
      longitude: 51.1975,
      timezone: 'Asia/Aqtau',
      aliases: ['ақтау', 'актау', 'aktau'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Теміртау',
      apiCity: 'Temirtau',
      latitude: 50.0549,
      longitude: 72.9646,
      timezone: 'Asia/Almaty',
      aliases: ['теміртау', 'темиртау', 'temirtau'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Көкшетау',
      apiCity: 'Kokshetau',
      latitude: 53.2833,
      longitude: 69.3833,
      timezone: 'Asia/Almaty',
      aliases: ['көкшетау', 'кокшетау', 'kokshetau'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Талдықорған',
      apiCity: 'Taldykorgan',
      latitude: 45.0177,
      longitude: 78.3804,
      timezone: 'Asia/Almaty',
      aliases: ['талдықорған', 'талдыкорган', 'taldykorgan'],
    ),
    KazakhstanPrayerCity(
      displayName: 'Жезқазған',
      apiCity: 'Zhezkazgan',
      latitude: 47.7833,
      longitude: 67.7000,
      timezone: 'Asia/Almaty',
      aliases: ['жезқазған', 'жезказган', 'zhezkazgan'],
    ),
  ];

  static KazakhstanPrayerCity resolve(String input) {
    final normalized = _normalize(input);
    for (final city in cities) {
      if (_normalize(city.displayName) == normalized ||
          _normalize(city.apiCity) == normalized ||
          city.aliases.any((alias) => _normalize(alias) == normalized)) {
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
    return cities.firstWhere((city) => city.displayName == 'Қызылорда');
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
