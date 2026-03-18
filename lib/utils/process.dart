import "dart:io";


Future<bool> checkProcess(String nameProcess) async {
  String os = Platform.operatingSystem;
  try {
    if (os == "linux") {
      final result = await Process.run(
      'pgrep',
      [nameProcess],
    );
    return result.exitCode == 0;
    }
    final result = await Process.run('tasklist', [], runInShell: true);
    final output = result.stdout.toString().toLowerCase();
    final pattern = RegExp(
      r'^\s*' + RegExp.escape(nameProcess.toLowerCase()) + r'\b',
      multiLine: true,
    );
    return pattern.hasMatch(output);
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

/// Kills the process listening on the given [port] on Windows using netstat.
/// Returns true if at least one process was found and all kills succeeded.
Future<bool> killProcessByPort(String port) async {
  try {
    final result = await Process.run(
      'cmd.exe',
      ['/c', 'netstat -ano | findstr :$port'],
      runInShell: false,
    );
    final output = result.stdout.toString();
    final pidPattern = RegExp(r'\s+(\d+)\s*$', multiLine: true);
    final pids = pidPattern.allMatches(output).map((m) => m.group(1)!).toSet();
    if (pids.isEmpty) return false;
    bool allSucceeded = true;
    for (final pid in pids) {
      final killResult = await Process.run(
        'taskkill.exe',
        ['/F', '/PID', pid],
        runInShell: true,
      );
      if (killResult.exitCode != 0) allSucceeded = false;
    }
    return allSucceeded;
  } catch (error) {
    return false;
  }
}
