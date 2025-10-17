import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gajahweb/components/service_control_card.dart';
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

  void _checkRedisStatus() async {
    if (_isManualChanging) return;
    bool processStatus = await checkProcess("redis-server.exe");
    if (mounted) {
      setState(() {
        status = processStatus;
      });
    }
  }

  Future<void> sendTerminal(String message) async {
    final terminalAdd = Provider.of<Terminalcontext>(
      context,
      listen: false,
    ).add;
    terminalAdd(message);
  }

  Future<void> _triggerRedis(bool value) async {
    _isManualChanging = true;
    if (value) {
      await Process.start(
        "$redisPath\\redis-server.exe",
        [],
        runInShell: false,
        mode: ProcessStartMode.detached,
        workingDirectory: redisPath,
      );
      // process.stdout.transform(systemEncoding.decoder).listen((data) {
      //   sendTerminal(data);
      // });
      sendTerminal("Berhasil Menjalankan Redis Server [redis-server.exe]");
    } else {
      await killProcess("redis-server.exe");
      sendTerminal(
        "Menghentikan Proses [redis-server.exe]\nBerhasil Dilakukan!",
      );
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

  void _launchRedisCli() async {
    await Process.start(
      "cmd.exe",
      ["/c", "start", "redis-cli.exe"],
      workingDirectory: redisPath,
      runInShell: true,
      mode: ProcessStartMode.detached,
    );
  }

  @override
  void initState() {
    super.initState();
    _checkRedisStatus();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkRedisStatus();
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ServiceControlCard(
      serviceName: "Redis",
      statusText: status ? "Running" : "Stopped",
      statusColor: status ? Colors.green : Colors.red,
      value: status,
      onChanged: _triggerRedis,
      onLaunch: status ? _launchRedisCli : null,
      imageAsset: "assets/redis.png",
    );
  }
}

