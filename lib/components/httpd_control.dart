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

class _HttpdControlState extends State<HttpdControl>
    with WidgetsBindingObserver {
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
    print("httpd check");
    String prosessName = (Platform.operatingSystem == "linux")
        ? "httpd"
        : "httpd.exe";

    if (_isManualChanging) return;
    bool httpdIsRun = await checkProcess(prosessName);
    if (mounted) {
      setState(() {
        status = httpdIsRun;
        print("httpd status: $status");
      });
    }
  }

  Future<void> _startHttpd(bool value) async {
    _isManualChanging = true;
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String port = preferences.getString("httpdPort") ?? "8080";
    const webservicePath = "C:\\gajahweb";

    if (status) {
      if (Platform.operatingSystem == "linux") {
        await Process.run("pkexec", ["pkill", "httpd"]);
      } else {
        await Process.run("taskkill.exe", ["/F", "/IM", "httpd.exe"]);
      }
      sendTerminal("Menghentikan Proses [httpd.exe]\nBerhasil!");
    } else {
      if (Platform.operatingSystem == "linux") {
        await Process.run("pkexec", [
          "/opt/runtime/start.sh",
        ], runInShell: true);
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
    }
    if (mounted) {
      setState(() {
        status = value;
      });
    }

    Future.delayed(const Duration(seconds: 2), () {
      _isManualChanging = false;
      _checkHttpdStatus();
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkHttpdStatus();
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
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
