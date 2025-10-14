import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  final postgresPath = "C:\\gajahweb\\postgres\\bin";
  late void terminalAdd;

  void _checkPostgresStatus() async {
    bool processStatus = await checkProcess("postgres.exe");
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

  Future<void> _trigerdPostgres(bool value) async {
    if (value) {
      final process = await Process.start(
        "$postgresPath\\postgres.exe",
        ["-D", "$postgresPath\\data"],
        runInShell: false,
        mode: ProcessStartMode.normal,
        workingDirectory: postgresPath,
      );
      process.stdout.transform(systemEncoding.decoder).listen((data) {
        sendTerminal(data);
      });
      setState(() {
        sendTerminal("Berhasil Menjalankan Postgresql Server [postgres.exe]");
        status = true;
      });
    } else {
      await killProcess("postgres.exe");
      sendTerminal("Menghentikan Proses [postgres.exe]\nBerhasil Dilakukan!");
      setState(() {
        status = false;
      });
    }
  }

  @override
  void initState() {
    _checkPostgresStatus();
    Timer.periodic(Duration(seconds: 2), (timer) {
      _checkPostgresStatus();
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
            color: const Color.fromARGB(255, 47, 29, 122),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            spacing: 10,
            mainAxisSize: MainAxisSize.max,
            children: [
              Image(
                image: AssetImage("assets/postgre.png"),
                width: 32,
                height: 32,
              ),
              Text(
                "PostgreSQL Server",
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
                  _trigerdPostgres(value);
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
                      String pathRedis = "C:\\gajahweb\\postgres\\bin";
                      await Process.start(
                        "cmd.exe",
                        ["/c", "start", "psql.exe", "-U", "postgres"],
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
