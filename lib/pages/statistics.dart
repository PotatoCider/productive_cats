import 'package:flutter/material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      drawer: const NavigationDrawer(DrawerItems.statistics),
      body: const Text('Statistics'), // TODO: implement Statistics
    );
  }
}
