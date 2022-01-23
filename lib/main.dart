import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';
import 'package:productive_cats/pages/buddy.dart';
import 'package:productive_cats/pages/cat_collection.dart';
import 'package:productive_cats/pages/leaderboard.dart';

import 'package:productive_cats/pages/login.dart';
import 'package:productive_cats/pages/market.dart';
import 'package:productive_cats/pages/settings.dart';
import 'package:productive_cats/pages/statistics.dart';
import 'package:productive_cats/pages/trading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productive Cats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/buddy': (context) => const BuddyPage(),
        '/collection': (context) => const CatCollectionPage(),
        '/market': (context) => const MarketPage(),
        '/trading': (context) => const TradingPage(),
        '/statistics': (context) => const StatisticsPage(),
        '/leaderboard': (context) => const LeaderboardPage(),
        '/settings': (context) => const SettingsPage(),
        '/logout': (context) => const LoginPage(),
      },
    );
  }
}
