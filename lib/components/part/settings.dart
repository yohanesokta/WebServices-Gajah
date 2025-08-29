import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gajahweb/utils/process.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TextEditingController _nginxPort = TextEditingController();
  final TextEditingController _mariadbPort = TextEditingController();
  final TextEditingController _postgresqlPort = TextEditingController();
  String _htdocsPath = "C:\\gajahweb\\htdocs";

  late SharedPreferences preferences;

  Future<void> _initializationVars() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _nginxPort.text = preferences.getString("nginxPort") ?? "80";
      _mariadbPort.text = preferences.getString("mariadbPort") ?? "3306";
      _postgresqlPort.text = preferences.getString("postgresqlPort") ?? "5432";
      _htdocsPath = preferences.getString("htdocs") ?? "C:\\gajahweb\\htdocs";
    });
  }

  Future<void> _applySettings() async {
    final String nginxPort = preferences.getString("nginxPort") ?? "80";
    final String mariadbPort = preferences.getString("mariadbPort") ?? "3306";
    final String postgresqlPort =
        preferences.getString("postgresqlPort") ?? "5473";

    if (nginxPort != _nginxPort.text) {
      await Process.start(
        "cmd.exe",
        ['/c', 'nginx-port.bat', _nginxPort.text, _htdocsPath],
        runInShell: true,
        mode: ProcessStartMode.detached,
        workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
      );
      killProcess('nginx.exe');
      await preferences.setString('nginxPort', _nginxPort.text);
    }

    if (mariadbPort != _mariadbPort.text) {
      await Process.start(
        "cmd.exe",
        ['/c', 'mariadb-port.bat', _mariadbPort.text],
        runInShell: true,
        mode: ProcessStartMode.detached,
        workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
      );
      killProcess('mysqld.exe');
      await preferences.setString("mariadbPort", _mariadbPort.text);
    }

    if (postgresqlPort != _postgresqlPort.text) {
      await Process.start(
        "cmd.exe",
        ["/c", "postgres-port.bat", _postgresqlPort.text],
        mode: ProcessStartMode.detached,
        runInShell: true,
        workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
      );

      killProcess('postgres.exe');
      await preferences.setString("postgresqlPort", _postgresqlPort.text);
    }
  }

  Future<void> _openFilesNotepad(String filePath) async {
    await Process.start(
      "notepad.exe",
      ["C:\\gajahweb\\$filePath"],
      mode: ProcessStartMode.detached,
      runInShell: false,
    );
  }

  @override
  void initState() {
    _initializationVars();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text("Settings"),
            Spacer(),
            TextButton(
              onPressed: () {
                _applySettings();
              },
              child: Text(
                "Apply",
                style: TextStyle(
                  color: const Color.fromARGB(255, 197, 197, 197),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 20,
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
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 187, 187, 187),
                        ),
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
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 187, 187, 187),
                        ),
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
                        labelStyle: TextStyle(
                          color: const Color.fromARGB(255, 187, 187, 187),
                        ),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              ],
            ),

            Row(
              spacing: 10,
              children: [
                InkWell(
                  onTap: () {
                    _openFilesNotepad("\\php\\php.ini");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 51, 51, 51),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.file_open, color: Colors.amber),
                        Text("php.ini", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _openFilesNotepad("\\nginx\\conf\\nginx.conf");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 51, 51, 51),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.file_open, color: Colors.amber),
                        Text(
                          "nginx.conf",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _openFilesNotepad("\\mariadb\\data\\my.ini");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 51, 51, 51),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.file_open, color: Colors.amber),
                        Text("my.ini", style: TextStyle(color: Colors.white)),
                      ],
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
