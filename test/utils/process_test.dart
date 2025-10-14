import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/utils/process.dart';

void main() {
  group('process.dart', () {
    test('checkPort returns true for ephemeral port 0', () async {
      final ok = await checkPort('0');
      expect(ok, isTrue);
    });

    test('checkProcess returns false for non-existent process name (Windows only)', () async {
      if (!Platform.isWindows) return;
      final exists = await checkProcess('process_that_should_not_exist_12345.exe');
      expect(exists, isFalse);
    });

    test('killProcess completes and returns a boolean (Windows only)', () async {
      if (!Platform.isWindows) return;
      final killed = await killProcess('process_that_should_not_exist_12345.exe');
      expect(killed, isA<bool>());
    });

    test('startProgram completes without throwing (Windows only)', () async {
      if (!Platform.isWindows) return;
      await startProgram('cmd.exe', ['/c', 'echo', 'hello']);
    });
  });
}

