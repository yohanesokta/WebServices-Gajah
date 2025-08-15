import 'package:flutter/material.dart';

class Terminalcontext with ChangeNotifier {
  List<String> _message = [];

  List<String> get terminalContext => _message;

  void add(String text) {
    _message.add(text);
    notifyListeners();
  }

} 