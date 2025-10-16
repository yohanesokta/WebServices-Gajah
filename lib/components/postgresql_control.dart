import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gajahweb/components/service_control_card.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:gajahweb/utils/process.dart';
import 'package:gajahweb/utils/terminal_context.dart';

class Postgresqlcontrol extends StatefulWidget {
  const Postgresqlcontrol({super.key});

  @override
  State<Postgresqlcontrol> createState() => _PostgresqlcontrolState();
}

class _PostgresqlcontrolState extends State<Postgresqlcontrol> {
  bool status = false;
  bool _isManualChanging = false;
  Timer? _statusTimer;
  final postgresPath = "C:\\gajahweb\\postgres\\bin";

  void _checkPostgresStatus() async {
    if (_isManualChanging) return;
    bool processStatus = await checkProcess("postgres.exe");
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

  Future<void> _triggerPostgres(bool value) async {
    _isManualChanging = true;
    if (value) {
       await Process.start(
        "$postgresPath\\postgres.exe",
        ["-D", "C:\\gajahweb\\postgres\\data"],
        runInShell: false,
        mode: ProcessStartMode.detached,
        workingDirectory: postgresPath,
      );
      sendTerminal("Berhasil Menjalankan Postgresql Server [postgres.exe]");
    } else {
      await killProcess("postgres.exe");
      sendTerminal("Menghentikan Proses [postgres.exe]\nBerhasil Dilakukan!");
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

  void _launchPsql() async {
    await Process.start(
      "cmd.exe",
      ["/c", "start", "psql.exe", "-U", "postgres"],
      workingDirectory: postgresPath,
      runInShell: true,
      mode: ProcessStartMode.detached,
    );
  }

  @override
  void initState() {
    super.initState();
    _checkPostgresStatus();
    _statusTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _checkPostgresStatus();
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
      serviceName: "PostgreSQL",
      statusText: status ? "Running" : "Stopped",
      statusColor: status ? Colors.green : Colors.red,
      value: status,
      onChanged: _triggerPostgres,
      onLaunch: status ? _launchPsql : null,
      imageAsset: "assets/postgre.png",
    );
  }
}
