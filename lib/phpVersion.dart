import 'package:flutter/material.dart';

class Phpversion extends StatefulWidget {
  const Phpversion({super.key});

  @override
  State<Phpversion> createState() => _PhpversionState();
}

class _PhpversionState extends State<Phpversion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 47, 29, 122),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          Image(image: AssetImage("assets/php.png"), width: 32, height: 32),
          Text(
            "PHP Version",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("php.8.2",style: TextStyle(color: const Color.fromARGB(255, 179, 179, 179)),),
          )
        ],
      ),
    );;
  }
}