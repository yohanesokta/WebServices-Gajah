import "package:http/http.dart" as http;
import "dart:convert";

class Phpversion {
  final String name;
  final String url;
  final String type;

  Phpversion({required this.name, required this.url,required this.type});

  factory Phpversion.fromMap(Map<String, dynamic> data) {
    return Phpversion(name: data['name'], url: data['url'], type: data['type']);
  }
}

Future<List<Phpversion>?> getDataVersion(bool stable, {http.Client? client}) async {
  client ??= http.Client();
  try {
    final Uri url = (stable)
        ? Uri.parse(
            "https://yohanesokta.github.io/WebServices-Gajah/api/php-stable.json",
          )
        : Uri.parse(
            "https://yohanesokta.github.io/WebServices-Gajah/api/php-archive.json",
          );
    var response = await client.get(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to load php version');
    }
    List<dynamic> data = (jsonDecode(response.body) as List<dynamic>);
    final List<Phpversion> phpversion = data
        .map((e) => Phpversion.fromMap(e))
        .toList();
    return phpversion;
  } catch (error) {
    throw Exception('Failed to load php version');
  }
}
