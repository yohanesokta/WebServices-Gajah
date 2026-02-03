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

class _MariadbcontrolState extends State<Mariadbcontrol> with WidgetsBindingObserver {
  bool status = false;
  bool _isManualChanging = false;
  Timer? _statusTimer;
  bool _dialogShown = false;

  final String processName = Platform.operatingSystem == "windows" ? "mysqld.exe" : "mysqld";

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
        if (Platform.isWindows) {
        killProcess(processName);
        } else {
          await Process.start(
            "pkexec",
            ["sudo","/opt/runtime/mysql/bin/mysqladmin","shutdown"],
            mode: ProcessStartMode.inheritStdio,
            workingDirectory: "/opt/runtime/mysql",
            runInShell: true,
          );
        }
        sendTerminal("Mematikan proses $processName\nBerhasil");
      } else {
        if (Platform.isWindows) {
        await Process.start(
          "$mysqlPath\\bin\\mysqld.exe",
          ["--datadir=$mysqlPath\\data", "--console"],
          mode: ProcessStartMode.detached,
          runInShell: false,
        );
        } else {
          await Process.start(
            "pkexec",
            ["sudo","-u","mysql","/opt/runtime/mysql/bin/mysqld"],
            mode: ProcessStartMode.inheritStdio,
            workingDirectory: "/opt/runtime/mysql",
            runInShell: true,
          );
        }
        sendTerminal("memulai proses ${processName}\nBerhasil");
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
      _checkMariadbStatus();
      _isManualChanging = false;
    });
  }

  void _checkMariadbStatus() async {
    print("mariadb check");
    if (_isManualChanging) return;
    
    bool mysqldProcess =  await checkProcess(processName);
    if (!mounted) return;
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
    } 
     else if (!mysqldProcess) {
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
     _checkMariadbStatus(); 
    }
  }

  final String runtimeName=  Platform.operatingSystem == "linux" ? "MySQL" : "MariaDB";
  final String assetsImage=  Platform.operatingSystem == "linux" ? "assets/logo-mysql.png" : "assets/mariadb.png";
  @override
  Widget build(BuildContext context) {
    return ServiceControlCard(
      serviceName: runtimeName,
      statusText: status ? "Running" : "Stopped",
      statusColor: status ? Colors.green : Colors.red,
      value: status,
      onChanged: _triggerMariaDB,
      onLaunch: status ? _launchPhpMyAdmin : null,
      imageAsset: assetsImage,
    );
  }

}