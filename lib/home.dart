import 'package:flutter/material.dart';
import 'package:xampp_clone/mariadbControl.dart';
import 'package:xampp_clone/nginxControl.dart';
import 'package:xampp_clone/phpVersion.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  bool _ngixStatus = false;

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
