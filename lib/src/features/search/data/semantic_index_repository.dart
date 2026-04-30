import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';

final semanticIndexRepositoryProvider = Provider<SemanticIndexRepository>(
  (ref) => SemanticIndexRepository(ref.watch(appDatabaseProvider)),
);

class SemanticIndexRepository {
  SemanticIndexRepository(this._database);

  final AppDatabase _database;

  Future<void> upsertSemanticItem(SemanticIndexEntry item) {
    return _database
        .into(_database.semanticIndexItems)
        .insertOnConflictUpdate(_toCompanion(item));
  }

  Future<void> deleteSemanticItem(String id) {
    return (_database.delete(
      _database.semanticIndexItems,
    )..where((row) => row.id.equals(id))).go();
  }

  Future<void> deleteSemanticItemBySource({
    required String sourceType,
    required String sourceId,
  }) {
    return (_database.delete(_database.semanticIndexItems)..where(
          (row) =>
              row.sourceType.equals(sourceType) & row.sourceId.equals(sourceId),
        ))
        .go();
  }

  Future<List<SemanticIndexEntry>> listSemanticItems() async {
    final records = await (_database.select(
      _database.semanticIndexItems,
    )..orderBy([(item) => OrderingTerm.desc(item.updatedAt)])).get();
    return records.map(_fromRecord).toList();
  }

  Future<SemanticIndexEntry?> getSemanticItem(String id) async {
    final record = await (_database.select(
      _database.semanticIndexItems,
    )..where((row) => row.id.equals(id))).getSingleOrNull();
    if (record == null) {
      return null;
    }
    return _fromRecord(record);
  }

  Future<void> clearSemanticIndex() {
    return _database.delete(_database.semanticIndexItems).go();
  }

  SemanticIndexItemsCompanion _toCompanion(SemanticIndexEntry item) {
    return SemanticIndexItemsCompanion(
      id: Value(item.id),
      sourceType: Value(item.sourceType.name),
      sourceId: Value(item.sourceId),
      title: Value(item.title),
      content: Value(item.content),
      embeddingJson: Value(jsonEncode(item.embedding)),
      updatedAt: Value(item.updatedAt),
    );
  }

  SemanticIndexEntry _fromRecord(SemanticIndexItem record) {
    return SemanticIndexEntry(
      id: record.id,
      sourceType: SemanticSourceType.byName(record.sourceType),
      sourceId: record.sourceId,
      title: record.title,
      content: record.content,
      embedding: _decodeEmbedding(record.embeddingJson),
      updatedAt: record.updatedAt,
    );
  }

  List<double> _decodeEmbedding(String value) {
    final Object decoded;
    try {
      decoded = jsonDecode(value);
    } on FormatException {
      return const [];
    }

    if (decoded is! List) {
      return const [];
    }

    return [
      for (final item in decoded)
        if (item is num) item.toDouble(),
    ];
  }
}

enum SemanticSourceType {
  note,
  task,
  habit;

  static SemanticSourceType byName(String value) {
    return SemanticSourceType.values.firstWhere(
      (type) => type.name == value,
      orElse: () => SemanticSourceType.note,
    );
  }
}

class SemanticIndexEntry {
  const SemanticIndexEntry({
    required this.id,
    required this.sourceType,
    required this.sourceId,
    required this.title,
    required this.content,
    required this.embedding,
    required this.updatedAt,
  });

  factory SemanticIndexEntry.source({
    required SemanticSourceType sourceType,
    required String sourceId,
    required String title,
    required String content,
    required DateTime updatedAt,
    List<double> embedding = const [],
  }) {
    return SemanticIndexEntry(
      id: '${sourceType.name}-$sourceId',
      sourceType: sourceType,
      sourceId: sourceId,
      title: title,
      content: content,
      embedding: embedding,
      updatedAt: updatedAt,
    );
  }

  final String id;
  final SemanticSourceType sourceType;
  final String sourceId;
  final String title;
  final String content;
  final List<double> embedding;
  final DateTime updatedAt;

  String get searchText {
    final parts = [
      title.trim(),
      content.trim(),
    ].where((part) => part.isNotEmpty).toList();
    return parts.join('\n');
  }

  SemanticIndexEntry copyWith({
    String? title,
    String? content,
    List<double>? embedding,
    DateTime? updatedAt,
  }) {
    return SemanticIndexEntry(
      id: id,
      sourceType: sourceType,
      sourceId: sourceId,
      title: title ?? this.title,
      content: content ?? this.content,
      embedding: embedding ?? this.embedding,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
