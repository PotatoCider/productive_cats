import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.statistics),
      body: const Text('Statistics'), // TODO: implement Statistics
    );
  }
}
