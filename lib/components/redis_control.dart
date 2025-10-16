import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:gajahweb/utils/process.dart';
import 'package:gajahweb/utils/terminal_context.dart';

class Rediscontrol extends StatefulWidget {
  const Rediscontrol({super.key});

  @override
  State<Rediscontrol> createState() => _RediscontrolState();
}

class _RediscontrolState extends State<Rediscontrol> {
  bool status = false;
  bool _isManualChanging = false;
  Timer? _statusTimer;
  final redisPath = "C:\\gajahweb\\redis";
  late void terminalAdd;

  void _checkRedisStatus() async {
    if (_isManualChanging) return;
    bool processStatus = await checkProcess("redis-server.exe");
    setState(() {
      status = processStatus;
    });
  }

  Future<void> sendTerminal(String message) async {
    final terminalAdd = Provider.of<Terminalcontext>(
      context,
      listen: false,
    ).add;
    terminalAdd(message);
  }

  Future<void> _trigerdRedis(bool value) async {
    _isManualChanging = true;
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
      sendTerminal(
        "Menghentikan Proses [redis-server.exe]\nBerhasil Dilakukan!",
      );
      setState(() {
        status = false;
      });
    }
    Future.delayed(const Duration(seconds: 2), () {
      _isManualChanging = false;
    });
  }

  @override
  void initState() {
    _checkRedisStatus();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkRedisStatus();
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
            color: const Color.fromARGB(255, 47, 29, 122),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 10,
            children: [
              Image(
                image: AssetImage("assets/redis.png"),
                width: 32,
                height: 32,
              ),
              Text(
                "Redis Server",
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
                  _trigerdRedis(value);
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
                      String pathRedis = "C:\\gajahweb\\redis";
                      await Process.start(
                        "cmd.exe",
                        ["/c", "start", "redis-cli.exe"],
                        workingDirectory: pathRedis,
                        runInShell: true,
                        mode: ProcessStartMode.detached,
                      );
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
