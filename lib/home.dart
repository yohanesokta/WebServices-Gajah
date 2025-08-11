import 'package:flutter/material.dart';
import '/components/mariadbControl.dart';
import '/components/nginxControl.dart';
import '/components/phpVersion.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 10,
          children: [
            Icon(Icons.settings),
            Text("Control Panels",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          spacing: 10,
          children: [
            Nginxcontrol(),
            Mariadbcontrol(),
            Phpversion()
          ],
        ),
      ),
    );
  }
}
