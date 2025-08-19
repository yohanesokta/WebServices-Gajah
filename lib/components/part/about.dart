import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gajah Webservice")),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 20),
          child: Text(
                "Dibuat dengan semangat oleh @yohanesokta\n"
                "Proyek ini menyediakan paket web server lengkap untuk pengembangan lokal, "
                "termasuk Nginx, PHP latest^, dan MariaDB.",
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,)
          ),
        ),
      );
  }
}
