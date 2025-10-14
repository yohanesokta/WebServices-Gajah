import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:gajahweb/utils/process.dart';
import 'package:provider/provider.dart';
import 'package:gajahweb/utils/terminal_context.dart';

class Nginxcontrol extends StatefulWidget {
  const Nginxcontrol({super.key});

  @override
  State<Nginxcontrol> createState() => _Nginxcontrol();
}

class _Nginxcontrol extends State<Nginxcontrol> {
  bool status = false;

  Future<void> sendTerminal(String message) async {
    final terminalAdd = Provider.of<Terminalcontext>(
      context,
      listen: false,
    ).add;
    terminalAdd(message);
  }

  void _checkNginxStatus() async {
    bool nginxIsRun = await checkProcess('nginx.exe');
    setState(() {
      status = nginxIsRun;
    });
  }

  Future<void> _startNginx(bool value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String port = preferences.getString("nginxPort") ?? "80";
    final webservicePath = r'C:\gajahweb';
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
        mode: ProcessStartMode.normal,
        runInShell: false,
      );
      await Process.start(
        "$webservicePath\\php\\php-cgi.exe",
        ["-b", "127.0.0.1:9000"],
        mode: ProcessStartMode.normal,
        runInShell: false,
      );
      sendTerminal("Memulai Nginx :$port\nMemulai php-cgi.exe :9000\nBerhasil!");
    }
    setState(() {
      status = value;
    });
  }

  @override
  void initState() {
    _checkNginxStatus();
    Timer.periodic(Duration(seconds: 2), (timer) {
      _checkNginxStatus();
    });
    super.initState();
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
                const Color.fromARGB(255, 59, 69, 206),
                const Color.fromARGB(255, 32, 145, 238),
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
                image: AssetImage("assets/nginx.png"),
                width: 32,
                height: 32,
              ),
              Text(
                "Nginx Server",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Switch(
                activeThumbColor: const Color.fromARGB(255, 14, 175, 9),
                value: status,
                onChanged: (value) {
                  _startNginx(value);
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
                      final SharedPreferences preferences = await SharedPreferences.getInstance();
                      String port = preferences.getString("nginxPort") ?? "80";
                      final Uri url = Uri.parse("http://localhost:$port");
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
