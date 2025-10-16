import 'package:flutter/material.dart';

class Terminalcontext with ChangeNotifier {
  final List<String> _message = [];

  List<String> get terminalContext => _message;

  void add(String text) {
    _message.add("Process: $text");
    notifyListeners();
  }
} 