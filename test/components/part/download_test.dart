
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/components/part/download.dart';

void main() {
  testWidgets('Download page shows a title', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Download()));

    expect(find.text('Download PHP Version'), findsOneWidget);
  });
}
