import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.market),
      body: const Text('Market'),
    );
  }
}
