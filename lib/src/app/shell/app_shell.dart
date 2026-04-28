import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../core/theme/app_palette.dart';
import '../../core/widgets/app_background.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_motion.dart';
import '../../features/ai/presentation/ai_screen.dart';
import '../../features/habits/presentation/habits_screen.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/notes/presentation/notes_screen.dart';
import '../../features/prayer/presentation/prayer_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/stats/presentation/stats_screen.dart';
import '../../features/tasks/presentation/tasks_screen.dart';
import 'app_destination.dart';

final appDestinationProvider =
    NotifierProvider<AppDestinationController, AppDestination>(
      AppDestinationController.new,
    );

class AppDestinationController extends Notifier<AppDestination> {
  @override
  AppDestination build() => AppDestination.home;

  void setDestination(AppDestination destination) {
    state = destination;
  }
}

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  final Set<AppDestination> _visited = {AppDestination.home};

  @override
  Widget build(BuildContext context) {
    final destination = ref.watch(appDestinationProvider);
    final l10n = AppLocalizations.of(context)!;
    _visited.add(destination);

    return Scaffold(
      extendBody: true,
      body: _LazyDestinationStack(active: destination, visited: _visited),
      bottomNavigationBar: AppBottomNav(
        selectedIndex: _navIndex(destination),
        onSelected: (index) {
          final next = switch (index) {
            0 => AppDestination.home,
            1 => AppDestination.tasks,
            2 => AppDestination.prayer,
            3 => AppDestination.ai,
            _ => AppDestination.more,
          };
          ref.read(appDestinationProvider.notifier).setDestination(next);
        },
        items: [
          AppBottomNavItem(
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            label: l10n.homeTab,
          ),
          AppBottomNavItem(
            icon: Icons.check_circle_outline,
            selectedIcon: Icons.check_circle,
            label: l10n.tasksTab,
          ),
          AppBottomNavItem(
            icon: Icons.mosque_outlined,
            selectedIcon: Icons.mosque,
            label: l10n.prayerTab,
          ),
          AppBottomNavItem(
            icon: Icons.auto_awesome_outlined,
            selectedIcon: Icons.auto_awesome,
            label: l10n.aiTab,
          ),
          AppBottomNavItem(
            icon: Icons.grid_view_outlined,
            selectedIcon: Icons.grid_view,
            label: l10n.moreTab,
          ),
        ],
      ),
    );
  }

  int _navIndex(AppDestination destination) {
    return switch (destination) {
      AppDestination.home => 0,
      AppDestination.tasks => 1,
      AppDestination.prayer => 2,
      AppDestination.ai => 3,
      _ => 4,
    };
  }
}

class _LazyDestinationStack extends StatelessWidget {
  const _LazyDestinationStack({required this.active, required this.visited});

  final AppDestination active;
  final Set<AppDestination> visited;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (final destination in AppDestination.values)
          _DestinationLayer(
            destination: destination,
            active: active == destination,
            visited: visited.contains(destination),
          ),
      ],
    );
  }
}

class _DestinationLayer extends StatelessWidget {
  const _DestinationLayer({
    required this.destination,
    required this.active,
    required this.visited,
  });

  final AppDestination destination;
  final bool active;
  final bool visited;

  @override
  Widget build(BuildContext context) {
    if (!visited) {
      return const SizedBox.shrink();
    }

    return TickerMode(
      enabled: active,
      child: Offstage(
        offstage: !active,
        child: AnimatedOpacity(
          opacity: active ? 1 : 0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          child: _buildDestination(destination),
        ),
      ),
    );
  }

  Widget _buildDestination(AppDestination destination) {
    return switch (destination) {
      AppDestination.home => const HomeScreen(),
      AppDestination.tasks => const TasksScreen(),
      AppDestination.prayer => const PrayerScreen(),
      AppDestination.ai => const AiScreen(),
      AppDestination.more => const MoreScreen(),
      AppDestination.notes => const NotesScreen(),
      AppDestination.habits => const HabitsScreen(),
      AppDestination.stats => const StatsScreen(),
      AppDestination.settings => const SettingsScreen(),
    };
  }
}

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _MoreItem(l10n.notesTitle, Icons.notes, AppDestination.notes),
      _MoreItem(l10n.habitsTitle, Icons.track_changes, AppDestination.habits),
      _MoreItem(l10n.statsTitle, Icons.insights, AppDestination.stats),
      _MoreItem(l10n.settingsTitle, Icons.settings, AppDestination.settings),
    ];

    return AppBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppMotion(
                child: Text(
                  l10n.moreTab,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 150),
                  itemCount: items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.14,
                  ),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return AppMotion(
                      delay: Duration(milliseconds: 45 * index),
                      child: AppCard(
                        onTap: () {
                          ref
                              .read(appDestinationProvider.notifier)
                              .setDestination(item.destination);
                        },
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            context.palette.card.withValues(alpha: 0.96),
                            context.palette.softCard.withValues(alpha: 0.88),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                item.icon,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              item.title,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreItem {
  const _MoreItem(this.title, this.icon, this.destination);

  final String title;
  final IconData icon;
  final AppDestination destination;
}
