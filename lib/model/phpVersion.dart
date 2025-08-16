import "package:http/http.dart" as http;
import "dart:convert";

class Phpversion {
  final String name;
  final String url;

  Phpversion({required this.name, required this.url});

  factory Phpversion.fromMap(Map<String, dynamic> data) {
    return Phpversion(name: data['name'], url: data['url']);
  }
}

Future<List<Phpversion>?> getDataVersion() async {
  try {
    var response = await http.get(
      Uri.parse("http://localhost:8080/api/php-archive.json"),
    );
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
