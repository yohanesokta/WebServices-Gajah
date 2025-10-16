import 'dart:async';
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

class _NginxcontrolState extends State<Nginxcontrol> {
  bool status = false;
  bool _isManualChanging = false;
  Timer? _statusTimer;

  Future<void> sendTerminal(String message) async {
    final terminalAdd = Provider.of<Terminalcontext>(
      context,
      listen: false,
    ).add;
    terminalAdd(message);
  }

  void _checkNginxStatus() async {
    if (_isManualChanging) return;
    bool nginxIsRun = await checkProcess('nginx.exe');
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
      await Process.run(
        "$webservicePath\\nginx\\nginx.exe",
        ["-s", "stop"],
        workingDirectory: "$webservicePath\\nginx",
      );
      await Process.run("taskkill.exe", ["/F", "/IM", "nginx.exe"]);
      await Process.run("taskkill.exe", ["/F", "/IM", "php-cgi.exe"]);
      sendTerminal("Menghentikan Proses [nginx.exe, php-cgi.exe]\nBerhasil!");
    } else {
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
      sendTerminal("Memulai Nginx :$port\nMemulai php-cgi.exe :9000\nBerhasil!");
    }
    if (mounted) {
      setState(() {
        status = value;
      });
    }
    Future.delayed(const Duration(seconds: 2), () {
      _isManualChanging = false;
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
    _checkNginxStatus();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkNginxStatus();
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
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
