import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
    setState(() {
      status = httpdIsRun;
    });
  }

  Future<void> _startHttpd(bool value) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String port = preferences.getString("httpdPort") ?? "8080";
    final webservicePath = "C:\\gajahweb";

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

    Future.delayed(Duration(seconds: 2), () {
      _isManualChanging = false;
    });
  }

  @override
  void initState() {
    _checkHttpdStatus();
    _statusTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      _checkHttpdStatus();
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
                const Color.fromARGB(255, 206, 69, 59),
                const Color.fromARGB(255, 238, 145, 32),
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
                image: AssetImage("assets/httpd.png"),
                width: 32,
                height: 32,
              ),
              Text(
                "Apache Server",
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
                  _startHttpd(value);
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
                      String port =
                          preferences.getString("httpdPort") ?? "80";
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
