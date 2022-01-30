import 'package:flutter/material.dart';

class Coins with ChangeNotifier {
  int _coins = 0;
  int get value => _coins;

  void increment() {
    _coins++;
    notifyListeners();
  }
}
