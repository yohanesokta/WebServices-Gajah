import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/components/mariadbControl.dart';

void main() {
  testWidgets('showConfirmDialog returns true when pressing Ya', (tester) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await showConfirmDialog(context, 'Test pesan');
                  },
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Dialog should be visible
    expect(find.text('Tampaknya'), findsOneWidget);

    await tester.tap(find.text('Ya'));
    await tester.pumpAndSettle();

    expect(result, isTrue);
  });

  testWidgets('showConfirmDialog returns false when pressing Tidak', (tester) async {
    bool? result;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await showConfirmDialog(context, 'Test pesan');
                  },
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Dialog should be visible
    expect(find.text('Tampaknya'), findsOneWidget);

    await tester.tap(find.text('Tidak'));
    await tester.pumpAndSettle();

    expect(result, isFalse);
  });
}

