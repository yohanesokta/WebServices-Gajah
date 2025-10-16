import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/components/information.dart';
import 'package:gajahweb/utils/terminal_context.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Information widget shows a ListView', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => Terminalcontext(),
        child: const MaterialApp(home: Information()),
      ),
    );

    expect(find.byType(ListView), findsOneWidget);
  });
}