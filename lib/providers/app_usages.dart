import 'dart:convert';

import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:usage_stats/usage_stats.dart';

class AppUsages with ChangeNotifier {
  AppUsages() {
    var n = DateTime.now();
    yesterday = AppUsagePeriod(
      start: DateTime(n.year, n.month, n.day - 2),
      end: DateTime(n.year, n.month, n.day - 1),
      periodText: 'yesterday',
    );
    lastMonth = AppUsagePeriod(
      start: DateTime(n.year, n.month - 1, 1),
      end: DateTime(n.year, n.month, 1),
      periodText: 'last month',
    );
    lastYear = AppUsagePeriod(
      start: DateTime(n.year - 1, 1, 1),
      end: DateTime(n.year, 1, 1),
      periodText: 'last year',
    );
    _selected = yesterday;
  }

  late final AppUsagePeriod yesterday;
  late final AppUsagePeriod lastMonth;
  late final AppUsagePeriod lastYear;

  late AppUsagePeriod _selected;
  AppUsagePeriod get selected => _selected;
  set selected(AppUsagePeriod selected) {
    _selected = selected;
    if (!fetched) fetch();
    notifyListeners();
  }

  bool get fetched => _selected.fetched;

  Map<String, ApplicationWithIcon> apps = {};

  Future<void> fetchApps(AppUsagePeriod period) async {
    var appNames = period.durations.keys.toSet();

    for (var name in appNames) {
      var app = await DeviceApps.getApp(name, true);
      if (app != null) apps[name] = app as ApplicationWithIcon;
    }

    notifyListeners();
  }

  Future<void> fetch([AppUsagePeriod? period]) async {
    period ??= selected;
    await period.fetch();
    await fetchApps(period);
  }
}

class AppUsagePeriod with ChangeNotifier {
  AppUsagePeriod({
    required this.start,
    required this.end,
    String? periodText,
  }) : custom = periodText == null {
    if (periodText == null) {
      var now = DateTime.now();
      var isDiffYear = end.year != now.year || start.year != now.year;
      var fmt = isDiffYear ? DateFormat.yMMMd() : DateFormat.MMMd();
      periodText =
          'from ${fmt.format(start) + (isDiffYear ? '\n' : ' ')}to ${fmt.format(end)}';
    }
    text = periodText;
  }

  bool fetched = false;
  Duration totalDuration = const Duration();
  Map<String, Duration> durations = {};

  late final Duration maxDuration = end.difference(start);
  final DateTime start;
  final DateTime end;
  late final String text;
  final bool custom;

  Duration get offlineDuration => maxDuration - totalDuration;

  Future<bool> fetch() async {
    fetched = false;
    var infos = await AppUsage.getAppUsage(start, end);
    if (infos.isEmpty) return false;
    totalDuration = const Duration();
    for (var info in infos) {
      var name = info.packageName;
      durations[name] = info.usage;
      totalDuration += durations[name]!;
    }

    _appNamesByUsage = null;
    fetched = true;
    notifyListeners();
    return true;
  }

  List<String>? _appNamesByUsage;
  // returns package names of app sorted by usage descending
  List<String> get appNamesByUsage {
    if (_appNamesByUsage != null) return _appNamesByUsage!;

    var appNames = durations.keys.toList();
    appNames.sort((n1, n2) => durations[n2]!.compareTo(durations[n1]!));
    _appNamesByUsage = appNames;
    return appNames;
  }
}
