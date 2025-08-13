import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/process.dart';
import 'dart:io';

class Mariadbcontrol extends StatefulWidget {
  const Mariadbcontrol({super.key});

  @override
  State<Mariadbcontrol> createState() => _MariadbcontrolState();
}

class _MariadbcontrolState extends State<Mariadbcontrol> {
  bool status = false;
  bool _isTrigger = false;

  Future<void> _triggerMariaDB() async {
    setState(() {
      _isTrigger = true;
    });
    try {
      final mysqlPath = "C:\\gajahweb\\mariadb";
      if (status) {
        killProcess('mysqld.exe');
      } else {
        Process.start(
          "$mysqlPath\\bin\\mysqld.exe",
          ["--datadir=$mysqlPath\\data", "--console"],
          runInShell: true,
          mode: ProcessStartMode.inheritStdio,
        );
      }
    } catch (error) {
      print(error);
    }
  }

  void _checkMariadbStatus() async {
    final PortProcess portStatus = await checkPort(3306);
    if (_isTrigger) {
      setState(() {
        _isTrigger =false;
      });
    } else {
      setState(() {
        status = portStatus.used;
      });
    }
  }

  @override
  void initState() {
    _checkMariadbStatus();
    Timer.periodic(Duration(seconds: 5), (timer) {
      _checkMariadbStatus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Image(image: AssetImage("assets/mysqld.png"), width: 32, height: 32),
          Text(
            "Mysql Server",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Switch(
            value: status,
            onChanged: (value) {
              _triggerMariaDB();
              setState(() {
                status = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
