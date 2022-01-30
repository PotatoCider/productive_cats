import 'package:flutter/material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
      ),
      drawer: const NavigationDrawer(DrawerItems.leaderboard),
      body: const Text('Leaderboard'), // TODO: implement leaderboard
    );
  }
}
