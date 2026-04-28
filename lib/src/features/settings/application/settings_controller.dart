import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../data/settings_repository.dart';
import '../domain/user_settings.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(appDatabaseProvider)),
);

final settingsControllerProvider =
    NotifierProvider<SettingsController, UserSettings>(SettingsController.new);

class SettingsController extends Notifier<UserSettings> {
  @override
  UserSettings build() {
    final repository = ref.read(settingsRepositoryProvider);
    final subscription = repository.watchSettings().listen((settings) {
      state = settings;
    });
    ref.onDispose(subscription.cancel);
    unawaited(repository.ensureDefaults());
    return repository.initialSettings();
  }

  void updateUserName(String value) {
    _save(
      state.copyWith(userName: value.trim().isEmpty ? state.userName : value),
    );
  }

  void updateLanguage(AppLanguage language) {
    _save(state.copyWith(language: language));
  }

  void updateTheme(AppThemePreference themeMode) {
    _save(state.copyWith(themeMode: themeMode));
  }

  void updatePrayer(PrayerSettings prayer) {
    _save(state.copyWith(prayer: prayer));
  }

  void updateAiMode(AiMentorMode mode) {
    _save(
      state.copyWith(
        aiMode: mode,
        activeMentor: state.activeMentor.copyWith(mode: mode),
      ),
    );
  }

  void updateNotifications(bool enabled) {
    _save(state.copyWith(notificationsEnabled: enabled));
  }

  void updateActiveMentor(ActiveMentorSettings activeMentor) {
    _save(state.copyWith(activeMentor: activeMentor));
  }

  void completeOnboarding() {
    _save(state.copyWith(isOnboardingComplete: true));
  }

  void restartOnboarding() {
    _save(state.copyWith(isOnboardingComplete: false));
  }

  void _save(UserSettings next) {
    state = next;
    unawaited(ref.read(settingsRepositoryProvider).saveSettings(next));
  }
}
