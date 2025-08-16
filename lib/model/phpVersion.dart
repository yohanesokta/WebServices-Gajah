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

Future<List<Phpversion>?> getDataVersion(bool stable) async {
  try {
    final Uri url = (stable)
        ? Uri.parse(
            "https://yohanesokta.github.io/WebServices-Gajah/api/php-stable.json",
          )
        : Uri.parse(
            "https://yohanesokta.github.io/WebServices-Gajah/api/php-archive.json",
          );
    var response = await http.get(url);
    if (response.statusCode != 200) {
      print("archive version get failed");
      return null;
    }
    List<dynamic> data = (jsonDecode(response.body) as List<dynamic>);
    final List<Phpversion> phpversion = data
        .map((e) => Phpversion.fromMap(e))
        .toList();
    return phpversion;
  } catch (error) {
    print(error);
    return null;
  }
}
