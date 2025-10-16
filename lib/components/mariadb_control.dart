import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    setState(() {
      _isManualChanging = true;
    });
    try {
      final mysqlPath = "C:\\gajahweb\\mariadb";
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
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String mariadbPort = preferences.getString("mariadbPort") ?? "3306";
    bool isPortInUse = !await isPortAvailable(mariadbPort);

    if (!mounted) return;

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
        mysqldProcess = false;
      }
    } else if (!mysqldProcess) {
      if (_dialogShown) {
        setState(() {
          _dialogShown = false;
        });
      }
    }

    setState(() {
      status = mysqldProcess;
    });
  }

  @override
  void initState() {
    _checkMariadbStatus();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkMariadbStatus();
    });
    super.initState();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 110, 59, 206),
                const Color.fromARGB(255, 63, 13, 129),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Image(
                image: AssetImage("assets/mariadb.png"),
                width: 60,
                height: 32,
              ),
              Text(
                "Mariadb Server",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Switch(
                value: status,
                onChanged: (value) {
                  _triggerMariaDB(value);
                },
              ),
            ],
          ),
        ),
        (status)
            ? Positioned(
                top: 5,
                right: 5,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color.fromARGB(69, 255, 255, 255),
                  ),
                  padding: EdgeInsets.all(7),
                  child: InkWell(
                    onTap: () async {
                      final SharedPreferences preferences =
                          await SharedPreferences.getInstance();
                      String port = preferences.getString("nginxPort") ?? "80";
                      final Uri url = Uri.parse(
                        "http://localhost:$port/phpmyadmin",
                      );
                      await launchUrl(url);
                    },
                    child: Icon(
                      FontAwesomeIcons.play,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
