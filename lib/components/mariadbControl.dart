import 'dart:async';

import 'package:flutter/material.dart';
import '../utils/process.dart';
import 'dart:io';


  Future<bool> showConfirmDialog(BuildContext context, String message) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Center(child: Text('Tampaknya',style: TextStyle(fontWeight: FontWeight.bold),),),
          content: Text(message,style: TextStyle(fontSize: 16,),),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Tidak'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Ya'),
                  ),
                ],
              ),
            )
          ],
        );
      },
    ) ?? false;
  }

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
        await Process.start(
          "$mysqlPath\\bin\\mysqld.exe",
          ["--datadir=$mysqlPath\\data", "--console"],
          mode: ProcessStartMode.detached,
          runInShell: false
        );
      }
    } catch (error) {
      print(error);
    }
  }

  void _checkMariadbStatus() async {
    bool mysqldProcess = await checkProcess('mysqld.exe');
    if (_isTrigger) { _isTrigger = false; }
    else   { setState(() {
      status = mysqldProcess;
    }); }
  }

  @override
  void initState() {
    _checkMariadbStatus();
    Timer.periodic(Duration(seconds: 2), (timer) {
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
