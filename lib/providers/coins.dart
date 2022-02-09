import 'package:flutter/material.dart';
import 'package:productive_cats/providers/user_info.dart';

class Coins with ChangeNotifier {
  Coins(this._user);

  final UserInfo _user;

  double get coins {
    var str = _user.box?.get('coins');

    return str == null ? 0 : double.parse(str);
  }

  int get coinsInt => coins.round();

  set coins(double newValue) {
    if (newValue < 0) newValue = 0;
    _user.box!.put('coins', newValue.toString());
    notifyListeners();
  }
}
