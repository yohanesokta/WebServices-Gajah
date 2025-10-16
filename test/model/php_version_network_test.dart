
import 'package:flutter_test/flutter_test.dart';
import 'package:gajahweb/model/php_version.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'php_version_network_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('getDataVersion', () {
    test('returns a list of Phpversion if the http call completes successfully', () async {
      final client = MockClient();

      when(client.get(Uri.parse('https://yohanesokta.github.io/WebServices-Gajah/api/php-stable.json')))
          .thenAnswer((_) async => http.Response('[{"name":"PHP 8.3.0","url":"https://example.com","type":"zip"}]', 200));

      expect(await getDataVersion(true, client: client), isA<List<Phpversion>>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      when(client.get(Uri.parse('https://gajah.yohanesokta.com/api/php-stable.json')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(getDataVersion(true, client: client), throwsException);
    });
  });
}
