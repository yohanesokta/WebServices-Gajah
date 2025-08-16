import 'package:flutter/material.dart';
import 'package:xampp_clone/model/phpVersion.dart';
import 'dart:io';

class Download extends StatefulWidget {
  const Download({super.key});

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _changePHPVersion(String name, String url, int index) async {
    try {
    final String configDir = "C:\\gajahweb\\data\\flutter_assets";
    final String configType = (index > 834) ? "legacy" : "universal";
    final process = await Process.start(
      "cmd.exe",
      ['/c', '$configDir\\php-change-v.bat', name, url, configType],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download PHP Version")),
      body: Container(
        child: FutureBuilder<List<Phpversion>?>(
          future: getDataVersion(),
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
                              onPressed: () {
                                _changePHPVersion(versionData.name, versionData.url, index);
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
