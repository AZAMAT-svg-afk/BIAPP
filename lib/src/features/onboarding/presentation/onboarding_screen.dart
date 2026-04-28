import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/user_settings.dart';
import '../../settings/presentation/settings_labels.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsControllerProvider);
    _nameController = TextEditingController(text: settings.userName);
    _cityController = TextEditingController(text: settings.prayer.city);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return Scaffold(
      body: AppBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const SizedBox(height: 10),
              Text(
                l10n.onboardingTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.onboardingSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 22),
              AppCard(
                color: context.palette.softCard,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label(l10n.yourName),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(labelText: l10n.yourName),
                      onChanged: controller.updateUserName,
                    ),
                    const SizedBox(height: 18),
                    _Label(l10n.language),
                    _LanguageSelector(
                      value: settings.language,
                      onChanged: controller.updateLanguage,
                    ),
                    const SizedBox(height: 18),
                    _Label(l10n.theme),
                    _ThemeSelector(
                      value: settings.themeMode,
                      onChanged: controller.updateTheme,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label(l10n.prayerSetup),
                    TextField(
                      controller: _cityController,
                      decoration: InputDecoration(labelText: l10n.city),
                      onChanged: (value) {
                        controller.updatePrayer(
                          settings.prayer.copyWith(city: value),
                        );
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: settings.prayer.useGeolocation,
                      title: Text(l10n.geolocation),
                      onChanged: (value) {
                        controller.updatePrayer(
                          settings.prayer.copyWith(useGeolocation: value),
                        );
                      },
                    ),
                    DropdownButtonFormField<String>(
                      initialValue: settings.prayer.calculationMethod,
                      decoration: InputDecoration(
                        labelText: l10n.calculationMethod,
                      ),
                      items:
                          const [
                            'Muslim World League',
                            'Umm al-Qura',
                            'Karachi',
                          ].map((method) {
                            return DropdownMenuItem(
                              value: method,
                              child: Text(method),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.updatePrayer(
                            settings.prayer.copyWith(calculationMethod: value),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    SegmentedButton<Madhhab>(
                      segments: [
                        ButtonSegment(
                          value: Madhhab.hanafi,
                          label: Text(l10n.hanafi),
                        ),
                        ButtonSegment(
                          value: Madhhab.shafii,
                          label: Text(l10n.shafii),
                        ),
                      ],
                      selected: {settings.prayer.madhhab},
                      onSelectionChanged: (value) {
                        controller.updatePrayer(
                          settings.prayer.copyWith(madhhab: value.first),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label(l10n.aiMentorMode),
                    _AiModeSelector(
                      value: settings.aiMode,
                      onChanged: controller.updateAiMode,
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      value: settings.activeMentor.enabled,
                      title: Text(l10n.activeMentor),
                      subtitle: Text(l10n.activeMentorHint),
                      onChanged: (value) {
                        controller.updateActiveMentor(
                          settings.activeMentor.copyWith(enabled: value),
                        );
                      },
                    ),
                    PrimaryButton(
                      label: l10n.requestNotifications,
                      icon: Icons.notifications_active_outlined,
                      onPressed: () async {
                        final allowed = await ref
                            .read(notificationServiceProvider)
                            .requestPermissions();
                        controller.updateNotifications(allowed);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: l10n.startApp,
                icon: Icons.arrow_forward,
                onPressed: controller.completeOnboarding,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageSelector extends StatelessWidget {
  const _LanguageSelector({required this.value, required this.onChanged});

  final AppLanguage value;
  final ValueChanged<AppLanguage> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<AppLanguage>(
      segments: [
        for (final language in AppLanguage.values)
          ButtonSegment(
            value: language,
            label: Text(SettingsLabels.language(language)),
          ),
      ],
      selected: {value},
      onSelectionChanged: (value) => onChanged(value.first),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.value, required this.onChanged});

  final AppThemePreference value;
  final ValueChanged<AppThemePreference> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 8,
      children: [
        for (final theme in AppThemePreference.values)
          ChoiceChip(
            label: Text(SettingsLabels.theme(l10n, theme)),
            selected: value == theme,
            onSelected: (_) => onChanged(theme),
          ),
      ],
    );
  }
}

class _AiModeSelector extends StatelessWidget {
  const _AiModeSelector({required this.value, required this.onChanged});

  final AiMentorMode value;
  final ValueChanged<AiMentorMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final mode in AiMentorMode.values)
          ChoiceChip(
            label: Text(SettingsLabels.aiMode(l10n, mode)),
            selected: value == mode,
            onSelected: (_) => onChanged(mode),
          ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
