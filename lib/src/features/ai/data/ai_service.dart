import 'dart:async';
import 'dart:convert';
import 'dart:io';

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

  @override
  Future<AiChatResponse> sendMessage(AiChatRequest request) async {
    final uri = Uri.parse('$baseUrl/ai/chat');
    final response = await _client
        .post(
          uri,
          headers: const {'Content-Type': 'application/json'},
          body: jsonEncode(request.toBackendJson()),
        )
        .timeout(timeout);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AiServiceException('Backend returned ${response.statusCode}');
    }

    final decoded = jsonDecode(utf8.decode(response.bodyBytes));
    if (decoded is! Map<String, Object?>) {
      throw const AiServiceException('Invalid AI response');
    }

    final reply = decoded['reply'] ?? decoded['message'];
    if (reply is! String || reply.trim().isEmpty) {
      throw const AiServiceException('AI reply is empty');
    }

    return AiChatResponse(
      message: reply,
      provider: decoded['provider'] as String? ?? 'backend',
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
    this.useFallback = false,
  });

  final AiService primary;
  final AiService? fallback;
  final bool useFallback;

  @override
  Future<AiChatResponse> sendMessage(AiChatRequest request) async {
    try {
      return await primary.sendMessage(request);
    } on SocketException catch (error) {
      return _handleFailure(error, request);
    } on TimeoutException catch (error) {
      return _handleFailure(error, request);
    } on http.ClientException catch (error) {
      return _handleFailure(error, request);
    }
  }

  Future<AiChatResponse> _handleFailure(Object error, AiChatRequest request) {
    if (useFallback && fallback != null) {
      return fallback!.sendMessage(request);
    }
    throw AiServiceException.unavailable(error);
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
