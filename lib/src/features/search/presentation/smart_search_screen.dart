import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_chip.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../application/smart_search_controller.dart';
import '../data/semantic_index_repository.dart';

class SmartSearchScreen extends ConsumerStatefulWidget {
  const SmartSearchScreen({super.key});

  @override
  ConsumerState<SmartSearchScreen> createState() => _SmartSearchScreenState();
}

class _SmartSearchScreenState extends ConsumerState<SmartSearchScreen> {
  final _queryController = TextEditingController();

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(smartSearchControllerProvider);

    return AppScaffold(
      title: l10n.smartSearch,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 150),
        children: [
          TextField(
            controller: _queryController,
            enabled: !state.isSearching,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.travel_explore),
              labelText: l10n.searchByMeaning,
              hintText: l10n.searchNotesAndTasks,
            ),
            onSubmitted: (_) => _search(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: state.isSearching ? null : _search,
                  icon: state.isSearching
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.search),
                  label: Text(l10n.search),
                ),
              ),
              const SizedBox(width: 10),
              IconButton.filledTonal(
                tooltip: l10n.rebuildIndex,
                onPressed: state.isIndexing
                    ? null
                    : () => ref
                          .read(smartSearchControllerProvider.notifier)
                          .rebuildIndex(l10n),
                icon: const Icon(Icons.sync),
              ),
            ],
          ),
          if (state.isIndexing) ...[
            const SizedBox(height: 12),
            _IndexingStatus(state: state),
          ],
          if (state.isReranking) ...[
            const SizedBox(height: 12),
            _InlineProgress(label: l10n.rerankingResults),
          ],
          if (state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              state.errorMessage!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          if (state.indexFailureCount > 0 && !state.isIndexing) ...[
            const SizedBox(height: 12),
            Text(
              l10n.indexFailed,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          const SizedBox(height: 18),
          if (!state.isSearching &&
              state.query.isNotEmpty &&
              state.results.isEmpty)
            AppEmptyState(
              message: l10n.noResults,
              icon: Icons.manage_search_outlined,
            )
          else
            ...state.results.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: AppMotion(
                  delay: Duration(milliseconds: 35 * entry.key),
                  child: _SearchResultCard(
                    result: entry.value,
                    onTap: () => _showResultDetails(entry.value),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  void _search() {
    ref
        .read(smartSearchControllerProvider.notifier)
        .search(_queryController.text);
  }

  void _showResultDetails(SemanticSearchResult result) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
          child: AppCard(
            borderRadius: 28,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppChip(
                    label: _sourceLabel(l10n, result.item.sourceType),
                    color: _sourceColor(context, result.item.sourceType),
                    icon: _sourceIcon(result.item.sourceType),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    result.item.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (result.item.content.trim().isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(result.item.content),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.result, required this.onTap});

  final SemanticSearchResult result;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final content = result.item.content.trim();

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppChip(
                label: _sourceLabel(l10n, result.item.sourceType),
                color: _sourceColor(context, result.item.sourceType),
                icon: _sourceIcon(result.item.sourceType),
              ),
              const Spacer(),
              Text(
                result.rerankScore.toStringAsFixed(2),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            result.item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (content.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(content, maxLines: 3, overflow: TextOverflow.ellipsis),
          ],
        ],
      ),
    );
  }
}

class _IndexingStatus extends ConsumerWidget {
  const _IndexingStatus({required this.state});

  final SmartSearchState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final total = state.indexTotalCount;
    final done = state.indexDoneCount;

    return AppCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(l10n.indexing)),
              Text('$done/$total'),
              const SizedBox(width: 8),
              IconButton(
                tooltip: l10n.cancel,
                onPressed: () => ref
                    .read(smartSearchControllerProvider.notifier)
                    .cancelIndexing(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: state.indexProgress),
        ],
      ),
    );
  }
}

class _InlineProgress extends StatelessWidget {
  const _InlineProgress({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox.square(
          dimension: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        const SizedBox(width: 10),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

String _sourceLabel(AppLocalizations l10n, SemanticSourceType type) {
  return switch (type) {
    SemanticSourceType.note => l10n.sourceNote,
    SemanticSourceType.task => l10n.sourceTask,
    SemanticSourceType.habit => l10n.sourceHabit,
  };
}

IconData _sourceIcon(SemanticSourceType type) {
  return switch (type) {
    SemanticSourceType.note => Icons.notes_outlined,
    SemanticSourceType.task => Icons.task_alt,
    SemanticSourceType.habit => Icons.track_changes,
  };
}

Color _sourceColor(BuildContext context, SemanticSourceType type) {
  return switch (type) {
    SemanticSourceType.note => Theme.of(context).colorScheme.primary,
    SemanticSourceType.task => context.palette.success,
    SemanticSourceType.habit => context.palette.warning,
  };
}
