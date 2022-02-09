import 'package:flutter/material.dart';
import 'package:productive_cats/utils/settings.dart';

class Coins with ChangeNotifier {
  double get coins {
    var str = Settings.box.get('coins');

    return str == null ? 0 : double.parse(str);
  }

  int get coinsInt => coins.round();

  set coins(double newValue) {
    if (newValue < 0) newValue = 0;
    Settings.box.put('coins', newValue.toString());
    notifyListeners();
  }
}
