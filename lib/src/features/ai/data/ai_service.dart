import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../domain/ai_service_models.dart';

abstract class AiService {
  Future<AiChatResponse> sendMessage(AiChatRequest request);
}

class BackendAiService implements AiService {
  BackendAiService({
    http.Client? client,
    this.baseUrl = AppConfig.apiBaseUrl,
    this.timeout = const Duration(seconds: 45),
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final Duration timeout;

  Uri _buildUri(String path) {
    final cleanBase = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final cleanPath = path.startsWith('/') ? path : '/$path';

    if (cleanBase.isEmpty) {
      throw const AiServiceException('AI API base URL is empty');
    }

    return Uri.parse('$cleanBase$cleanPath');
  }

  @override
  Future<AiChatResponse> sendMessage(AiChatRequest request) async {
    final uri = _buildUri('/ai/chat');
    final payload = request.toBackendJson();
    final requestBody = jsonEncode(payload);

    if (kDebugMode) {
      debugPrint('AI baseUrl: $baseUrl');
      debugPrint('AI request URL: $uri');
      debugPrint('AI request body: ${_compactLog(requestBody)}');
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
      throw AiServiceException('AI request timeout: $error');
    } on http.ClientException catch (error) {
      throw AiServiceException('AI network error: $error');
    } on Object catch (error) {
      throw AiServiceException('AI request failed: $error');
    }

    final responseBody = utf8.decode(response.bodyBytes);

    if (kDebugMode) {
      debugPrint('AI status: ${response.statusCode}');
      debugPrint('AI raw response: ${_compactLog(responseBody)}');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AiServiceException(
        'Backend returned ${response.statusCode}: $responseBody',
      );
    }

    final Object decoded;
    try {
      decoded = jsonDecode(responseBody);
    } on FormatException catch (error) {
      throw AiServiceException(
        'Invalid AI JSON response: $error. Body: $responseBody',
      );
    }

    if (decoded is! Map) {
      throw AiServiceException('Invalid AI response object: $responseBody');
    }

    final reply = (decoded['reply'] ?? decoded['message'] ?? '')
        .toString()
        .trim();

    if (reply.isEmpty) {
      throw AiServiceException('AI reply is empty. Response: $responseBody');
    }

    final provider = (decoded['provider'] ?? 'backend').toString().trim();

    return AiChatResponse(
      message: reply,
      provider: provider.isEmpty ? 'backend' : provider,
    );
  }

  String _compactLog(String value) {
    const maxLength = 1600;

    if (value.length <= maxLength) {
      return value;
    }

    return '${value.substring(0, maxLength)}... [truncated ${value.length - maxLength} chars]';
  }
}

class FallbackMockAiService implements AiService {
  const FallbackMockAiService();

  @override
  Future<AiChatResponse> sendMessage(AiChatRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 260));

    final context = request.context;

    return AiChatResponse(
      message:
          'AI backend is temporarily unavailable. Today you have ${context.openTasksCount} open tasks. Choose one small step and try again later.',
      provider: 'local-fallback',
    );
  }
}

class ResilientAiService implements AiService {
  const ResilientAiService({
    required this.primary,
    this.fallback,
    this.useFallback = true,
  });

  final AiService primary;
  final AiService? fallback;
  final bool useFallback;

  @override
  Future<AiChatResponse> sendMessage(AiChatRequest request) async {
    try {
      return await primary.sendMessage(request);
    } on AiServiceException catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('AI service error: $error');
        debugPrint('AI service stackTrace: $stackTrace');
      }

      if (useFallback && fallback != null) {
        return fallback!.sendMessage(request);
      }

      rethrow;
    } on Object catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('AI unexpected error: $error');
        debugPrint('AI unexpected stackTrace: $stackTrace');
      }

      if (useFallback && fallback != null) {
        return fallback!.sendMessage(request);
      }

      throw AiServiceException.unavailable(error);
    }
  }
}

class AiServiceException implements Exception {
  const AiServiceException(this.message);

  factory AiServiceException.unavailable(Object cause) {
    return AiServiceException('AI backend unavailable: $cause');
  }

  final String message;

  @override
  String toString() => message;
}