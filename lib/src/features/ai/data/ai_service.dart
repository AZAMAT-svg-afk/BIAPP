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
    this.timeout = const Duration(seconds: 30),
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;
  final Duration timeout;

  Uri _buildUri(String path) {
    final cleanBase = baseUrl.trim().replaceAll(RegExp(r'/+$'), '');
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('$cleanBase$cleanPath');
  }

  @override
  Future<AiChatResponse> sendMessage(AiChatRequest request) async {
    final uri = _buildUri('/ai/chat');

    if (kDebugMode) {
      debugPrint('AI baseUrl: $baseUrl');
      debugPrint('AI request URL: $uri');
      debugPrint('AI request body: ${jsonEncode(request.toBackendJson())}');
    }

    final response = await _client
        .post(
          uri,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(request.toBackendJson()),
        )
        .timeout(timeout);

    final body = utf8.decode(response.bodyBytes);

    if (kDebugMode) {
      debugPrint('AI status: ${response.statusCode}');
      debugPrint('AI raw response: $body');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AiServiceException(
        'Backend returned ${response.statusCode}: $body',
      );
    }

    final decoded = jsonDecode(body);

    if (decoded is! Map) {
      throw AiServiceException('Invalid AI response: $body');
    }

    final reply = (decoded['reply'] ?? decoded['message'] ?? '')
        .toString()
        .trim();

    if (reply.isEmpty) {
      throw AiServiceException('AI reply is empty. Response: $body');
    }

    return AiChatResponse(
      message: reply,
      provider: (decoded['provider'] ?? 'backend').toString(),
    );
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
          'AI backend is unavailable. Today you have ${context.openTasksCount} open tasks. Do one small step and try again later.',
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
    } on Object catch (error, stackTrace) {
      if (kDebugMode) {
        debugPrint('AI service error: $error');
        debugPrint('AI service stackTrace: $stackTrace');
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
