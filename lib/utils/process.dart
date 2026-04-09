import "dart:io";
import "dart:convert";
import "dart:async";

String executablePath = File(Platform.resolvedExecutable).parent.path;
String executableRuntime = "$executablePath\\data\\flutter_assets";

List<dynamic> processData = [];
Timer? _monitoringTimer;

Future<void> listenPrograms() async {
  if (!Platform.isWindows) return;

  List<String> processes = [
    "nginx.exe",
    "php-cgi.exe",
    "mysqld.exe",
    "httpd.exe",
    "redis-server.exe",
    "postgres.exe",
  ];

  try {
    final result = await Process.run(
      "$executableRuntime\\utils\\windows\\bin\\winproc_scan.exe",
      processes,
      runInShell: true,
    );

    if (result.exitCode == 0) {
      final output = result.stdout.toString();
      if (output.isNotEmpty) {
        processData = (jsonDecode(output) as List<dynamic>);
      }
    }
  } catch (e) {
    // Silently fail or log error
  }
}

void initProcessMonitoring() {
  if (Platform.isWindows) {
    listenPrograms();
    _monitoringTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      listenPrograms();
    });
  }
}

void disposeProcessMonitoring() {
  _monitoringTimer?.cancel();
}

Future<bool> checkProcess(String nameProcess) async {
  String os = Platform.operatingSystem;
  try {
    if (os == "linux") {
      final result = await Process.run('pgrep', [nameProcess]);
      return result.exitCode == 0;
    } else if (os == "windows") {
      final nameLower = nameProcess.toLowerCase();
      return processData.any((item) {
        final processName = (item['process'] as String).toLowerCase();
        return processName == nameLower;
      });
    }
    return false;
  } catch (error) {
    return false;
  }
}

Future<void> startProgram(String path, List<String> arguments) async {
  try {
    await Process.start(
      path,
      arguments,
      mode: ProcessStartMode.detached,
      runInShell: false,
    );
  } catch (err) {
    // print(err);
  }
}

Future<bool> killProcess(String nameProcess) async {
  try {
    final result = await Process.run('taskkill.exe', [
      "/F",
      "/IM",
      nameProcess,
    ], runInShell: true);
    final output = result.stdout.toString();
    return output.isNotEmpty;
  } catch (error) {
    // print(error);
    return false;
  }
}

Future<bool> isPortAvailable(String port) async {
  try {
    final server = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      int.parse(port),
    );
    await server.close();
    return true;
  } on SocketException {
    return false;
  }
}
