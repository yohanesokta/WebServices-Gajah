import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:xampp_clone/utils/terminalContext.dart';
import 'home.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(445, 355),
      center: true,
      title: "Gajah Webserver",
    );

    windowManager.waitUntilReadyToShow(windowOptions,() async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setMaximizable(false);
      await windowManager.setResizable(false);
    });

    runApp(
      ChangeNotifierProvider(create: (context) => Terminalcontext(), child: MainApp(),)
    );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Gajah Webserver",
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: const Color.fromARGB(255, 18, 18, 18)),
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 18)
      ),
      debugShowCheckedModeBanner: false,
      home: HomeApp(),
      onGenerateRoute: (settings)  {
        switch (settings.name) {
          
        }
      },
    );
  }
}