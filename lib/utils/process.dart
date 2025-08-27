import "dart:io";

Future<bool> checkProcess(String nameProcess) async {
  try {
    final result = await Process.run('tasklist', [], runInShell: true);
    final output = result.stdout.toString().toLowerCase();
    return output.contains(nameProcess);
  } catch (error) {
    print(error.toString());
    return false;
  }
}

Future<void> StartProgram(String path, List<String> arguments) async {
  try {
    await Process.start(
      path,
      arguments,
      mode: ProcessStartMode.detached,
      runInShell: false,
    );
  } catch (err) {
    print(err);
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
    print(error);
    return false;
  }
}

Future<bool> checkPort(String port) async {
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
