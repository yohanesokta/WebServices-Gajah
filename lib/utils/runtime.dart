import "dart:io";
import "package:xampp_clone/model/phpVersion.dart";

Future <void> getConfig() async {
    final String filePath = "C:\\gajahweb\\install.log";
    final file = File(filePath);
    if (await file.exists()) {
        final config = await file.readAsString();
        print(config);
    } else {
        print("file not exisits");
    }
}


