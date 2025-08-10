import 'package:flutter/material.dart';

class Nginxcontrol extends StatefulWidget {
  const Nginxcontrol({super.key});

  @override
  State<Nginxcontrol> createState() => _Nginxcontrol();
}

class _Nginxcontrol extends State<Nginxcontrol> {
  bool status = false;

  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
         gradient: LinearGradient(colors: [
                const Color.fromARGB(255, 59, 69, 206),
                const Color.fromARGB(255, 32, 145, 238)
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
          Container(
            child:  Image(image: AssetImage("assets/nginx.png"), width: 32, height: 32),
          ),
          Text(
            "Nginx Server",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Switch(
            activeColor: const Color.fromARGB(255, 14, 175, 9),
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