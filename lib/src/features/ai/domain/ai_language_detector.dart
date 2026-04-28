enum AiDetectedLanguage {
  kazakh('kk', 'Kazakh', 'Сіз'),
  russian('ru', 'Russian', 'Вы'),
  english('en', 'English', 'You');

  const AiDetectedLanguage(this.code, this.promptName, this.neutralAddress);

  final String code;
  final String promptName;
  final String neutralAddress;
}

class AiLanguageDetector {
  const AiLanguageDetector._();

  static final RegExp _kazakhCyrillic = RegExp(r'[әіңғүұқөһӘІҢҒҮҰҚӨҺ]');
  static final RegExp _cyrillic = RegExp(r'[А-Яа-яЁёӘәІіҢңҒғҮүҰұҚқӨөҺһ]');

  static AiDetectedLanguage detect(String message) {
    if (_kazakhCyrillic.hasMatch(message)) {
      return AiDetectedLanguage.kazakh;
    }
    if (_cyrillic.hasMatch(message)) {
      return AiDetectedLanguage.russian;
    }
    return AiDetectedLanguage.english;
  }
}
