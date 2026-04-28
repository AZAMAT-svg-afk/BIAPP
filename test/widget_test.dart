import 'package:baraka_ai_mobile/src/app/baraka_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app shell renders onboarding', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: BarakaApp()));
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
