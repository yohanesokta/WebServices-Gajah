import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _nginxPort = TextEditingController();
  final TextEditingController _mariadbPort = TextEditingController();
  final TextEditingController _postgresqlPort = TextEditingController();

  late SharedPreferences preferences;

  Future<void> _initializationVars() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _nginxPort.text = preferences.getString("nginxPort") ?? "80";
      _mariadbPort.text = preferences.getString("mariadbPort") ?? "3306";
      _postgresqlPort.text = preferences.getString("postgresqlPort") ?? "5473";

    });
  } 

  @override
  void initState() {
    _initializationVars();
    super.initState();
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(children: [
        Text("Settings"),
        Spacer(),
        TextButton(onPressed: () {}, child: Text("Apply" ,style: TextStyle(color: const Color.fromARGB(255, 197, 197, 197)),))
      ],)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              spacing: 10,
              children: [
                Container(
                  child: Expanded(
                    child: TextField(
                      controller: _nginxPort,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Nginx Port",
                        border: OutlineInputBorder(),
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 187, 187, 187)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
                    child: TextField(
                      controller: _mariadbPort,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Mariadb Port",
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 187, 187, 187)),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Container(
                  child: Expanded(
                    child: TextField(
                      controller: _postgresqlPort,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "PostgreSQL Port",
                        labelStyle: TextStyle(color: const Color.fromARGB(255, 187, 187, 187)),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
