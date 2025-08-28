import 'package:flutter/material.dart';
import 'package:network_tools/network_tools.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:gajahweb/components/part/about.dart';
import 'package:gajahweb/components/part/download.dart';
import 'package:gajahweb/components/part/settings.dart';
import 'package:gajahweb/utils/slideLeftRoute.dart';
import 'package:gajahweb/utils/terminalContext.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final appDirectory = await getApplicationDocumentsDirectory();
  await configureNetworkTools(appDirectory.path, enableDebugging: true);

  WindowOptions windowOptions = const WindowOptions(
    size: Size(445, 550),
    center: true,
    title: "Gajah Webserver",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setMaximizable(false);
    await windowManager.setResizable(false);
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) => Terminalcontext(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gajah Webserver",
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 18, 18, 18),
          titleTextStyle: TextStyle(color: Colors.white),
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: MaterialStateProperty.all(Colors.blue), // warna thumb
          trackColor: MaterialStateProperty.all(Colors.grey[300]),
          trackBorderColor: MaterialStateProperty.all(Colors.grey),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomeApp(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/about":
            return SlideLeftRoute(page: AboutPage());
          case "/download":
            return SlideLeftRoute(page: Download());
          case "/settings":
            return SlideLeftRoute(page: Settings());
        }
        return null;
      },
    );
  }
}
