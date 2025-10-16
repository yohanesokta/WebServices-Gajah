import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gajahweb/components/service_control_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gajahweb/utils/terminal_context.dart';
import '../utils/process.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:gajahweb/components/part/notification.dart';

class Mariadbcontrol extends StatefulWidget {
  const Mariadbcontrol({super.key});

  @override
  State<Mariadbcontrol> createState() => _MariadbcontrolState();
}

class _MariadbcontrolState extends State<Mariadbcontrol> {
  bool status = false;
  bool _isManualChanging = false;
  Timer? _statusTimer;
  bool _dialogShown = false;

  Future<void> sendTerminal(String message) async {
    final terminalAdd = Provider.of<Terminalcontext>(
      context,
      listen: false,
    ).add;
    terminalAdd(message);
  }

  Future<void> _triggerMariaDB(bool value) async {
    _isManualChanging = true;
    try {
      const mysqlPath = "C:\\gajahweb\\mariadb";
      if (status) {
        killProcess('mysqld.exe');
        sendTerminal("Mematikan proses mysqld.exe\nBerhasil");
      } else {
        await Process.start(
          "$mysqlPath\\bin\\mysqld.exe",
          ["--datadir=$mysqlPath\\data", "--console"],
          mode: ProcessStartMode.detached,
          runInShell: false,
        );
        sendTerminal("memulai proses mysqld.exe\nBerhasil");
      }
    } catch (error) {
      // print(e);
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

  void _checkMariadbStatus() async {
    if (_isManualChanging) return;

    bool mysqldProcess = await checkProcess('mysqld.exe');
    if (!mounted) return; // Early exit if not mounted

    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String mariadbPort = preferences.getString("mariadbPort") ?? "3306";
    bool isPortInUse = !await isPortAvailable(mariadbPort);

    if (isPortInUse && !mysqldProcess) {
      if (!_dialogShown) {
        setState(() {
          _dialogShown = true;
        });
        await showConfirmDialog(
          context,
          "Peringatan: Port $mariadbPort sedang digunakan oleh aplikasi lain. Harap matikan aplikasi tersebut.",
        );
      }
    } else if (!isPortInUse && mysqldProcess) {
      if (!_dialogShown) {
        setState(() {
          _dialogShown = true;
        });
        await showConfirmDialog(
          context,
          "Peringatan: Proses mysqld.exe berjalan tetapi tidak menggunakan port $mariadbPort. Proses akan dihentikan.",
        );
        await killProcess("mysqld.exe");
        mysqldProcess = false; // Update status after killing
      }
    } else if (!mysqldProcess) {
      if (_dialogShown) {
        if (mounted) {
          setState(() {
            _dialogShown = false;
          });
        }
      }
    }

    if (mounted) {
      setState(() {
        status = mysqldProcess;
      });
    }
  }

  void _launchPhpMyAdmin() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String port = preferences.getString("nginxPort") ?? "80";
    final Uri url = Uri.parse(
      "http://localhost:$port/phpmyadmin",
    );
    await launchUrl(url);
  }

  @override
  void initState() {
    super.initState();
    _checkMariadbStatus();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkMariadbStatus();
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
      serviceName: "MariaDB",
      statusText: status ? "Running" : "Stopped",
      statusColor: status ? Colors.green : Colors.red,
      value: status,
      onChanged: _triggerMariaDB,
      onLaunch: status ? _launchPhpMyAdmin : null,
      imageAsset: "assets/mariadb.png",
    );
  }
}
