import 'package:flutter/material.dart';
import 'home.dart';

void main() async {
    runApp(MainApp());
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
    );
  }
}