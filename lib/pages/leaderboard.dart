import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.leaderboard),
      body: const Text('Leaderboard'), // TODO: implement leaderboard
    );
  }
}
