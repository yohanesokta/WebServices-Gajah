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
    await Process.start(path,arguments,mode: ProcessStartMode.detached,runInShell: false);
  } catch (err) {
    print(err);
  }
}

Future<bool> killProcess(String nameProcess) async {
  try {
    final result = await Process.run('taskkill.exe', ["/F","/IM",nameProcess],runInShell: true);
    final output = result.stdout.toString();
    return output.isNotEmpty;
  } catch (error) {
    print(error);
    return false;
  }
}

class PortProcess {
    String logs;
    bool used;
    PortProcess(this.logs,this.used);
}

Future<PortProcess> checkPort(int port) async {
  try {
    final result = await Process.run("netstat", ["-ano","|","findstr",":$port"] ,runInShell: true);
    final output = result.stdout.toString();
    return PortProcess(output, output.isNotEmpty);
  } catch(error) {
    print(error);
    return PortProcess("", false);
  }
}