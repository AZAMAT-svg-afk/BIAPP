import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';
import '../core/theme/app_theme.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/settings/application/settings_controller.dart';
import 'shell/app_shell.dart';
import 'startup_bootstrapper.dart';

class BarakaApp extends ConsumerWidget {
  const BarakaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Baraka AI',
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      locale: Locale(settings.language.code),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: settings.themeMode.flutterThemeMode,
      themeAnimationDuration: const Duration(milliseconds: 320),
      themeAnimationCurve: Curves.easeOutCubic,
      builder: (context, child) {
        return StartupBootstrapper(child: child ?? const SizedBox.shrink());
      },
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        child: settings.isOnboardingComplete
            ? const AppShell(key: ValueKey('app-shell'))
            : const OnboardingScreen(key: ValueKey('onboarding')),
      ),
    );
  }
}
