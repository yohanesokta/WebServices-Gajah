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