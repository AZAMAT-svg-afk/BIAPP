import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/section_header.dart';
import '../../ai/application/ai_controller.dart';
import '../../prayer/presentation/prayer_labels.dart';
import '../application/settings_controller.dart';
import '../domain/user_settings.dart';
import 'settings_labels.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return AppScaffold(
      title: l10n.settingsTitle,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
        children: [
          SectionHeader(title: l10n.profile),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                TextFormField(
                  initialValue: settings.userName,
                  decoration: InputDecoration(labelText: l10n.yourName),
                  onChanged: controller.updateUserName,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<AppLanguage>(
                  initialValue: settings.language,
                  decoration: InputDecoration(labelText: l10n.language),
                  items: AppLanguage.values.map((language) {
                    return DropdownMenuItem(
                      value: language,
                      child: Text(SettingsLabels.language(language)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateLanguage(value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<AppThemePreference>(
                  initialValue: settings.themeMode,
                  decoration: InputDecoration(labelText: l10n.theme),
                  items: AppThemePreference.values.map((theme) {
                    return DropdownMenuItem(
                      value: theme,
                      child: Text(SettingsLabels.theme(l10n, theme)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateTheme(value);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader(title: l10n.prayerSettings),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                _ValueTile(
                  icon: Icons.location_city,
                  title: l10n.city,
                  value: settings.prayer.city,
                ),
                _ValueTile(
                  icon: Icons.calculate,
                  title: l10n.calculationMethod,
                  value: settings.prayer.calculationMethod,
                ),
                _ValueTile(
                  icon: Icons.school,
                  title: l10n.madhhab,
                  value: PrayerLabels.madhhab(l10n, settings.prayer.madhhab),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: settings.prayer.notificationsEnabled,
                  title: Text(l10n.prayerNotifications),
                  onChanged: (value) {
                    controller.updatePrayer(
                      settings.prayer.copyWith(notificationsEnabled: value),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader(title: l10n.notifications),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: settings.notificationsEnabled,
                  title: Text(l10n.notifications),
                  onChanged: controller.updateNotifications,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.notifications_active_outlined),
                  title: Text(l10n.requestNotifications),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    final allowed = await ref
                        .read(notificationServiceProvider)
                        .requestPermissions();
                    controller.updateNotifications(allowed);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader(title: l10n.aiSettings),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: settings.aiMode != AiMentorMode.off,
                  title: Text(l10n.aiAssistantToggle),
                  onChanged: (value) {
                    controller.updateAiMode(
                      value ? AiMentorMode.normal : AiMentorMode.off,
                    );
                  },
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<AiMentorMode>(
                  initialValue: settings.aiMode == AiMentorMode.off
                      ? AiMentorMode.normal
                      : settings.aiMode,
                  decoration: InputDecoration(labelText: l10n.aiMentorMode),
                  items: AiMentorMode.values
                      .where((mode) => mode != AiMentorMode.off)
                      .map((mode) {
                        return DropdownMenuItem(
                          value: mode,
                          child: Text(SettingsLabels.aiMode(l10n, mode)),
                        );
                      })
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updateAiMode(value);
                    }
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: settings.activeMentor.enabled,
                  title: Text(l10n.activeMentor),
                  subtitle: Text(l10n.activeMentorAntiSpam),
                  onChanged: (value) {
                    controller.updateActiveMentor(
                      settings.activeMentor.copyWith(enabled: value),
                    );
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.cloud_done_outlined),
                  title: Text(l10n.aiBackendConnected),
                  subtitle: Text(l10n.aiPrivacyNote),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_sweep_outlined),
                  title: Text(l10n.clearAiHistory),
                  onTap: () {
                    ref.read(aiControllerProvider.notifier).clear();
                    _showSnack(context, l10n.done);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          SectionHeader(title: l10n.privacy),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.file_download_outlined),
                  title: Text(l10n.exportData),
                  subtitle: Text(l10n.stub),
                  onTap: () => _showSnack(context, l10n.stub),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.refresh),
                  title: Text(l10n.restartOnboarding),
                  onTap: controller.restartOnboarding,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.delete_forever_outlined),
                  title: Text(l10n.deleteAccount),
                  subtitle: Text(l10n.stub),
                  onTap: () => _showSnack(context, l10n.stub),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
    );
  }
}
