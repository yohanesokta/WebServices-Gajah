import "dart:io";

Future<void> getConfig() async {
  final String filePath = "C:\\gajahweb\\install.log";
  final file = File(filePath);
  if (await file.exists()) {

  } else {
    // print("file not exisits");
  }
}
