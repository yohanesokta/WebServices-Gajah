import 'dart:io';
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
  final TextEditingController _apachePort =
      TextEditingController();
  String _htdocsPath = "C:\\gajahweb\\htdocs";
  bool onEdits = false;

  late SharedPreferences preferences;

  Future<void> _initializationVars() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      _nginxPort.text = preferences.getString("nginxPort") ?? "80";
      _mariadbPort.text = preferences.getString("mariadbPort") ?? "3306";
      _postgresqlPort.text = preferences.getString("postgresqlPort") ?? "5432";
      _htdocsPath = preferences.getString("htdocs") ?? "C:\\gajahweb\\htdocs";
      _apachePort.text = preferences.getString("apachePort") ?? "80";
    });
  }

  Future<void> _applySettings() async {
    print("Applying settings...");
    final String nginxPort = preferences.getString("nginxPort") ?? "80";
    final String mariadbPort = preferences.getString("mariadbPort") ?? "3306";
    final String postgresqlPort =
        preferences.getString("postgresqlPort") ?? "5473";
   
    if (nginxPort != _nginxPort.text) {
      if (Platform.isWindows) {
      await Process.run(
        "cmd.exe",
        ['/c', 'nginx-port.bat', _nginxPort.text, _htdocsPath],
        runInShell: true,
        workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
      );
      } else {
        await Process.run("pkexec",
        ["bash", "/opt/runtime/utils/unix/configure_nginx.sh",_htdocsPath , _nginxPort.text ],
        runInShell: true,
        workingDirectory: "/opt/runtime/utils");
      }
      await preferences.setString('nginxPort', _nginxPort.text);
    }

    if (mariadbPort != _mariadbPort.text) {
      if (Platform.isWindows) {
      await Process.run(
        "cmd.exe",
        ['/c', 'mariadb-port.bat', _mariadbPort.text],
        runInShell: true,
        workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
      );
      } else {
        await Process.run("pkexec",
        ["bash", "/opt/runtime/utils/unix/configure_mariadb.sh", _mariadbPort.text],
        runInShell: true,
        workingDirectory: "/opt/runtime/utils");
      }
      await preferences.setString("mariadbPort", _mariadbPort.text);
    }

    if (postgresqlPort != _postgresqlPort.text) {
      if (Platform.isWindows) {
      await Process.run(
        "cmd.exe",
        ["/c", "postgres-port.bat", _postgresqlPort.text],
        runInShell: true,
        workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
      );
      }
      await preferences.setString("postgresqlPort", _postgresqlPort.text);
    }


    if (_apachePort.text != preferences.getString("apachePort")) {
      if (Platform.isLinux) {
        await Process.run("pkexec",
        ["bash", "/opt/runtime/utils/unix/configure_apache.sh",_htdocsPath , _apachePort.text ],
        runInShell: true,
        workingDirectory: "/opt/runtime/utils");
      }
      await preferences.setString('apachePort', _apachePort.text);

     setState(() {
      onEdits = false;
      });
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
              backgroundColor: (onEdits) ? Colors.blue : Colors.grey,
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
            _buildDivider(),
            _buildPortSetting("Apache Port", _apachePort),
          ]),
          const SizedBox(height: 24),
          _buildSectionTitle("Configuration Files"),
          _buildGroupedContainer([
            _buildFileLink(
              "php.ini",
              "\\php\\php.ini",
              Icons.article_outlined,
              "PHP configuration file",
            ),
            _buildDivider(),
            _buildFileLink(
              "nginx.conf",
              "\\nginx\\conf\\nginx.conf",
              Icons.settings_ethernet_outlined,
              "Nginx configuration file",
            ),
            _buildDivider(),
            _buildFileLink(
              "my.ini",
              "\\mariadb\\data\\my.ini",
              Icons.storage_outlined,
              "MariaDB configuration file",
            ),
            _buildDivider(),
            _buildFileLink(
              "httpd.conf",
              "\\apache\\conf\\httpd.conf",
              Icons.settings_applications_outlined,
              "Apache configuration file",
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
              onChanged: (value) {
                setState(() {
                  onEdits = true;
                });
              },
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

  Widget _buildFileLink(String title, String path, IconData icon, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
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
