import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/model/php_version.dart';

void main() {
  test('Phpversion.fromMap maps values correctly', () {
    final m = {'name': 'PHP 8.3.0', 'url': 'https://example.com', 'type': 'zip'};
    final v = Phpversion.fromMap(m);
    expect(v.name, 'PHP 8.3.0');
    expect(v.url, 'https://example.com');
    expect(v.type, 'zip');
  });

  test('getDataVersion requires network (skipped by default)', () async {
    // This test is intentionally skipped to avoid network dependence in unit tests.
  }, skip: true);
}

