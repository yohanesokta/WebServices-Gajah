import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Xamppsameless extends StatefulWidget {
  const Xamppsameless({super.key});

  @override
  State<Xamppsameless> createState() => _XamppsamelessState();
}

class _XamppsamelessState extends State<Xamppsameless> {
  String htdocs = "C:\\gajahweb\\htdocs";
  late String _nginxPort;
  Future<void> initializeState() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _nginxPort = preferences.getString("nginxPort") ?? "80";
      htdocs = preferences.getString("htdocs") ?? "C:\\gajahweb\\htdocs";
    });
  }

  bool _defaultPath() {
    return htdocs == "C:\\gajahweb\\htdocs";
  }

  Future<void> change() async {
    setState(() {
      if (_defaultPath()) {
        htdocs = "C:\\xampp\\htdocs";
      } else {
        htdocs = "C:\\gajahweb\\htdocs";
      }
    });

    await Process.start(
      "cmd.exe",
      ['/c', 'nginx-port.bat', _nginxPort, htdocs],
      runInShell: true,
      mode: ProcessStartMode.detached,
      workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
    );
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString("htdocs", htdocs);
    await Process.run("C:\\gajahweb\\nginx\\nginx.exe", [
      "-s",
      "stop",
    ], workingDirectory: "C:\\gajahweb\\nginx");
    await Process.run("taskkill.exe", ["/F", "/IM", "nginx.exe"]);
  }

  @override
  void initState() {
    initializeState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "XAMPP - SAMELESS",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          Text(
            "buat system sameless dengan xampp.",
            style: TextStyle(
              fontSize: 10,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                "htdocs :",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              TextButton(
                onPressed: () {
                  change();
                },
                child: Text(
                  (!_defaultPath()) ? "Enable" : "Disable",
                  style: TextStyle(
                    color: (!_defaultPath())
                        ? Color.fromARGB(255, 85, 255, 79)
                        : Colors.red,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "mysql :",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Manual",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
