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
      await Process.run(
        "cmd.exe",
        ['/c', 'nginx-port.bat', _nginxPort.text, _htdocsPath],
        runInShell: true,
        workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
      );
      await preferences.setString('nginxPort', _nginxPort.text);
    }

    if (mariadbPort != _mariadbPort.text) {
      await Process.run(
        "cmd.exe",
        ['/c', 'mariadb-port.bat', _mariadbPort.text],
        runInShell: true,
        workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
      );
      await preferences.setString("mariadbPort", _mariadbPort.text);
    }

    if (postgresqlPort != _postgresqlPort.text) {
      await Process.run(
        "cmd.exe",
        ["/c", "postgres-port.bat", _postgresqlPort.text],
        runInShell: true,
        workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
      );
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
      backgroundColor: const Color(0xFF1C1C1E),
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C1C1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _applySettings,
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Apply",
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionTitle("Ports"),
          _buildGroupedContainer([
            _buildPortSetting("Nginx Port", _nginxPort),
            _buildDivider(),
            _buildPortSetting("MariaDB Port", _mariadbPort),
            _buildDivider(),
            _buildPortSetting("PostgreSQL Port", _postgresqlPort),
          ]),
          const SizedBox(height: 24),
          _buildSectionTitle("Configuration Files"),
          _buildGroupedContainer([
            _buildFileLink(
              "php.ini",
              "\\php\\php.ini",
              Icons.article_outlined,
            ),
            _buildDivider(),
            _buildFileLink(
              "nginx.conf",
              "\\nginx\\conf\\nginx.conf",
              Icons.settings_ethernet_outlined,
            ),
            _buildDivider(),
            _buildFileLink(
              "my.ini",
              "\\mariadb\\data\\my.ini",
              Icons.storage_outlined,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildGroupedContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildPortSetting(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 16, color: Colors.white))),
          SizedBox(
            width: 80,
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileLink(String title, String path, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () => _openFilesNotepad(path),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      indent: 16,
      endIndent: 0,
      color: Color(0xFF38383A),
    );
  }
}
