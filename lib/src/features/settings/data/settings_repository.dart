import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

import '../../../core/database/app_database.dart';
import '../domain/user_settings.dart';

class SettingsRepository {
  SettingsRepository(this._database);

  final AppDatabase _database;

  UserSettings initialSettings() {
    return const UserSettings(
      userName: 'Aza',
      language: AppLanguage.ru,
      themeMode: AppThemePreference.system,
      prayer: PrayerSettings(
        city: 'qyzylorda',
        calculationMethod: 'DUMK / Sajda Kazakhstan',
        madhhab: Madhhab.hanafi,
        useGeolocation: false,
        notificationsEnabled: true,
        soundEnabled: true,
        vibrationEnabled: true,
        adhanEnabled: false,
        manualOffsetsEnabled: false,
        manualOffsets: PrayerOffsets.zero,
      ),
      aiMode: AiMentorMode.normal,
      voice: VoiceSettings(
        voiceInputEnabled: true,
        voiceReplyEnabled: true,
        autoSpeakAiReply: false,
        rate: 0.48,
        pitch: 1.0,
      ),
      activeMentor: ActiveMentorSettings(
        enabled: true,
        mode: AiMentorMode.normal,
        maxFollowUpsPerItem: 2,
        quietHoursStart: TimeOfDay(hour: 22, minute: 0),
        quietHoursEnd: TimeOfDay(hour: 7, minute: 0),
      ),
      notificationsEnabled: true,
      isOnboardingComplete: false,
    );
  }

  Stream<UserSettings> watchSettings() async* {
    await ensureDefaults();
    yield* _database
        .select(_database.settingsRecords)
        .watchSingle()
        .map(_fromRecord);
  }

  Future<void> ensureDefaults() async {
    final existing = await _database
        .select(_database.settingsRecords)
        .getSingleOrNull();
    if (existing != null) {
      return;
    }
    await saveSettings(initialSettings());
  }

  Future<void> saveSettings(UserSettings settings) {
    return _database
        .into(_database.settingsRecords)
        .insertOnConflictUpdate(_toCompanion(settings));
  }

  SettingsRecordsCompanion _toCompanion(UserSettings settings) {
    return SettingsRecordsCompanion(
      id: const Value(1),
      userName: Value(settings.userName),
      language: Value(settings.language.name),
      themeMode: Value(settings.themeMode.name),
      city: Value(settings.prayer.city),
      calculationMethod: Value(settings.prayer.calculationMethod),
      madhhab: Value(settings.prayer.madhhab.name),
      useGeolocation: Value(settings.prayer.useGeolocation),
      prayerNotificationsEnabled: Value(settings.prayer.notificationsEnabled),
      soundEnabled: Value(settings.prayer.soundEnabled),
      vibrationEnabled: Value(settings.prayer.vibrationEnabled),
      adhanEnabled: Value(settings.prayer.adhanEnabled),
      manualPrayerOffsetsEnabled: Value(settings.prayer.manualOffsetsEnabled),
      fajrOffsetMinutes: Value(settings.prayer.manualOffsets.fajrOffsetMinutes),
      sunriseOffsetMinutes: Value(
        settings.prayer.manualOffsets.sunriseOffsetMinutes,
      ),
      dhuhrOffsetMinutes: Value(
        settings.prayer.manualOffsets.dhuhrOffsetMinutes,
      ),
      asrOffsetMinutes: Value(settings.prayer.manualOffsets.asrOffsetMinutes),
      maghribOffsetMinutes: Value(
        settings.prayer.manualOffsets.maghribOffsetMinutes,
      ),
      ishaOffsetMinutes: Value(settings.prayer.manualOffsets.ishaOffsetMinutes),
      aiMode: Value(settings.aiMode.name),
      voiceInputEnabled: Value(settings.voice.voiceInputEnabled),
      voiceReplyEnabled: Value(settings.voice.voiceReplyEnabled),
      autoSpeakAiReply: Value(settings.voice.autoSpeakAiReply),
      voiceRate: Value(settings.voice.rate),
      voicePitch: Value(settings.voice.pitch),
      activeMentorEnabled: Value(settings.activeMentor.enabled),
      activeMentorMode: Value(settings.activeMentor.mode.name),
      maxFollowUpsPerItem: Value(settings.activeMentor.maxFollowUpsPerItem),
      quietHoursStartMinutes: Value(
        _timeOfDayToMinutes(settings.activeMentor.quietHoursStart),
      ),
      quietHoursEndMinutes: Value(
        _timeOfDayToMinutes(settings.activeMentor.quietHoursEnd),
      ),
      notificationsEnabled: Value(settings.notificationsEnabled),
      isOnboardingComplete: Value(settings.isOnboardingComplete),
      updatedAt: Value(DateTime.now()),
    );
  }

  UserSettings _fromRecord(SettingsRecord record) {
    final aiMode = _normalizeAiMode(
      _enumByName(AiMentorMode.values, record.aiMode),
    );
    return UserSettings(
      userName: record.userName,
      language: _enumByName(AppLanguage.values, record.language),
      themeMode: _enumByName(AppThemePreference.values, record.themeMode),
      prayer: PrayerSettings(
        city: record.city,
        calculationMethod: record.calculationMethod,
        madhhab: _enumByName(Madhhab.values, record.madhhab),
        useGeolocation: record.useGeolocation,
        notificationsEnabled: record.prayerNotificationsEnabled,
        soundEnabled: record.soundEnabled,
        vibrationEnabled: record.vibrationEnabled,
        adhanEnabled: record.adhanEnabled,
        manualOffsetsEnabled: record.manualPrayerOffsetsEnabled,
        manualOffsets: PrayerOffsets(
          fajrOffsetMinutes: record.fajrOffsetMinutes,
          sunriseOffsetMinutes: record.sunriseOffsetMinutes,
          dhuhrOffsetMinutes: record.dhuhrOffsetMinutes,
          asrOffsetMinutes: record.asrOffsetMinutes,
          maghribOffsetMinutes: record.maghribOffsetMinutes,
          ishaOffsetMinutes: record.ishaOffsetMinutes,
        ),
      ),
      aiMode: aiMode,
      voice: VoiceSettings(
        voiceInputEnabled: record.voiceInputEnabled,
        voiceReplyEnabled: record.voiceReplyEnabled,
        autoSpeakAiReply: record.autoSpeakAiReply,
        rate: record.voiceRate.clamp(0.2, 0.9).toDouble(),
        pitch: record.voicePitch.clamp(0.5, 1.5).toDouble(),
      ),
      activeMentor: ActiveMentorSettings(
        enabled: record.activeMentorEnabled,
        mode: _normalizeAiMode(
          _enumByName(AiMentorMode.values, record.activeMentorMode),
        ),
        maxFollowUpsPerItem: record.maxFollowUpsPerItem,
        quietHoursStart: _minutesToTimeOfDay(record.quietHoursStartMinutes),
        quietHoursEnd: _minutesToTimeOfDay(record.quietHoursEndMinutes),
      ),
      notificationsEnabled: record.notificationsEnabled,
      isOnboardingComplete: record.isOnboardingComplete,
    );
  }

  int _timeOfDayToMinutes(TimeOfDay value) {
    return value.hour * 60 + value.minute;
  }

  TimeOfDay _minutesToTimeOfDay(int value) {
    return TimeOfDay(hour: value ~/ 60, minute: value % 60);
  }

  T _enumByName<T extends Enum>(List<T> values, String name) {
    return values.firstWhere(
      (value) => value.name == name,
      orElse: () => values.first,
    );
  }

  AiMentorMode _normalizeAiMode(AiMentorMode mode) {
    return mode == AiMentorMode.off ? AiMentorMode.normal : mode;
  }
}
