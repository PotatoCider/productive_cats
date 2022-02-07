import 'dart:convert';

import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:productive_cats/utils/utils.dart';

class AppUsages with ChangeNotifier {
  AppUsages() {
    fetch();
  }

  final DateTime _i = DateTime.now();

  late final AppUsagePeriod yesterday = AppUsagePeriod(
    start: DateTime(_i.year, _i.month, _i.day - 1),
    end: DateTime(_i.year, _i.month, _i.day),
  );
  late final AppUsagePeriod lastMonth = AppUsagePeriod(
    start: DateTime(_i.year, _i.month - 1, 1),
    end: DateTime(_i.year, _i.month, 1),
  );
  late final AppUsagePeriod lastYear = AppUsagePeriod(
    start: DateTime(_i.year - 1, 1, 1),
    end: DateTime(_i.year, 1, 1),
  );

  late AppUsagePeriod _selected = yesterday;
  AppUsagePeriod get selected => _selected;
  set selected(AppUsagePeriod selected) {
    _selected = selected;
    notifyListeners();
  }

  Map<String, ApplicationWithIcon> apps = {};

  Future<void> fetchApps([bool notify = true]) async {
    Set<String> appNames = yesterday.durations.keys.toSet();
    appNames.addAll(lastMonth.durations.keys);
    appNames.addAll(lastYear.durations.keys);
    appNames.removeAll(apps.keys);

    for (var name in appNames) {
      var app = await DeviceApps.getApp(name, true);
      if (app != null) apps[name] = app as ApplicationWithIcon;
    }

    if (notify) notifyListeners();
  }

  Future<void> fetch() async {
    Utils.log('fetching...');
    await yesterday.fetch();
    await fetchApps(true);
    Utils.log('yesterday done');
    await lastMonth.fetch();
    await fetchApps(true);
    Utils.log('month done');
    await lastYear.fetch();
    await fetchApps(true);
    Utils.log('year done');

    Utils.log('fetchApps done');
  }
}

class AppUsagePeriod with ChangeNotifier {
  AppUsagePeriod({
    required this.start,
    required this.end,
    this.period,
  }) {
    fetch();
  }

  Future? loading;
  Duration totalDuration = const Duration();
  Map<String, Duration> durations = {};

  late final Duration maxDuration = end.difference(start);
  final DateTime start;
  final DateTime end;
  String? period;

  Duration get offlineDuration => maxDuration - totalDuration;

  Future<void> fetch() async {
    if (loading != null) return loading;
    loading = Future<void>(() async {
      var infos = await AppUsage.getAppUsage(start, end);

      totalDuration = const Duration();
      for (var info in infos) {
        var name = info.packageName;
        durations[name] = info.usage;
        totalDuration += durations[name]!;
      }

      _appNamesByUsage = null;
      notifyListeners();
    });
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
