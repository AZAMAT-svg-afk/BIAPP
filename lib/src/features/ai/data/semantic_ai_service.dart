import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';

final semanticAiServiceProvider = Provider<SemanticAiService>((ref) {
  return SemanticAiService();
});

class SemanticAiService {
  SemanticAiService({
    http.Client? client,
    this.baseUrl = AppConfig.apiBaseUrl,
    this.timeout = const Duration(seconds: 45),
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final Duration timeout;

  Future<List<double>> embedText(String input) async {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return const [];
    }

    final decoded = await _postJson('/ai/embed', {'input': trimmed});
    final embedding = decoded['embedding'];
    if (embedding is! List) {
      throw const SemanticAiException('Embedding response is missing vector');
    }

    return [
      for (final value in embedding)
        if (value is num) value.toDouble(),
    ];
  }

  Future<List<RerankResult>> rerank({
    required String query,
    required List<RerankDocument> documents,
    int topK = 10,
  }) async {
    if (query.trim().isEmpty || documents.isEmpty) {
      return const [];
    }

    final decoded = await _postJson('/ai/rerank', {
      'query': query.trim(),
      'documents': documents.map((document) => document.toJson()).toList(),
      'topK': topK,
    });
    final rawResults = decoded['results'];
    if (rawResults is! List) {
      throw const SemanticAiException('Rerank response is missing results');
    }

    return [
      for (final result in rawResults)
        if (result is Map) RerankResult.fromJson(result),
    ];
  }

  Future<Map<String, Object?>> _postJson(
    String path,
    Map<String, Object?> payload,
  ) async {
    final uri = _buildUri(path);
    final requestBody = jsonEncode(payload);

    if (kDebugMode) {
      debugPrint('Semantic AI request URL: $uri');
      debugPrint('Semantic AI request body: ${_compactLog(requestBody)}');
    }

    late final http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: const {
              'Content-Type': 'application/json; charset=utf-8',
              'Accept': 'application/json',
            },
            body: utf8.encode(requestBody),
          )
          .timeout(timeout);
    } on TimeoutException catch (error) {
      throw SemanticAiException('Semantic AI request timeout: $error');
    } on http.ClientException catch (error) {
      throw SemanticAiException('Semantic AI network error: $error');
    } on Object catch (error) {
      throw SemanticAiException('Semantic AI request failed: $error');
    }

    final responseBody = utf8.decode(response.bodyBytes);
    if (kDebugMode) {
      debugPrint('Semantic AI status: ${response.statusCode}');
      debugPrint('Semantic AI raw response: ${_compactLog(responseBody)}');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw SemanticAiException(
        'Backend returned ${response.statusCode}: $responseBody',
      );
    }

    final Object decoded;
    try {
      decoded = jsonDecode(responseBody);
    } on FormatException catch (error) {
      throw SemanticAiException(
        'Invalid Semantic AI JSON response: $error. Body: $responseBody',
      );
    }

    if (decoded is! Map) {
      throw SemanticAiException(
        'Invalid Semantic AI response object: $responseBody',
      );
    }

    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }

  Uri _buildUri(String path) {
    final cleanBase = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final cleanPath = path.startsWith('/') ? path : '/$path';

    if (cleanBase.isEmpty) {
      throw const SemanticAiException('Semantic AI API base URL is empty');
    }

    return Uri.parse('$cleanBase$cleanPath');
  }

  String _compactLog(String value) {
    const maxLength = 1600;
    if (value.length <= maxLength) {
      return value;
    }
    return '${value.substring(0, maxLength)}... [truncated ${value.length - maxLength} chars]';
  }
}

class RerankDocument {
  const RerankDocument({
    required this.id,
    required this.text,
    this.metadata = const {},
  });

  final String id;
  final String text;
  final Map<String, Object?> metadata;

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'text': text,
      if (metadata.isNotEmpty) 'metadata': metadata,
    };
  }
}

class RerankResult {
  const RerankResult({
    required this.id,
    required this.text,
    required this.score,
    required this.index,
    this.metadata = const {},
  });

  factory RerankResult.fromJson(Map<dynamic, dynamic> json) {
    final metadata = json['metadata'];
    return RerankResult(
      id: (json['id'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      score: json['score'] is num ? (json['score'] as num).toDouble() : 0,
      index: json['index'] is num ? (json['index'] as num).toInt() : 0,
      metadata: metadata is Map
          ? metadata.map((key, value) => MapEntry(key.toString(), value))
          : const {},
    );
  }

  final String id;
  final String text;
  final double score;
  final int index;
  final Map<String, Object?> metadata;
}

class SemanticAiException implements Exception {
  const SemanticAiException(this.message);

  final String message;

  @override
  String toString() => message;
}
