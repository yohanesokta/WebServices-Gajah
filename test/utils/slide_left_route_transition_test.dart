
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/utils/slide_left_route.dart';

void main() {
  testWidgets('SlideLeftRoute transition is correct', (WidgetTester tester) async {
    final route = SlideLeftRoute(page: const Text('Second Page'));

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => Navigator.of(context).push(route),
            child: const Text('Go'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();

    final slideTransition = find.byType(SlideTransition);
    expect(slideTransition, findsOneWidget);

    final animation = tester.widget<SlideTransition>(slideTransition).position;
    expect(animation.value, const Offset(0, 0));
  });
}
