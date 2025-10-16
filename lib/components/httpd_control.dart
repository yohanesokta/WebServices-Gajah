import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gajahweb/components/service_control_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:gajahweb/utils/process.dart';
import 'package:provider/provider.dart';
import 'package:gajahweb/utils/terminal_context.dart';

class HttpdControl extends StatefulWidget {
  const HttpdControl({super.key});

  @override
  State<HttpdControl> createState() => _HttpdControlState();
}

class _HttpdControlState extends State<HttpdControl> {
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

  void _checkHttpdStatus() async {
    if (_isManualChanging) return;
    bool httpdIsRun = await checkProcess('httpd.exe');
    if (mounted) {
      setState(() {
        status = httpdIsRun;
      });
    }
  }

  Future<void> _startHttpd(bool value) async {
    _isManualChanging = true;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String port = preferences.getString("httpdPort") ?? "8080";
    const webservicePath = "C:\\gajahweb";

    if (status) {
      await Process.run("taskkill.exe", ["/F", "/IM", "httpd.exe"]);
      sendTerminal("Menghentikan Proses [httpd.exe]\nBerhasil!");
    } else {
      await Process.start(
        "$webservicePath\\apache\\bin\\httpd.exe",
        ["-f", "$webservicePath\\apache\\conf\\httpd.conf"],
        workingDirectory: "$webservicePath\\apache",
        runInShell: false,
        mode: ProcessStartMode.detached,
      );

      sendTerminal("Memulai Httpd :$port\nBerhasil!");
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
    String port = preferences.getString("httpdPort") ?? "80";
    final Uri url = Uri.parse("http://localhost:$port");
    await launchUrl(url);
  }

  @override
  void initState() {
    super.initState();
    _checkHttpdStatus();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkHttpdStatus();
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
      serviceName: "Apache",
      statusText: status ? "Running" : "Stopped",
      statusColor: status ? Colors.green : Colors.red,
      value: status,
      onChanged: _startHttpd,
      onLaunch: status ? _launchUrl : null,
      imageAsset: "assets/httpd.png",
    );
  }
}
