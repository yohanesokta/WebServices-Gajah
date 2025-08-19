import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gajahweb/utils/terminalContext.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  final ScrollController _scrollController = ScrollController();
  

  @override
  void initState() {
    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      final terminalText = context.read<Terminalcontext>();
      terminalText.addListener(() {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(
            _scrollController.position.maxScrollExtent,
          );
        }
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final text = Provider.of<Terminalcontext>(context,listen: true).terminalContext;

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 27, 27, 27),
        borderRadius: BorderRadius.circular(5)
      ),
      child: ListView.builder(
        itemCount: text.length,
        controller: _scrollController,
        itemBuilder: (context, index) {
          return Text(text[index],style: TextStyle(color: const Color.fromARGB(255, 185, 185, 185),fontSize: 11,height: 1),);
        },
      ),
    );
  }
}