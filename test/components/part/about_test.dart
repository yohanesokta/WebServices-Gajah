
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/components/part/about.dart';

void main() {
  testWidgets('AboutPage renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: AboutPage()));

    // Verify that our app has the correct title.
    expect(find.text('Gajah Webservice'), findsOneWidget);
  });
}
