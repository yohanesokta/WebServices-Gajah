import 'package:flutter/material.dart';
import 'package:network_tools/network_tools.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:gajahweb/components/part/about.dart';
import 'package:gajahweb/components/part/download.dart';
import 'package:gajahweb/components/part/settings.dart';
import 'package:gajahweb/utils/slide_left_route.dart';
import 'package:gajahweb/utils/terminal_context.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final appDirectory = await getApplicationDocumentsDirectory();
  await configureNetworkTools(appDirectory.path, enableDebugging: true);

  WindowOptions windowOptions = const WindowOptions(
    size: Size(580, 700), // Adjusted for the new fixed layout
    center: true,
    title: "Gajah Control Panel",
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setMaximizable(true); // Allow maximizing
    await windowManager.setResizable(true); // Allow resizing
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) => Terminalcontext(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gajah Control Panel",
      themeMode: ThemeMode.dark, // Enforce dark theme
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
        cardTheme:  CardThemeData(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius:  BorderRadius.circular(12.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.blueAccent,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeApp(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/about":
            return SlideLeftRoute(page: const AboutPage());
          case "/download":
            return SlideLeftRoute(page: const Download());
          case "/settings":
            return SlideLeftRoute(page: const Settings());
        }
        return null;
      },
    );
  }
}
