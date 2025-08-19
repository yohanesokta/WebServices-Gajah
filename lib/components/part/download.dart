import 'package:flutter/material.dart';
import 'package:gajahweb/model/phpVersion.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  final ScrollController _scrollController = ScrollController();
  bool isStable = false;

  Future<void> _changePHPVersion(String name, String url, String type) async {
    try {
    final String configDir = "C:\\gajahweb\\data\\flutter_assets";
    final process = await Process.start(
      "cmd.exe",
      ['/c', '$configDir\\php-change-v.bat', name, url, type],
      mode: ProcessStartMode.detached,
      runInShell: true,
      workingDirectory: configDir
    );

    process.stdout.transform(systemEncoding.decoder).listen((data) {
        print(data.toString());
      });
    } catch (error) {
      print(error);
    }
  }

  void _loadStableStatus() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isStable = preferences.getBool("isStable") ?? false;
    });
  }

  void _changeStable(bool status) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('isStable',status);
    setState(() {
      isStable = status;
    });
  }

  @override
  void initState() {
    _loadStableStatus();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [Text("Download PHP Version"), Spacer(), Text("Stable"), Checkbox(value: isStable, onChanged: (value) {_changeStable(value!);})],
        )
      ),
      body: Container(
        child: FutureBuilder<List<Phpversion>?>(
          future: getDataVersion(isStable),
          builder: (context, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(color: Colors.white),
              );
            } else if (data.hasData) {
              return Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: data.data!.length,
                  itemBuilder: (context, index) {
                    final versionData = data.data![index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(71, 255, 255, 255),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Text(
                              versionData.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Spacer(),
                            TextButton(
                              onPressed: () async {
                                await _changePHPVersion(versionData.name, versionData.url, versionData.type);
                              },
                              child: Text(
                                "change",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            return Center(
              child: Text(
                "Fail Get Data",
                style: TextStyle(color: Colors.white),
              ),
            );
          },
        ),
      ),
    );
  }
}
