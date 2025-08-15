import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:xampp_clone/utils/process.dart';
import 'package:xampp_clone/utils/terminalContext.dart';

class Rediscontrol extends StatefulWidget {
  const Rediscontrol({super.key});

  @override
  State<Rediscontrol> createState() => _RediscontrolState();
}

class _RediscontrolState extends State<Rediscontrol> {
  bool status = false;
  final redisPath = "C:\\gajahweb\\redis";
    late void terminalAdd;
 

  void _checkRedisStatus() async {
    bool processStatus = await checkProcess("redis-server.exe");
    setState(() {
      status = processStatus;
    });
  }

  @override
  Future<void> sendTerminal(String message) async {
     final terminalAdd = Provider.of<Terminalcontext>(context,listen: false).add;
     terminalAdd(message);
  }

  Future<void> _trigerdRedis(bool value) async {
    if (value) {
      final process = await Process.start(
        "$redisPath\\redis-server.exe",
        [],
        runInShell: false,
        mode: ProcessStartMode.normal,
        workingDirectory: redisPath,
      );
      process.stdout.transform(systemEncoding.decoder).listen((data) {
        sendTerminal(data);
      });
      setState(() {
        status = true;
      });
    } else {
      await killProcess("redis-server.exe");
      setState(() {
        status = false;
      });
    }
  }

  @override
  void initState() {
    _checkRedisStatus();
    Timer.periodic(Duration(seconds: 2), (timer) {
      _checkRedisStatus();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 47, 29, 122),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Image(image: AssetImage("assets/redis.png"), width: 32, height: 32),
          Text(
            "Redis Server",
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
              _trigerdRedis(value);
            },
          ),
        ],
      ),
    );
    ;
  }
}
