import 'package:flutter/material.dart';
import 'package:gajahweb/components/information.dart';
import 'package:gajahweb/components/postgresql_control.dart';
import 'package:gajahweb/components/xampp_sameless.dart';
import 'package:gajahweb/utils/process.dart';
import 'package:gajahweb/utils/runtime.dart';
import 'package:gajahweb/components/mariadb_control.dart';
import 'package:gajahweb/components/nginx_control.dart';
import 'package:gajahweb/components/redis_control.dart';

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
              onPressed: () {
                Navigator.pushNamed(context, "/download");
              },
              icon: Icon(
                Icons.download,
                color: const Color.fromARGB(255, 157, 208, 255),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/settings");
              },
              icon: Icon(Icons.settings, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          spacing: 10,
          children: [
            Row(
              spacing: 10,
              children: [Nginxcontrol(), Mariadbcontrol(), Rediscontrol()],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Postgresqlcontrol(), Xamppsameless()],
            ),
            Information(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                InkWell(
                  onTap: () {
                    startProgram("C:\\gajahweb\\heidisql\\heidisql.exe", []);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 199, 129, 0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.storage,
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        Text("HeidiSQL", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    startProgram('explorer.exe', ["C:\\gajahweb\\htdocs\\"]);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 70, 70, 70),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      spacing: 5,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.folder, color: Colors.amber),
                        Text("htdocs", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          children: [
            Text(
              "Build v1.2",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/about");
              },
              child: Row(
                spacing: 3,
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 14),
                  Text(
                    "About",
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
