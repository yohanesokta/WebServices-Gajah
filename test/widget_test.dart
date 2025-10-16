
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/main.dart';
import 'package:provider/provider.dart';
import 'package:gajahweb/utils/terminal_context.dart';

void main() {
  testWidgets('MainApp renders correctly', (WidgetTester tester) async {
    await tester.runAsync(() async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (context) => Terminalcontext(),
          child: const MainApp(),
        ),
      );

      // Verify that our app has the correct title.
      expect(find.text('Control Panel'), findsOneWidget);
    });
  });
}
