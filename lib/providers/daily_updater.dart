import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/providers/app_usages.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:productive_cats/utils/utils.dart';

class DailyUpdater extends ChangeNotifier {
  DailyUpdater(this._usages, this._coins);

  final Coins _coins;
  final AppUsages _usages;

  // lastUpdated keeps track of the
  DateTime? get lastUpdated {
    var box = Hive.box<String>('settings');
    var luStr = box.get('lastUpdated');
    if (luStr == null) return null;
    return DateTime.parse(luStr);
  }

  set _lastUpdated(DateTime? t) {
    if (t == null) return;
    var box = Hive.box<String>('settings');
    box.put('lastUpdated', t.toIso8601String());
  }

  // updates
  Future<bool> update([bool force = false]) async {
    var now = DateTime.now();
    var midnight = DateTime(now.year, now.month, now.day);
    if (force || lastUpdated == null) {
      _lastUpdated = DateTime(now.year, now.month, now.day - 1);
    }
    if (!force && !lastUpdated!.isBefore(midnight)) return false;
    Utils.log('updating');

    // update coins
    var period = AppUsagePeriod(start: lastUpdated!, end: midnight);
    var ok = await period.fetch();
    if (!ok) return false;
    await _usages.fetchApps(period);

    _coins.coins += period.offlineDuration.inSeconds / 3600.0;

    _lastUpdated = midnight;

    // update cats exp
    for (var cat in Cat.catbox.values) {
      cat.consumeDailyUsage(period, _usages.apps);
    }
    return true;
  }
}
