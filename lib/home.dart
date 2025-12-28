import 'package:flutter/material.dart';
import 'package:gajahweb/components/httpd_control.dart';
import 'package:gajahweb/components/information.dart';
import 'package:gajahweb/components/postgresql_control.dart';
import 'package:gajahweb/components/xampp_sameless.dart';
import 'package:gajahweb/utils/process.dart';
import 'package:gajahweb/utils/runtime.dart';
import 'package:gajahweb/components/mariadb_control.dart';
import 'package:gajahweb/components/nginx_control.dart';
import 'package:gajahweb/components/redis_control.dart';
import 'dart:io';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  bool _isTerminalVisible = false;
  String _OSVer = Platform.operatingSystem;
  @override
  void initState() {
    super.initState();
    getConfig();
    print("Operating System: $_OSVer");
  }

  @override
  Widget build(BuildContext context) {
    final serviceWidgets = [
      const HttpdControl(),
      const Nginxcontrol(),
      const Mariadbcontrol(),
      const Postgresqlcontrol(),
      const Rediscontrol(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Control Panel",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        actions: [
          Tooltip(
            message: "Download PHP Versions",
            child:
          IconButton(
            onPressed: () => Navigator.pushNamed(context, "/download"),
            icon: const Icon(Icons.download),
          )),
          const SizedBox(width: 10),
          Tooltip(
            message: "Check for Updates",
            child: IconButton(
              onPressed: () async {
                      await Process.start('C:\\gajahweb\\ota-update.exe',
                      [],
                      runInShell: false,
                      mode: ProcessStartMode.detached,
                      workingDirectory: "C:\\gajahweb\\",
                    );
                  },
              icon: const Icon(Icons.update),
            ),
          ),
          const SizedBox(width: 10),
          Tooltip(
            message: "Settings",
            child: IconButton(
              onPressed: () => Navigator.pushNamed(context, "/settings"),
              icon: const Icon(Icons.settings),
            ),
          ),
          const SizedBox(width: 10),

        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Padding(
          padding: EdgeInsets.only(bottom: _isTerminalVisible ? 140 : 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Services",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              LayoutBuilder(
                builder: (context, constraints) {
                  const cardWidth = 160.0;
                  const spacing = 12.0;
                  final totalItems = serviceWidgets.length;

                  final crossAxisCount =
                      (constraints.maxWidth / (cardWidth + spacing))
                          .floor()
                          .clamp(1, totalItems);
                  final requiredWidth =
                      crossAxisCount * cardWidth +
                      (crossAxisCount - 1) * spacing;

                  return Center(
                    child: SizedBox(
                      width: requiredWidth,
                      child: GridView.count(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: spacing,
                        mainAxisSpacing: spacing,
                        childAspectRatio: 1,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: serviceWidgets,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                "Utilities",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Xamppsameless(),
              const SizedBox(height: 12),
              Row(
                children: [
                  _UtilityButton(
                    label: "HeidiSQL",
                    icon: Icons.storage,
                    onTap: () => startProgram(
                      "C:\\gajahweb\\heidisql\\heidisql.exe",
                      [],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _UtilityButton(
                    label: "Htdocs",
                    icon: Icons.folder,
                    onTap: () =>
                        startProgram('explorer.exe', ["C:\\gajahweb\\htdocs"]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomSheet: _isTerminalVisible
          ? Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: const Information(),
            )
          : const SizedBox.shrink(),
      bottomNavigationBar: SizedBox(
        height: 35.0,
        child: BottomAppBar(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            children: [
              const Text("Build v2.1", style: TextStyle(fontSize: 12)),
              const Spacer(),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, "/about"),
                child: const Text("About"),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _isTerminalVisible
                      ? Icons.keyboard_arrow_down
                      : Icons.terminal,
                ),
                onPressed: () {
                  setState(() {
                    _isTerminalVisible = !_isTerminalVisible;
                  });
                },
                tooltip: _isTerminalVisible ? "Hide Logging" : "Show Logging",
                iconSize: 20,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UtilityButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _UtilityButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.0),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
