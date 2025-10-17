import 'dart:io';
import 'package:gajahweb/components/part/notification.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HtdocsLocation { gajahweb, xampp }

class Xamppsameless extends StatefulWidget {
  const Xamppsameless({super.key});

  @override
  State<Xamppsameless> createState() => _XamppsamelessState();
}

class _XamppsamelessState extends State<Xamppsameless> {
  HtdocsLocation _selection = HtdocsLocation.gajahweb;
  String _activeHtdocsPath = "C:\\gajahweb\\htdocs";
  late String _nginxPort;

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;

    final htdocs = preferences.getString("htdocs") ?? "C:\\gajahweb\\htdocs";
    setState(() {
      _nginxPort = preferences.getString("nginxPort") ?? "80";
      _activeHtdocsPath = htdocs;
      _selection = _isDefaultPath(htdocs) ? HtdocsLocation.gajahweb : HtdocsLocation.xampp;
    });
  }

  bool _isDefaultPath(String path) {
    return path == "C:\\gajahweb\\htdocs";
  }

  Future<void> _changeHtdocs(Set<HtdocsLocation> newSelection) async {
    final selection = newSelection.first;
    final newHtdocs = selection == HtdocsLocation.gajahweb ? "C:\\gajahweb\\htdocs" : "C:\\xampp\\htdocs";

    await Process.start(
      "cmd.exe",
      ['/c', 'nginx-port.bat', _nginxPort, newHtdocs],
      runInShell: true,
      mode: ProcessStartMode.detached,
      workingDirectory: "C:\\gajahweb\\data\\flutter_assets\\resource",
    );
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString("htdocs", newHtdocs);
    await Process.run("C:\\gajahweb\\nginx\\nginx.exe", ["-s", "stop"], workingDirectory: "C:\\gajahweb\\nginx");
    await Process.run("taskkill.exe", ["/F", "/IM", "nginx.exe"]);

    if (mounted) {
      setState(() {
        _activeHtdocsPath = newHtdocs;
        _selection = selection;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "XAMPP Seamless Mode",
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Integrate with a local XAMPP installation.",
              style: theme.textTheme.bodySmall,
            ),
            
            const SizedBox(height: 20),
            const Text("Web Root (htdocs)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            SegmentedButton<HtdocsLocation>(
              segments: const [
                ButtonSegment(value: HtdocsLocation.gajahweb, label: Text("GajahWeb"), icon: Icon(Icons.home_filled)),
                ButtonSegment(value: HtdocsLocation.xampp, label: Text("XAMPP"), icon: Icon(Icons.web)),
              ],
              selected: {_selection},
              onSelectionChanged: _changeHtdocs,
            ),
            const SizedBox(height: 12),
            Text(
              "Apache is disabled in this mode. (control it via XAMPP Control Panel)",
              style: TextStyle(
                fontSize: 12,
                color:Color.fromARGB(255, 143, 141, 36),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.folder_open, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _activeHtdocsPath,
                    style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.storage_rounded, size: 18),
                    SizedBox(width: 8),
                    Text("Use XAMPP MySQL", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  onPressed: ()  {
                    showConfirmDialog(
                      context,
                      "To use XAMPP's MySQL & Apache, please start it manually from the XAMPP control panel.",
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
