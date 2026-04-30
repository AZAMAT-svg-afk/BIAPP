import 'package:flutter/material.dart';

enum AppLanguage {
  ru('ru'),
  en('en'),
  kk('kk');

  const AppLanguage(this.code);
  final String code;
}

enum AppThemePreference {
  system,
  light,
  dark;

  ThemeMode get flutterThemeMode {
    return switch (this) {
      AppThemePreference.system => ThemeMode.system,
      AppThemePreference.light => ThemeMode.light,
      AppThemePreference.dark => ThemeMode.dark,
    };
  }
}

enum Madhhab { hanafi, shafii }

enum AiMentorMode { off, soft, normal, strict }

class PrayerOffsets {
  const PrayerOffsets({
    this.fajrOffsetMinutes = 0,
    this.sunriseOffsetMinutes = 0,
    this.dhuhrOffsetMinutes = 0,
    this.asrOffsetMinutes = 0,
    this.maghribOffsetMinutes = 0,
    this.ishaOffsetMinutes = 0,
  });

  static const zero = PrayerOffsets();

  final int fajrOffsetMinutes;
  final int sunriseOffsetMinutes;
  final int dhuhrOffsetMinutes;
  final int asrOffsetMinutes;
  final int maghribOffsetMinutes;
  final int ishaOffsetMinutes;

  PrayerOffsets copyWith({
    int? fajrOffsetMinutes,
    int? sunriseOffsetMinutes,
    int? dhuhrOffsetMinutes,
    int? asrOffsetMinutes,
    int? maghribOffsetMinutes,
    int? ishaOffsetMinutes,
  }) {
    return PrayerOffsets(
      fajrOffsetMinutes: fajrOffsetMinutes ?? this.fajrOffsetMinutes,
      sunriseOffsetMinutes: sunriseOffsetMinutes ?? this.sunriseOffsetMinutes,
      dhuhrOffsetMinutes: dhuhrOffsetMinutes ?? this.dhuhrOffsetMinutes,
      asrOffsetMinutes: asrOffsetMinutes ?? this.asrOffsetMinutes,
      maghribOffsetMinutes: maghribOffsetMinutes ?? this.maghribOffsetMinutes,
      ishaOffsetMinutes: ishaOffsetMinutes ?? this.ishaOffsetMinutes,
    );
  }

  PrayerOffsets operator +(PrayerOffsets other) {
    return PrayerOffsets(
      fajrOffsetMinutes: fajrOffsetMinutes + other.fajrOffsetMinutes,
      sunriseOffsetMinutes: sunriseOffsetMinutes + other.sunriseOffsetMinutes,
      dhuhrOffsetMinutes: dhuhrOffsetMinutes + other.dhuhrOffsetMinutes,
      asrOffsetMinutes: asrOffsetMinutes + other.asrOffsetMinutes,
      maghribOffsetMinutes: maghribOffsetMinutes + other.maghribOffsetMinutes,
      ishaOffsetMinutes: ishaOffsetMinutes + other.ishaOffsetMinutes,
    );
  }

  bool get isZero =>
      fajrOffsetMinutes == 0 &&
      sunriseOffsetMinutes == 0 &&
      dhuhrOffsetMinutes == 0 &&
      asrOffsetMinutes == 0 &&
      maghribOffsetMinutes == 0 &&
      ishaOffsetMinutes == 0;
}

class PrayerSettings {
  const PrayerSettings({
    required this.city,
    required this.calculationMethod,
    required this.madhhab,
    required this.useGeolocation,
    required this.notificationsEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.adhanEnabled,
    required this.manualOffsetsEnabled,
    required this.manualOffsets,
  });

  final String city;
  final String calculationMethod;
  final Madhhab madhhab;
  final bool useGeolocation;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool adhanEnabled;
  final bool manualOffsetsEnabled;
  final PrayerOffsets manualOffsets;

  PrayerSettings copyWith({
    String? city,
    String? calculationMethod,
    Madhhab? madhhab,
    bool? useGeolocation,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? adhanEnabled,
    bool? manualOffsetsEnabled,
    PrayerOffsets? manualOffsets,
  }) {
    return PrayerSettings(
      city: city ?? this.city,
      calculationMethod: calculationMethod ?? this.calculationMethod,
      madhhab: madhhab ?? this.madhhab,
      useGeolocation: useGeolocation ?? this.useGeolocation,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      adhanEnabled: adhanEnabled ?? this.adhanEnabled,
      manualOffsetsEnabled: manualOffsetsEnabled ?? this.manualOffsetsEnabled,
      manualOffsets: manualOffsets ?? this.manualOffsets,
    );
  }
}

class VoiceSettings {
  const VoiceSettings({
    required this.voiceInputEnabled,
    required this.voiceReplyEnabled,
    required this.autoSpeakAiReply,
    required this.rate,
    required this.pitch,
  });

  final bool voiceInputEnabled;
  final bool voiceReplyEnabled;
  final bool autoSpeakAiReply;
  final double rate;
  final double pitch;

  VoiceSettings copyWith({
    bool? voiceInputEnabled,
    bool? voiceReplyEnabled,
    bool? autoSpeakAiReply,
    double? rate,
    double? pitch,
  }) {
    return VoiceSettings(
      voiceInputEnabled: voiceInputEnabled ?? this.voiceInputEnabled,
      voiceReplyEnabled: voiceReplyEnabled ?? this.voiceReplyEnabled,
      autoSpeakAiReply: autoSpeakAiReply ?? this.autoSpeakAiReply,
      rate: rate ?? this.rate,
      pitch: pitch ?? this.pitch,
    );
  }
}

class ActiveMentorSettings {
  const ActiveMentorSettings({
    required this.enabled,
    required this.mode,
    required this.maxFollowUpsPerItem,
    required this.quietHoursStart,
    required this.quietHoursEnd,
  });

  final bool enabled;
  final AiMentorMode mode;
  final int maxFollowUpsPerItem;
  final TimeOfDay quietHoursStart;
  final TimeOfDay quietHoursEnd;

  ActiveMentorSettings copyWith({
    bool? enabled,
    AiMentorMode? mode,
    int? maxFollowUpsPerItem,
    TimeOfDay? quietHoursStart,
    TimeOfDay? quietHoursEnd,
  }) {
    return ActiveMentorSettings(
      enabled: enabled ?? this.enabled,
      mode: mode ?? this.mode,
      maxFollowUpsPerItem: maxFollowUpsPerItem ?? this.maxFollowUpsPerItem,
      quietHoursStart: quietHoursStart ?? this.quietHoursStart,
      quietHoursEnd: quietHoursEnd ?? this.quietHoursEnd,
    );
  }
}

class UserSettings {
  const UserSettings({
    required this.userName,
    required this.language,
    required this.themeMode,
    required this.prayer,
    required this.aiMode,
    required this.voice,
    required this.activeMentor,
    required this.notificationsEnabled,
    required this.isOnboardingComplete,
  });

  final String userName;
  final AppLanguage language;
  final AppThemePreference themeMode;
  final PrayerSettings prayer;
  final AiMentorMode aiMode;
  final VoiceSettings voice;
  final ActiveMentorSettings activeMentor;
  final bool notificationsEnabled;
  final bool isOnboardingComplete;

  UserSettings copyWith({
    String? userName,
    AppLanguage? language,
    AppThemePreference? themeMode,
    PrayerSettings? prayer,
    AiMentorMode? aiMode,
    VoiceSettings? voice,
    ActiveMentorSettings? activeMentor,
    bool? notificationsEnabled,
    bool? isOnboardingComplete,
  }) {
    return UserSettings(
      userName: userName ?? this.userName,
      language: language ?? this.language,
      themeMode: themeMode ?? this.themeMode,
      prayer: prayer ?? this.prayer,
      aiMode: aiMode ?? this.aiMode,
      voice: voice ?? this.voice,
      activeMentor: activeMentor ?? this.activeMentor,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }
}
