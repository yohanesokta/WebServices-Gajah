import 'package:flutter/material.dart';
import 'dart:io';

import 'package:xampp_clone/utils/process.dart';

class Nginxcontrol extends StatefulWidget {
  const Nginxcontrol({super.key});

  @override
  State<Nginxcontrol> createState() => _Nginxcontrol();
}

class _Nginxcontrol extends State<Nginxcontrol> {
  bool status = false;

  void _checkNginxStatus() async {
    final bool nginxIsRun = await checkProcess('nginx.exe');
    if (nginxIsRun) {
      setState(() {
        status = true;
      });
    }
  }

  Future<void> _startNginx(bool value) async {
    final webservicePath = r'C:\webservices';
    if (status) {
      await Process.run("$webservicePath\\nginx\\nginx.exe", ["-s","stop"], workingDirectory: "$webservicePath\\nginx");
      await Process.run("taskkill.exe", ["/F","/IM","php-cgi.exe"]);
    } else {
      await Process.start("$webservicePath\\nginx\\nginx.exe", ["-p","$webservicePath\\nginx"], mode: ProcessStartMode.inheritStdio);
      await Process.start("$webservicePath\\php-8.4\\php-cgi.exe",["-b","127.0.0.1:9000"],mode: ProcessStartMode.inheritStdio);
    }
    setState(() {
      status = value;
    });
  }

  @override
  void initState() {
    _checkNginxStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Container(
            child: Image(
              image: AssetImage("assets/nginx.png"),
              width: 32,
              height: 32,
            ),
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
            activeColor: const Color.fromARGB(255, 14, 175, 9),
            value: status,
            onChanged: (value) {
              _startNginx(value);
            },
          ),
        ],
      ),
    );
  }
}
