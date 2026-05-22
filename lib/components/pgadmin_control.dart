import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gajahweb/components/service_control_card.dart';
import 'package:gajahweb/utils/process.dart';
import 'package:gajahweb/utils/terminal_context.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Pgadmincontrol extends StatefulWidget {
  const Pgadmincontrol({super.key});

  @override
  State<Pgadmincontrol> createState() => _PgadmincontrolState();
}

class _PgadmincontrolState extends State<Pgadmincontrol>
    with WidgetsBindingObserver {
  bool status = false;
  bool _isManualChanging = false;
  bool _isInstalling = false;
  Timer? _statusTimer;

  bool _isInstalled = true;

  String get _pgadminBasePath {
    if (Platform.isLinux) {
      final home = Platform.environment['HOME'] ?? '';
      return '$home/.gajahweb/pgadmin';
    }
    return r'C:\gajahweb\pgadmin';
  }

  String get _launchBatchAssetPath =>
      '$executableRuntime\\utils\\windows\\run_pgadmin.bat';

  static const String _defaultPort = '5050';
  static const Duration _statusCheckDelay = Duration(seconds: 3);

  Future<void> sendTerminal(String message) async {
    final terminalAdd = Provider.of<Terminalcontext>(
      context,
      listen: false,
    ).add;
    terminalAdd(message);
  }

  Future<void> _checkPgadminStatus() async {
    if (_isManualChanging) return;
    final prefs = await SharedPreferences.getInstance();
    final port = prefs.getString('pgadminPort') ?? _defaultPort;
    final portInUse = !(await isPortAvailable(port));
    if (mounted) {
      setState(() {
        status = portInUse;
      });
    }
  }

  Future<void> _checkIfInstalled() async {
    final installed = await File(
      '$_pgadminBasePath\\venv\\Scripts\\python.exe',
    ).exists();
    if (mounted) {
      setState(() {
        _isInstalled = installed;
      });
    }
  }

  Future<void> _launchPgadminBatch(String action, String port) async {
    final batchPath = _launchBatchAssetPath;
    if (!await File(batchPath).exists()) {
      throw Exception('pgAdmin batch not found');
    }

    await Process.start(
      'cmd.exe',
      [
        '/c',
        'start',
        '',
        'cmd.exe',
        '/k',
        'call',
        batchPath,
        action,
        port,
        _pgadminBasePath,
      ],
      mode: ProcessStartMode.detached,
      runInShell: false,
    );
  }

  Future<void> _installPgadmin() async {
    if (mounted) {
      setState(() {
        _isManualChanging = true;
        _isInstalling = true;
      });
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final port = prefs.getString('pgadminPort') ?? _defaultPort;
      await _launchPgadminBatch('install', port);
      await sendTerminal('Memulai instalasi pgAdmin 4\nBerhasil');
    } catch (error) {
      debugPrint('Gagal memulai instalasi pgAdmin: $error');
    } finally {
      if (mounted) {
        setState(() {
          _isManualChanging = false;
          _isInstalling = false;
        });
      }
      _checkIfInstalled();
    }
  }

  Future<void> _triggerPgadmin(bool value) async {
    _isManualChanging = true;
    final prefs = await SharedPreferences.getInstance();
    final port = prefs.getString('pgadminPort') ?? _defaultPort;

    try {
      await _launchPgadminBatch(value ? 'run' : 'stop', port);
      await sendTerminal(
        value
            ? 'Memulai proses pgAdmin 4\nBerhasil'
            : 'Menghentikan proses pgAdmin 4\nBerhasil',
      );
    } catch (error) {
      debugPrint('Gagal mengubah status pgAdmin: $error');
    }

    if (mounted) {
      setState(() {
        status = value;
      });
    }

    Future.delayed(_statusCheckDelay, () {
      _isManualChanging = false;
      _checkPgadminStatus();
    });
  }

  Future<void> _launchPgAdmin() async {
    final prefs = await SharedPreferences.getInstance();
    final port = prefs.getString('pgadminPort') ?? _defaultPort;
    final uri = Uri.parse('http://localhost:$port');
    await launchUrl(uri);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkIfInstalled().then((_) => _checkPgadminStatus());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPgadminStatus();
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ServiceControlCard(
      serviceName: 'pgAdmin 4',
      statusText: status ? 'Running' : 'Stopped',
      statusColor: status ? Colors.green : Colors.red,
      value: status,
      onChanged: _isInstalling ? null : _triggerPgadmin,
      onLaunch: status ? _launchPgAdmin : null,
      imageAsset: 'assets/pgadmin.png',
      isInstalled: _isInstalling ? false : _isInstalled,
      onInstall: _installPgadmin,
      isBusy: _isInstalling,
    );
  }
}
