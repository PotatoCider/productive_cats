import 'package:flutter/material.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/providers/app_usages.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:productive_cats/providers/user_info.dart';
import 'package:productive_cats/utils/utils.dart';

class DailyUpdater extends ChangeNotifier {
  DailyUpdater(this._user, this._usages, this._coins);

  final UserInfo _user;
  final Coins _coins;
  final AppUsages _usages;

  // lastUpdated keeps track of the
  DateTime? get lastUpdated {
    var box = _user.box!;
    var luStr = box.get('lastUpdated');
    if (luStr == null) return null;
    return DateTime.parse(luStr);
  }

  set _lastUpdated(DateTime? t) {
    if (t == null) return;
    var box = _user.box!;
    box.put('lastUpdated', t.toIso8601String());
  }

  // updates
  Future<bool> update([bool force = false, int days = 1]) async {
    var now = DateTime.now();
    var lastMidnight = DateTime(now.year, now.month, now.day);
    if (force || lastUpdated == null) {
      _lastUpdated = DateTime(now.year, now.month, now.day - days);
    }
    if (!force && !lastUpdated!.isBefore(lastMidnight)) return false;
    Utils.log('updating');

    // update coins
    var period = AppUsagePeriod(start: lastUpdated!, end: lastMidnight);
    var ok = await period.fetch();
    if (!ok) return false;
    await _usages.fetchApps(period);
    Utils.log(_usages.apps);

    _coins.coins += period.offlineDuration.inSeconds / 3600.0;

    _lastUpdated = lastMidnight;

    // update cats exp
    for (var cat in Cat.catbox!.values) {
      for (int i = 0; i < days; i++) {
        cat.consumeDailyUsage(period, _usages.apps);
      }
    }
    return true;
  }
}
