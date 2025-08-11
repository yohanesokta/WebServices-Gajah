import 'package:flutter/material.dart';

class Mariadbcontrol extends StatefulWidget {
  const Mariadbcontrol({super.key});

  @override
  State<Mariadbcontrol> createState() => _MariadbcontrolState();
}

class _MariadbcontrolState extends State<Mariadbcontrol> {
  bool status = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
         gradient: LinearGradient(colors: [
                const Color.fromARGB(255, 110, 59, 206),
                const Color.fromARGB(255, 63, 13, 129)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
              ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Image(image: AssetImage("assets/mysqld.png"), width: 32, height: 32),
          Text(
            "Mysql Server",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Switch(
            value: status,
            onChanged: (value) {
              setState(() {
                status = value;
              });
            },
          ),
        ],
      ),
    );
  }
}