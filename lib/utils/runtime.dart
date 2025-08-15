import "dart:io";
import "package:path_provider/path_provider.dart";

Future <void> getConfig() async {
    final String filePath = "C:\\gajahweb\\config.log";
    final file = File(filePath);
    if (await file.exists()) {
        final config = await file.readAsString();
        print(config);
    } else {
        print("file not exisits");
    }
}
