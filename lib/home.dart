import 'package:flutter/material.dart';
import 'package:xampp_clone/utils/runtime.dart';
import '/components/mariadbControl.dart';
import '/components/nginxControl.dart';
import 'components/redisControl.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  @override
  void initState() {
    getConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          spacing: 10,
          children: [
            Icon(Icons.home_filled, color: Colors.white),
            Text(
              "Control Panel",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.download,
                color: const Color.fromARGB(255, 157, 208, 255),
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          spacing: 10,
          children: [Nginxcontrol(), Mariadbcontrol(), Rediscontrol()],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
        child: Row(
          children: [
            Text("Build v1.0", style: TextStyle(fontSize:12,color: Colors.white)),
            Spacer(),
            Text("Support @yohanesokta", style: TextStyle(fontSize:12,color:  Colors.white)),

          ],
        ),
      ),
    );
  }
}
