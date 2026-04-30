import 'dart:math' as math;

double cosineSimilarity(List<double> a, List<double> b) {
  if (a.length != b.length || a.isEmpty) {
    return 0;
  }

  var dot = 0.0;
  var normA = 0.0;
  var normB = 0.0;

  for (var index = 0; index < a.length; index++) {
    final left = a[index];
    final right = b[index];
    dot += left * right;
    normA += left * left;
    normB += right * right;
  }

  if (normA == 0 || normB == 0) {
    return 0;
  }

  return dot / (math.sqrt(normA) * math.sqrt(normB));
}
