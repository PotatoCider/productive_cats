import 'dart:convert';

import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsages with ChangeNotifier {
  AppUsages() {
    sync();
  }

  late final DateTime firstUpdate;
  DateTime? lastUpdated;
  Map<String, Duration> durations = {};
  Duration totalDuration = const Duration();
  Map<String, ApplicationWithIcon> apps = {};

  Future<void> fetchApps() async {
    for (var name in durations.keys) {
      if (apps.containsKey(name)) continue;
      var app = await DeviceApps.getApp(name, true) as ApplicationWithIcon?;
      if (app == null) continue;
      apps[name] = app;
    }
  }

  Future<bool> sync() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('app_usages');
    String? json = prefs.getString('app_usages');

    if (json != null) {
      var newThis =
          AppUsages.fromJson(jsonDecode(json) as Map<String, dynamic>);

      // update if not fetched, or out of date
      if (lastUpdated == null ||
          (newThis.lastUpdated?.compareTo(lastUpdated!) ?? 0) > 1) {
        firstUpdate = newThis.firstUpdate;
        lastUpdated = newThis.lastUpdated;
        durations = newThis.durations;
      }
      Utils.logNamed('usage read: ', json);
    }

    var now = DateTime.now();

    if (lastUpdated == null) {
      // first update
      firstUpdate = now.subtract(const Duration(days: 730));
      lastUpdated = firstUpdate;
    }

    var appUsageInfos = await AppUsage.getAppUsage(lastUpdated!, now);
    Utils.logNamed('infos:', appUsageInfos);

    totalDuration = const Duration();
    for (var info in appUsageInfos) {
      var name = info.packageName;
      durations[name] = (durations[name] ?? const Duration()) + info.usage;
      totalDuration += durations[name] ?? const Duration();
    }
    lastUpdated = now;
    await fetchApps();
    notifyListeners();
    // return save();
    return true;
  }

  Future<bool> save() async {
    Utils.logNamed('usage save: ', jsonEncode(toJson()));
    var prefs = await SharedPreferences.getInstance();
    return prefs.setString('app_usages', jsonEncode(toJson()));
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'firstUpdate': firstUpdate.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
      'durations':
          durations.map((name, duration) => MapEntry(name, duration.inSeconds))
    };
  }

  AppUsages.fromJson(Map<String, dynamic> json) {
    try {
      firstUpdate = DateTime.parse(json['firstUpdate'] as String);
      lastUpdated = DateTime.parse(json['lastUpdated'] as String);

      durations = (json['durations'] as Map<String, dynamic>)
          .cast<String, int>()
          .map<String, Duration>(
              (name, duration) => MapEntry(name, Duration(seconds: duration)));
    } catch (e) {
      Utils.log(e);
    }
  }
}
