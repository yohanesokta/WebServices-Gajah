import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/utils/terminalContext.dart';

void main() {
  test('Terminalcontext.add stores message and notifies listeners', () {
    final tc = Terminalcontext();
    var notified = false;

    tc.addListener(() {
      notified = true;
    });

    tc.add('hello');

    expect(tc.terminalContext.contains('hello'), isTrue);
    expect(notified, isTrue);
  });
}

