import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:productive_cats/drawer.dart';
import 'package:productive_cats/pages/buddy.dart';
import 'package:productive_cats/pages/cat_collection.dart';
import 'package:productive_cats/pages/leaderboard.dart';

import 'package:productive_cats/pages/login.dart';
import 'package:productive_cats/pages/market.dart';
import 'package:productive_cats/pages/register.dart';
import 'package:productive_cats/pages/settings.dart';
import 'package:productive_cats/pages/statistics.dart';
import 'package:productive_cats/pages/trading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Productive Cats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
    );
  }

  final _router = GoRouter(
    initialLocation: '/buddy',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/buddy',
        builder: (context, state) => const BuddyPage(),
      ),
      GoRoute(
        path: '/collection',
        builder: (context, state) => const CatCollectionPage(),
      ),
      GoRoute(
        path: '/market',
        builder: (context, state) => const MarketPage(),
      ),
      GoRoute(
        path: '/trading',
        builder: (context, state) => const TradingPage(),
      ),
      GoRoute(
        path: '/statistics',
        builder: (context, state) => const StatisticsPage(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
