import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum BackgroundAnimationStyle {
  aurora,
  steppe,
  particles;

  static BackgroundAnimationStyle fromName(String? value) {
    return BackgroundAnimationStyle.values.firstWhere(
      (style) => style.name == value,
      orElse: () => BackgroundAnimationStyle.aurora,
    );
  }
}

final appPreferencesProvider = Provider<AppPreferences>((ref) {
  return AppPreferences();
});

final backgroundStyleControllerProvider =
    NotifierProvider<BackgroundStyleController, BackgroundAnimationStyle>(
      BackgroundStyleController.new,
    );

class AppPreferences {
  AppPreferences({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  static const userNameKey = 'user_name';
  static const appLanguageKey = 'app_language';
  static const aiModeKey = 'ai_mode';
  static const prayerCityKey = 'prayer_city';
  static const backgroundStyleKey = 'background_animation_style';

  final SharedPreferencesAsync _preferences;

  Future<void> setString(String key, String value) {
    return _preferences.setString(key, value);
  }

  Future<String?> getString(String key) {
    return _preferences.getString(key);
  }

  Future<void> setBackgroundStyle(BackgroundAnimationStyle style) {
    return setString(backgroundStyleKey, style.name);
  }

  Future<BackgroundAnimationStyle> getBackgroundStyle() async {
    return BackgroundAnimationStyle.fromName(
      await getString(backgroundStyleKey),
    );
  }
}

class BackgroundStyleController extends Notifier<BackgroundAnimationStyle> {
  @override
  BackgroundAnimationStyle build() {
    unawaited(_load());
    return BackgroundAnimationStyle.aurora;
  }

  Future<void> _load() async {
    final style = await ref.read(appPreferencesProvider).getBackgroundStyle();
    if (state != style) {
      state = style;
    }
  }

  void update(BackgroundAnimationStyle style) {
    state = style;
    unawaited(ref.read(appPreferencesProvider).setBackgroundStyle(style));
  }
}
