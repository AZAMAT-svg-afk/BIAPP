import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/preferences/app_preferences.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/section_header.dart';
import '../../ai/application/ai_controller.dart';
import '../../prayer/data/prayer_repository.dart';
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
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 150),
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
                const SizedBox(height: 12),
                _BackgroundStyleSelector(
                  value: ref.watch(backgroundStyleControllerProvider),
                  onChanged: ref
                      .read(backgroundStyleControllerProvider.notifier)
                      .update,
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
                  value: KazakhstanPrayerCity.resolve(
                    settings.prayer.city,
                  ).displayName,
                  onTap: () => _showCitySelector(context, ref),
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
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.power_settings_new_outlined),
                  title: Text(l10n.aiAlwaysOn),
                  subtitle: Text(l10n.aiBackendConnected),
                ),
                _AiModeSegmentedControl(
                  value: settings.aiMode == AiMentorMode.off
                      ? AiMentorMode.normal
                      : settings.aiMode,
                  onChanged: controller.updateAiMode,
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

  Future<void> _showCitySelector(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsControllerProvider);
    final selected = KazakhstanPrayerCity.resolve(settings.prayer.city);
    final l10n = AppLocalizations.of(context)!;
    final value = await showModalBottomSheet<KazakhstanPrayerCity>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        child: AppCard(
          borderRadius: 28,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.city, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: KazakhstanPrayerCity.cities.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final city = KazakhstanPrayerCity.cities[index];
                      final isSelected =
                          city.displayName == selected.displayName;
                      return ListTile(
                        leading: Icon(
                          isSelected
                              ? Icons.location_on
                              : Icons.location_city_outlined,
                        ),
                        title: Text(city.displayName),
                        subtitle: Text(city.timezone),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle)
                            : null,
                        onTap: () => Navigator.of(context).pop(city),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (value != null) {
      ref
          .read(settingsControllerProvider.notifier)
          .updatePrayer(settings.prayer.copyWith(city: value.displayName));
    }
  }
}

class _ValueTile extends StatelessWidget {
  const _ValueTile({
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(value),
      trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

class _AiModeSegmentedControl extends StatelessWidget {
  const _AiModeSegmentedControl({required this.value, required this.onChanged});

  final AiMentorMode value;
  final ValueChanged<AiMentorMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modes = [AiMentorMode.soft, AiMentorMode.normal, AiMentorMode.strict];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final mode in modes)
          ChoiceChip(
            selected: value == mode,
            onSelected: (_) => onChanged(mode),
            avatar: Icon(
              Icons.circle,
              size: 11,
              color: _modeColor(context, mode),
            ),
            label: Text(SettingsLabels.aiMode(l10n, mode)),
          ),
      ],
    );
  }

  Color _modeColor(BuildContext context, AiMentorMode mode) {
    return switch (mode) {
      AiMentorMode.soft => context.palette.success,
      AiMentorMode.normal => context.palette.warning,
      AiMentorMode.strict => context.palette.danger,
      AiMentorMode.off => context.palette.success,
    };
  }
}

class _BackgroundStyleSelector extends StatelessWidget {
  const _BackgroundStyleSelector({
    required this.value,
    required this.onChanged,
  });

  final BackgroundAnimationStyle value;
  final ValueChanged<BackgroundAnimationStyle> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            l10n.backgroundStyle,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final style in BackgroundAnimationStyle.values)
              AppChip(
                label: _label(l10n, style),
                color: value == style
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.outline,
                icon: _icon(style),
                onTap: () => onChanged(style),
              ),
          ],
        ),
      ],
    );
  }

  String _label(AppLocalizations l10n, BackgroundAnimationStyle style) {
    return switch (style) {
      BackgroundAnimationStyle.aurora => l10n.backgroundAurora,
      BackgroundAnimationStyle.steppe => l10n.backgroundSteppe,
      BackgroundAnimationStyle.particles => l10n.backgroundParticles,
    };
  }

  IconData _icon(BackgroundAnimationStyle style) {
    return switch (style) {
      BackgroundAnimationStyle.aurora => Icons.waves_outlined,
      BackgroundAnimationStyle.steppe => Icons.landscape_outlined,
      BackgroundAnimationStyle.particles => Icons.auto_awesome_outlined,
    };
  }
}
