import '../../../../l10n/app_localizations.dart';
import '../domain/user_settings.dart';

class SettingsLabels {
  static String language(AppLanguage language) {
    return switch (language) {
      AppLanguage.ru => 'Русский',
      AppLanguage.en => 'English',
      AppLanguage.kk => 'Қазақша',
    };
  }

  static String theme(AppLocalizations l10n, AppThemePreference theme) {
    return switch (theme) {
      AppThemePreference.system => l10n.themeSystem,
      AppThemePreference.light => l10n.themeLight,
      AppThemePreference.dark => l10n.themeDark,
    };
  }

  static String aiMode(AppLocalizations l10n, AiMentorMode mode) {
    return switch (mode) {
      AiMentorMode.off => l10n.aiModeNormal,
      AiMentorMode.soft => l10n.aiModeSoft,
      AiMentorMode.normal => l10n.aiModeNormal,
      AiMentorMode.strict => l10n.aiModeStrict,
    };
  }
}
