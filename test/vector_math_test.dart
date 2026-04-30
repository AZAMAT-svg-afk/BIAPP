import 'package:baraka_ai_mobile/src/features/search/domain/vector_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cosineSimilarity handles matching vectors', () {
    expect(cosineSimilarity([1, 0], [1, 0]), closeTo(1, 0.0001));
    expect(cosineSimilarity([1, 0], [0, 1]), closeTo(0, 0.0001));
  });

  test('cosineSimilarity returns zero for unsafe inputs', () {
    expect(cosineSimilarity([1, 2], [1]), 0);
    expect(cosineSimilarity([0, 0], [1, 2]), 0);
    expect(cosineSimilarity(const [], const []), 0);
  });
}
