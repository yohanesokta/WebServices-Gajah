import 'dart:async';

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
import 'package:gajahweb/utils/process.dart';
import 'home.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(580, 700),
    minimumSize: Size(570, 530),
    center: true,
    title: "Gajah Control Panel",
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => Terminalcontext(),
      child: const MainApp(),
    ),
  );

  try {
    await windowManager.ensureInitialized();

    // Initialize process monitoring for Windows
    initProcessMonitoring();

    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setMaximizable(true); // Allow maximizing
      await windowManager.setResizable(true); // Allow resizing
    });
  } catch (error, stackTrace) {
    _reportStartupIssue(
      'Gagal membuka window utama. Aplikasi akan mencoba fallback tampilan.',
      error,
      stackTrace,
    );

    try {
      await windowManager.show();
      await windowManager.focus();
    } catch (fallbackError, fallbackStackTrace) {
      _reportStartupIssue(
        'Fallback window juga gagal dibuka.',
        fallbackError,
        fallbackStackTrace,
      );
    }
  }

  unawaited(_configureNetworkTools());
}

Future<void> _configureNetworkTools() async {
  try {
    final appDirectory = await getApplicationDocumentsDirectory();
    await configureNetworkTools(appDirectory.path, enableDebugging: true);
  } catch (error, stackTrace) {
    _reportStartupIssue(
      'Network tools gagal diinisialisasi. Fitur jaringan mungkin terbatas.',
      error,
      stackTrace,
    );
  }
}

void _reportStartupIssue(String message, Object error, StackTrace? stackTrace) {
  debugPrint('$message\n$error');
  if (stackTrace != null) {
    debugPrint(stackTrace.toString());
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    final messenger = _scaffoldMessengerKey.currentState;
    messenger?.showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gajah Control Panel",
      scaffoldMessengerKey: _scaffoldMessengerKey,
      themeMode: ThemeMode.dark, // Enforce dark theme
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1F1F1F),
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
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
