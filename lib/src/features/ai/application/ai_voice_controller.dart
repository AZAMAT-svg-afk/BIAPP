import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../settings/application/settings_controller.dart';
import '../../settings/domain/user_settings.dart';

final aiVoiceControllerProvider =
    NotifierProvider<AiVoiceController, AiVoiceState>(AiVoiceController.new);

enum AiVoiceError {
  microphonePermissionRequired,
  speechRecognitionUnavailable,
  voiceLanguageUnavailable,
  ttsUnavailable,
  noSpeechDetected,
}

class AiVoiceState {
  const AiVoiceState({
    this.isListening = false,
    this.isSpeaking = false,
    this.recognizedText = '',
    this.error,
  });

  final bool isListening;
  final bool isSpeaking;
  final String recognizedText;
  final AiVoiceError? error;

  AiVoiceState copyWith({
    bool? isListening,
    bool? isSpeaking,
    String? recognizedText,
    AiVoiceError? error,
    bool clearError = false,
  }) {
    return AiVoiceState(
      isListening: isListening ?? this.isListening,
      isSpeaking: isSpeaking ?? this.isSpeaking,
      recognizedText: recognizedText ?? this.recognizedText,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class AiVoiceController extends Notifier<AiVoiceState> {
  SpeechToText? _speech;
  FlutterTts? _tts;
  bool _speechInitialized = false;
  bool _ttsInitialized = false;

  @override
  AiVoiceState build() {
    ref.onDispose(() {
      final speech = _speech;
      if (speech != null && _speechInitialized) {
        unawaited(speech.cancel());
      }
      final tts = _tts;
      if (tts != null && _ttsInitialized) {
        unawaited(tts.stop());
      }
    });
    return const AiVoiceState();
  }

  Future<void> toggleListening(AppLanguage language) async {
    if (state.isListening) {
      await stopListening();
      return;
    }
    await startListening(language);
  }

  Future<void> startListening(AppLanguage language) async {
    final settings = ref.read(settingsControllerProvider);
    if (!settings.voice.voiceInputEnabled) {
      return;
    }

    state = state.copyWith(recognizedText: '', clearError: true);
    final speech = await _ensureSpeech();
    if (speech == null) {
      return;
    }

    final localeId = await _speechLocaleFor(language, speech);
    try {
      state = state.copyWith(isListening: true, clearError: true);
      await speech.listen(
        localeId: localeId,
        listenFor: const Duration(seconds: 40),
        pauseFor: const Duration(seconds: 3),
        listenOptions: SpeechListenOptions(
          cancelOnError: true,
          partialResults: true,
          listenMode: ListenMode.dictation,
        ),
        onResult: (result) {
          final words = result.recognizedWords.trim();
          if (words.isEmpty) {
            return;
          }
          state = state.copyWith(recognizedText: words, clearError: true);
        },
      );
    } on Object {
      state = state.copyWith(
        isListening: false,
        error: AiVoiceError.speechRecognitionUnavailable,
      );
    }
  }

  Future<void> stopListening() async {
    final speech = _speech;
    if (speech == null || !_speechInitialized) {
      state = state.copyWith(isListening: false);
      return;
    }
    await speech.stop();
    state = state.copyWith(isListening: false);
    _handleNoSpeechIfNeeded();
  }

  Future<void> speak(String text, AppLanguage language) async {
    final trimmed = text.trim();
    final settings = ref.read(settingsControllerProvider).voice;
    if (trimmed.isEmpty || !settings.voiceReplyEnabled) {
      return;
    }

    await stopSpeaking();
    final tts = await _ensureTts();
    if (tts == null) {
      return;
    }

    final languageAvailable = await _applyTtsLanguage(tts, language);
    try {
      await tts.setSpeechRate(settings.rate.clamp(0.2, 0.9).toDouble());
      await tts.setPitch(settings.pitch.clamp(0.5, 1.5).toDouble());
      state = state.copyWith(
        isSpeaking: true,
        error: languageAvailable ? null : AiVoiceError.voiceLanguageUnavailable,
        clearError: languageAvailable,
      );
      await tts.speak(trimmed);
    } on Object {
      state = state.copyWith(
        isSpeaking: false,
        error: AiVoiceError.ttsUnavailable,
      );
    }
  }

  Future<void> stopSpeaking() async {
    final tts = _tts;
    if (tts == null || !_ttsInitialized) {
      state = state.copyWith(isSpeaking: false);
      return;
    }
    await tts.stop();
    state = state.copyWith(isSpeaking: false);
  }

  Future<void> stopAll() async {
    await Future.wait([stopListening(), stopSpeaking()]);
  }

  Future<SpeechToText?> _ensureSpeech() async {
    if (_speechInitialized && _speech != null) {
      return _speech;
    }
    final speech = SpeechToText();
    final available = await speech.initialize(
      onError: _onSpeechError,
      onStatus: _onSpeechStatus,
    );
    if (!available) {
      state = state.copyWith(
        isListening: false,
        error: AiVoiceError.speechRecognitionUnavailable,
      );
      return null;
    }
    _speech = speech;
    _speechInitialized = true;
    return speech;
  }

  Future<FlutterTts?> _ensureTts() async {
    if (_ttsInitialized && _tts != null) {
      return _tts;
    }
    try {
      final tts = FlutterTts();
      tts
        ..setStartHandler(() {
          state = state.copyWith(isSpeaking: true, clearError: true);
        })
        ..setCompletionHandler(() {
          state = state.copyWith(isSpeaking: false);
        })
        ..setCancelHandler(() {
          state = state.copyWith(isSpeaking: false);
        })
        ..setErrorHandler((_) {
          state = state.copyWith(
            isSpeaking: false,
            error: AiVoiceError.ttsUnavailable,
          );
        });
      await tts.awaitSpeakCompletion(false);
      _tts = tts;
      _ttsInitialized = true;
      return tts;
    } on Object {
      state = state.copyWith(error: AiVoiceError.ttsUnavailable);
      return null;
    }
  }

  void _onSpeechStatus(String status) {
    if (status == SpeechToText.notListeningStatus ||
        status == SpeechToText.doneStatus) {
      state = state.copyWith(isListening: false);
      _handleNoSpeechIfNeeded();
    }
  }

  void _onSpeechError(SpeechRecognitionError error) {
    final normalized = error.errorMsg.toLowerCase();
    final voiceError = normalized.contains('permission')
        ? AiVoiceError.microphonePermissionRequired
        : normalized.contains('language')
        ? AiVoiceError.voiceLanguageUnavailable
        : normalized.contains('no_match') ||
              normalized.contains('speech_timeout')
        ? AiVoiceError.noSpeechDetected
        : AiVoiceError.speechRecognitionUnavailable;

    state = state.copyWith(isListening: false, error: voiceError);
  }

  void _handleNoSpeechIfNeeded() {
    if (state.recognizedText.trim().isEmpty) {
      state = state.copyWith(error: AiVoiceError.noSpeechDetected);
    }
  }

  Future<String?> _speechLocaleFor(
    AppLanguage language,
    SpeechToText speech,
  ) async {
    final preferred = _preferredLocale(language);
    try {
      final locales = await speech.locales();
      final exact = locales.where((locale) => locale.localeId == preferred);
      if (exact.isNotEmpty) {
        return exact.first.localeId;
      }
      final languageOnly = locales.where(
        (locale) => locale.localeId.toLowerCase().startsWith(language.code),
      );
      if (languageOnly.isNotEmpty) {
        return languageOnly.first.localeId;
      }
      final russian = locales.where((locale) => locale.localeId == 'ru_RU');
      if (russian.isNotEmpty) {
        state = state.copyWith(error: AiVoiceError.voiceLanguageUnavailable);
        return russian.first.localeId;
      }
      final system = await speech.systemLocale();
      state = state.copyWith(error: AiVoiceError.voiceLanguageUnavailable);
      return system?.localeId;
    } on Object {
      return preferred;
    }
  }

  Future<bool> _applyTtsLanguage(FlutterTts tts, AppLanguage language) async {
    final preferred = _preferredLocale(language);
    try {
      final rawLanguages = await tts.getLanguages;
      final languages = rawLanguages is Iterable
          ? rawLanguages.map((value) => value.toString()).toList()
          : <String>[];
      final chosen = _chooseLanguage(preferred, languages);
      if (chosen == null) {
        await tts.setLanguage(preferred);
        return true;
      }
      await tts.setLanguage(chosen.language);
      return chosen.isPreferred;
    } on Object {
      await tts.setLanguage(preferred);
      return true;
    }
  }

  _ChosenTtsLanguage? _chooseLanguage(
    String preferred,
    List<String> languages,
  ) {
    if (languages.isEmpty) {
      return null;
    }
    final normalized = {
      for (final language in languages) language.toLowerCase(): language,
    };
    final exact = normalized[preferred.toLowerCase()];
    if (exact != null) {
      return _ChosenTtsLanguage(exact, true);
    }

    final preferredLanguage = preferred.split('_').first.toLowerCase();
    for (final entry in normalized.entries) {
      if (entry.key.startsWith(preferredLanguage)) {
        return _ChosenTtsLanguage(entry.value, true);
      }
    }
    final ru = normalized['ru_ru'] ?? normalized['ru-ru'];
    if (ru != null) {
      return _ChosenTtsLanguage(ru, false);
    }
    final en = normalized['en_us'] ?? normalized['en-us'];
    if (en != null) {
      return _ChosenTtsLanguage(en, false);
    }
    return _ChosenTtsLanguage(languages.first, false);
  }

  String _preferredLocale(AppLanguage language) {
    return switch (language) {
      AppLanguage.ru => 'ru_RU',
      AppLanguage.kk => 'kk_KZ',
      AppLanguage.en => 'en_US',
    };
  }
}

class _ChosenTtsLanguage {
  const _ChosenTtsLanguage(this.language, this.isPreferred);

  final String language;
  final bool isPreferred;
}
