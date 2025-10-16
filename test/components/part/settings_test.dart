
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/components/part/settings.dart';

void main() {
  testWidgets('Settings page shows a title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Settings()));

    expect(find.text('Settings'), findsOneWidget);
  });
}
