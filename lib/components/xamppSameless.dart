import 'package:flutter/material.dart';

class Xamppsameless extends StatefulWidget {
  const Xamppsameless({super.key});

  @override
  State<Xamppsameless> createState() => _XamppsamelessState();
}

class _XamppsamelessState extends State<Xamppsameless> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 245,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "XAMPP - SAMELESS",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber),
          ),
          Text(
            "buat system sameless dengan xampp.",
            style: TextStyle(
              fontSize: 10,
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Text(
                "htdocs :",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Enable",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 85, 255, 79),
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "mysql :",
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Manual",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
