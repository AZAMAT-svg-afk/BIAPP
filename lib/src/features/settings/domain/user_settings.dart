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
  });

  final String city;
  final String calculationMethod;
  final Madhhab madhhab;
  final bool useGeolocation;
  final bool notificationsEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool adhanEnabled;

  PrayerSettings copyWith({
    String? city,
    String? calculationMethod,
    Madhhab? madhhab,
    bool? useGeolocation,
    bool? notificationsEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? adhanEnabled,
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
    required this.activeMentor,
    required this.notificationsEnabled,
    required this.isOnboardingComplete,
  });

  final String userName;
  final AppLanguage language;
  final AppThemePreference themeMode;
  final PrayerSettings prayer;
  final AiMentorMode aiMode;
  final ActiveMentorSettings activeMentor;
  final bool notificationsEnabled;
  final bool isOnboardingComplete;

  UserSettings copyWith({
    String? userName,
    AppLanguage? language,
    AppThemePreference? themeMode,
    PrayerSettings? prayer,
    AiMentorMode? aiMode,
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
      activeMentor: activeMentor ?? this.activeMentor,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
    );
  }
}
