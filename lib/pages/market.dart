import 'package:flutter/material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
      ),
      drawer: const NavigationDrawer(DrawerItems.market),
      body: const Text('Market'),
    );
  }
}
