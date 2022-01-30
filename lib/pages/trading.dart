import 'package:flutter/material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';

class TradingPage extends StatelessWidget {
  const TradingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trading'),
      ),
      drawer: const NavigationDrawer(DrawerItems.trading),
      body: const Text('Trading'), // TODO: implement Trading
    );
  }
}
