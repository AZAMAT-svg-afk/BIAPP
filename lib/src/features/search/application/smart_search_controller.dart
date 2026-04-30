import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/app_localizations.dart';
import '../../ai/data/semantic_ai_service.dart';
import '../../habits/application/habits_controller.dart';
import '../../habits/presentation/habit_labels.dart';
import '../../notes/application/notes_controller.dart';
import '../../tasks/application/tasks_controller.dart';
import '../../tasks/presentation/task_labels.dart';
import '../data/semantic_index_repository.dart';
import '../domain/vector_math.dart';

final smartSearchControllerProvider =
    NotifierProvider<SmartSearchController, SmartSearchState>(
      SmartSearchController.new,
    );

class SmartSearchController extends Notifier<SmartSearchState> {
  bool _cancelIndexing = false;

  @override
  SmartSearchState build() => const SmartSearchState();

  Future<void> rebuildIndex(AppLocalizations l10n) async {
    if (state.isIndexing) {
      return;
    }

    _cancelIndexing = false;
    state = state.copyWith(
      isIndexing: true,
      indexDoneCount: 0,
      indexTotalCount: 0,
      clearError: true,
      clearIndexFailure: true,
    );

    final repository = ref.read(semanticIndexRepositoryProvider);
    final service = ref.read(semanticAiServiceProvider);
    final sources = await _collectSources(l10n);
    final sourceIds = sources.map((source) => source.id).toSet();
    final existingItems = await repository.listSemanticItems();
    final existingById = {for (final item in existingItems) item.id: item};

    var processed = 0;
    var failed = 0;
    state = state.copyWith(indexTotalCount: sources.length);

    for (final existing in existingItems) {
      if (!sourceIds.contains(existing.id)) {
        await repository.deleteSemanticItem(existing.id);
      }
    }

    for (final source in sources) {
      if (_cancelIndexing) {
        break;
      }

      final existing = existingById[source.id];
      final isFresh =
          existing != null &&
          existing.updatedAt.isAtSameMomentAs(source.updatedAt) &&
          existing.embedding.isNotEmpty;

      if (!isFresh) {
        try {
          final embedding = await service.embedText(source.searchText);
          if (embedding.isEmpty) {
            throw const SemanticAiException('Embedding vector is empty');
          }
          await repository.upsertSemanticItem(
            source.copyWith(embedding: embedding),
          );
        } on Object catch (error, stackTrace) {
          failed++;
          if (kDebugMode) {
            debugPrint('Semantic index failed for ${source.id}: $error');
            debugPrint('$stackTrace');
          }
        }
      }

      processed++;
      state = state.copyWith(
        indexDoneCount: processed,
        indexTotalCount: sources.length,
      );
    }

    state = state.copyWith(
      isIndexing: false,
      indexFailureCount: failed,
      lastIndexedAt: DateTime.now(),
    );
  }

  void cancelIndexing() {
    _cancelIndexing = true;
  }

  Future<void> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty || state.isSearching) {
      return;
    }

    state = state.copyWith(
      query: trimmed,
      isSearching: true,
      isReranking: false,
      clearError: true,
    );

    try {
      final service = ref.read(semanticAiServiceProvider);
      final repository = ref.read(semanticIndexRepositoryProvider);
      final queryEmbedding = await service.embedText(trimmed);
      final indexedItems = await repository.listSemanticItems();

      final scored = [
        for (final item in indexedItems)
          if (item.embedding.isNotEmpty)
            _ScoredSemanticItem(
              item: item,
              score: cosineSimilarity(queryEmbedding, item.embedding),
            ),
      ]..sort((left, right) => right.score.compareTo(left.score));

      final candidates = scored.take(20).toList();
      if (candidates.isEmpty) {
        state = state.copyWith(
          isSearching: false,
          isReranking: false,
          results: const [],
        );
        return;
      }

      state = state.copyWith(isReranking: true);

      final reranked = await service.rerank(
        query: trimmed,
        topK: math.min(10, candidates.length),
        documents: [
          for (final candidate in candidates)
            RerankDocument(
              id: candidate.item.id,
              text: _truncate(candidate.item.searchText, 1200),
              metadata: {
                'sourceType': candidate.item.sourceType.name,
                'sourceId': candidate.item.sourceId,
                'title': candidate.item.title,
                'cosineScore': candidate.score,
              },
            ),
        ],
      );

      final candidatesById = {
        for (final candidate in candidates) candidate.item.id: candidate,
      };
      final results = [
        for (final result in reranked)
          if (candidatesById[result.id] != null)
            SemanticSearchResult(
              item: candidatesById[result.id]!.item,
              cosineScore: candidatesById[result.id]!.score,
              rerankScore: result.score,
            ),
      ];

      state = state.copyWith(
        isSearching: false,
        isReranking: false,
        results: results,
      );
    } on Object catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('Smart search failed: $error');
        debugPrint('$stackTrace');
      }
      state = state.copyWith(
        isSearching: false,
        isReranking: false,
        errorMessage: error.toString(),
      );
    }
  }

  Future<List<SemanticIndexEntry>> _collectSources(
    AppLocalizations l10n,
  ) async {
    final tasks = await ref.read(tasksRepositoryProvider).listTasks();
    final notes = await ref.read(notesRepositoryProvider).listNotes();
    final habits = await ref.read(habitsRepositoryProvider).listHabits();

    return [
      for (final note in notes)
        SemanticIndexEntry.source(
          sourceType: SemanticSourceType.note,
          sourceId: note.id,
          title: note.title,
          content: [
            note.content,
            if (note.category.trim().isNotEmpty) note.category.trim(),
            if (note.tags.isNotEmpty) note.tags.join(', '),
          ].where((part) => part.trim().isNotEmpty).join('\n'),
          updatedAt: note.updatedAt,
        ),
      for (final task in tasks)
        SemanticIndexEntry.source(
          sourceType: SemanticSourceType.task,
          sourceId: task.id,
          title: TaskLabels.title(l10n, task),
          content: [
            TaskLabels.description(l10n, task),
            task.category,
            task.priority.name,
            task.repeatType.name,
          ].where((part) => part.trim().isNotEmpty).join('\n'),
          updatedAt: task.updatedAt,
        ),
      for (final habit in habits)
        SemanticIndexEntry.source(
          sourceType: SemanticSourceType.habit,
          sourceId: habit.id,
          title: HabitLabels.name(l10n, habit),
          content: [
            habit.category,
            'target_per_day: ${habit.targetPerDay}',
            'completed_today: ${habit.completedToday}',
            'streak: ${habit.streak}',
          ].where((part) => part.trim().isNotEmpty).join('\n'),
          updatedAt: habit.updatedAt,
        ),
    ];
  }

  String _truncate(String value, int limit) {
    final runes = value.runes.toList();
    if (runes.length <= limit) {
      return value;
    }
    return String.fromCharCodes(runes.take(limit));
  }
}

class SmartSearchState {
  const SmartSearchState({
    this.query = '',
    this.isSearching = false,
    this.isReranking = false,
    this.isIndexing = false,
    this.indexDoneCount = 0,
    this.indexTotalCount = 0,
    this.indexFailureCount = 0,
    this.lastIndexedAt,
    this.errorMessage,
    this.results = const [],
  });

  final String query;
  final bool isSearching;
  final bool isReranking;
  final bool isIndexing;
  final int indexDoneCount;
  final int indexTotalCount;
  final int indexFailureCount;
  final DateTime? lastIndexedAt;
  final String? errorMessage;
  final List<SemanticSearchResult> results;

  double get indexProgress {
    if (indexTotalCount == 0) {
      return 0;
    }
    return (indexDoneCount / indexTotalCount).clamp(0, 1);
  }

  SmartSearchState copyWith({
    String? query,
    bool? isSearching,
    bool? isReranking,
    bool? isIndexing,
    int? indexDoneCount,
    int? indexTotalCount,
    int? indexFailureCount,
    DateTime? lastIndexedAt,
    String? errorMessage,
    bool clearError = false,
    bool clearIndexFailure = false,
    List<SemanticSearchResult>? results,
  }) {
    return SmartSearchState(
      query: query ?? this.query,
      isSearching: isSearching ?? this.isSearching,
      isReranking: isReranking ?? this.isReranking,
      isIndexing: isIndexing ?? this.isIndexing,
      indexDoneCount: indexDoneCount ?? this.indexDoneCount,
      indexTotalCount: indexTotalCount ?? this.indexTotalCount,
      indexFailureCount: clearIndexFailure
          ? 0
          : indexFailureCount ?? this.indexFailureCount,
      lastIndexedAt: lastIndexedAt ?? this.lastIndexedAt,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      results: results ?? this.results,
    );
  }
}

class SemanticSearchResult {
  const SemanticSearchResult({
    required this.item,
    required this.cosineScore,
    required this.rerankScore,
  });

  final SemanticIndexEntry item;
  final double cosineScore;
  final double rerankScore;
}

class _ScoredSemanticItem {
  const _ScoredSemanticItem({required this.item, required this.score});

  final SemanticIndexEntry item;
  final double score;
}
