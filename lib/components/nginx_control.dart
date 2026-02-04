import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gajahweb/components/service_control_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:gajahweb/utils/process.dart';
import 'package:provider/provider.dart';
import 'package:gajahweb/utils/terminal_context.dart';

class Nginxcontrol extends StatefulWidget {
  const Nginxcontrol({super.key});

  @override
  State<Nginxcontrol> createState() => _NginxcontrolState();
}

class _NginxcontrolState extends State<Nginxcontrol>
    with WidgetsBindingObserver {
  bool status = false;
  bool _isManualChanging = false;
  Timer? _statusTimer;

  final String nameService = Platform.isWindows ? "nginx.exe" : "nginx";

  Future<void> sendTerminal(String message) async {
    final terminalAdd = Provider.of<Terminalcontext>(
      context,
      listen: false,
    ).add;
    terminalAdd(message);
  }

  void _checkNginxStatus() async {
    if (_isManualChanging) return;
    bool nginxIsRun = await checkProcess(nameService);
    if (mounted) {
      setState(() {
        status = nginxIsRun;
      });
    }
  }

  Future<void> _startNginx(bool value) async {
    _isManualChanging = true;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String port = preferences.getString("nginxPort") ?? "80";
    const webservicePath = 'C:\\gajahweb';
    if (status) {
      // Stop Nginx and PHP-CGI
      if (Platform.isWindows) {
        await Process.run(
          "$webservicePath\\nginx\\nginx.exe",
          ["-s", "stop"],
          workingDirectory: "$webservicePath\\nginx",
        );
        await Process.run("taskkill.exe", ["/F", "/IM", "nginx.exe"]);
        await Process.run("taskkill.exe", ["/F", "/IM", "php-cgi.exe"]);
      } else {
        // Stop Nginx and PHP-CGI on Linux
        await Process.run(
          "pkexec",
          ["systemctl", "stop", "nginx"],
        );
        await Process.run("pkill", ["php-cgi"]);
      }
      sendTerminal("Menghentikan Proses [nginx.exe, php-cgi.exe]\nBerhasil!");
    } else {
      if (Platform.isWindows) {
        // Start Nginx and PHP-CGI on Windows
        await Process.start(
          "$webservicePath\\nginx\\nginx.exe",
          ["-p", "$webservicePath\\nginx"],
          mode: ProcessStartMode.detached,
          runInShell: false,
        );
        await Process.start(
          "$webservicePath\\php\\php-cgi.exe",
          ["-b", "127.0.0.1:9000"],
          mode: ProcessStartMode.detached,
          runInShell: false,
        );
      } else {
        // Start Nginx and PHP-CGI on Linux
        await Process.start(
          "/opt/runtime/php-cgi.sh",
          [],
          mode: ProcessStartMode.detached,
          runInShell: false,
        );
        await Process.start(
          "pkexec",
          ["systemctl", "start", "nginx"],
          mode: ProcessStartMode.detached,
          runInShell: false,
        );
      }
      sendTerminal(
        "Memulai Nginx :$port\nMemulai php-cgi.exe :9000\nBerhasil!",
      );
    }
    if (mounted) {
      setState(() {
        status = value;
      });
    }
    Future.delayed(const Duration(seconds: 2), () {
      _isManualChanging = false;
      _checkNginxStatus();
    });
  }

  void _launchUrl() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String port = preferences.getString("nginxPort") ?? "80";
    final Uri url = Uri.parse("http://localhost:$port");
    await launchUrl(url);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkNginxStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ServiceControlCard(
      serviceName: "Nginx",
      statusText: status ? "Running" : "Stopped",
      statusColor: status ? Colors.green : Colors.red,
      value: status,
      onChanged: _startNginx,
      onLaunch: status ? _launchUrl : null,
      imageAsset: "assets/nginx.png",
    );
  }
}
