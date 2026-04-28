import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../settings/application/settings_controller.dart';
import '../../settings/domain/user_settings.dart';
import '../../settings/presentation/settings_labels.dart';
import '../application/ai_context_builder.dart';
import '../application/ai_controller.dart';
import '../domain/ai_message.dart';
import 'widgets/ai_message_bubble.dart';

class AiScreen extends ConsumerStatefulWidget {
  const AiScreen({super.key});

  @override
  ConsumerState<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends ConsumerState<AiScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chat = ref.watch(aiControllerProvider);
    final settings = ref.watch(settingsControllerProvider);
    final aiContext = ref.watch(aiContextBuilderProvider).build(l10n);

    ref.listen(aiControllerProvider, (previous, next) {
      if ((previous?.messages.length ?? 0) != next.messages.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });

    return AppScaffold(
      title: l10n.aiTitle,
      backgroundMood: AppBackgroundMood.ai,
      actions: [
        IconButton(
          tooltip: l10n.clearAiHistory,
          onPressed: () => ref.read(aiControllerProvider.notifier).clear(),
          icon: const Icon(Icons.delete_sweep_outlined),
        ),
      ],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: AppMotion(child: _AiContextCard(contextData: aiContext)),
          ),
          Expanded(
            child: chat.messages.isEmpty
                ? _EmptyAiState(onPrompt: _usePrompt)
                : ListView.separated(
                    controller: _scrollController,
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    itemCount: chat.messages.length + (chat.isSending ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index == chat.messages.length) {
                        return const _TypingBubble();
                      }
                      return AppMotion(
                        distance: 8,
                        child: AiMessageBubble(message: chat.messages[index]),
                      );
                    },
                  ),
          ),
          if (chat.errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                chat.errorMessage == 'ai_unavailable'
                    ? l10n.aiUnavailable
                    : '${l10n.aiErrorPrefix}: ${chat.errorMessage}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !chat.isSending,
                      minLines: 1,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: settings.aiMode == AiMentorMode.off
                            ? l10n.aiModeOffNotice
                            : l10n.aiInputHint,
                        prefixIcon: const Icon(Icons.auto_awesome),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    onPressed: chat.isSending ? null : _send,
                    icon: chat.isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context)!;
    final contextData = ref.read(aiContextBuilderProvider).build(l10n);
    await ref
        .read(aiControllerProvider.notifier)
        .sendMessage(input: _controller.text, context: contextData);
    _controller.clear();
  }

  void _usePrompt(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }
}

class _AiContextCard extends StatelessWidget {
  const _AiContextCard({required this.contextData});

  final AiUserContext contextData;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final completedHabits = contextData.habits.where((habit) {
      return habit.isCompletedToday;
    }).length;

    return AppCard(
      padding: const EdgeInsets.all(16),
      color: context.palette.softCard,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.memory, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.aiContextTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Chip(
                label: Text(SettingsLabels.aiMode(l10n, contextData.mode)),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ContextChip(
                icon: Icons.task_alt,
                label: l10n.aiContextTasks(
                  contextData.completedTasks.length,
                  contextData.todayTasks.length,
                ),
              ),
              _ContextChip(
                icon: Icons.track_changes,
                label: l10n.aiContextHabits(
                  completedHabits,
                  contextData.habits.length,
                ),
              ),
              _ContextChip(
                icon: Icons.mosque,
                label: l10n.aiContextNextPrayer(
                  contextData.nextPrayerName,
                  contextData.timeToPrayer,
                ),
              ),
              _ContextChip(
                icon: Icons.local_fire_department,
                label: l10n.aiContextStreak(contextData.appStreak),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContextChip extends StatelessWidget {
  const _ContextChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.labelMedium),
          ],
        ),
      ),
    );
  }
}

class _EmptyAiState extends StatelessWidget {
  const _EmptyAiState({required this.onPrompt});

  final ValueChanged<String> onPrompt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prompts = [
      l10n.aiQuickLazy,
      l10n.aiQuickPlanDay,
      l10n.aiQuickSummary,
      l10n.aiQuickMotivate,
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 44,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              l10n.aiEmpty,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 18),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                for (final prompt in prompts)
                  ActionChip(
                    avatar: const Icon(Icons.bolt, size: 16),
                    label: Text(prompt),
                    onPressed: () => onPrompt(prompt),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.palette.softCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppPulse(
                child: const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              const SizedBox(width: 10),
              Text(l10n.aiTyping),
            ],
          ),
        ),
      ),
    );
  }
}
