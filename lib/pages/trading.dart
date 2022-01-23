import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';

class TradingPage extends StatefulWidget {
  const TradingPage({Key? key}) : super(key: key);

  @override
  _TradingPageState createState() => _TradingPageState();
}

class _TradingPageState extends State<TradingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trading'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.trading),
      body: const Text('Trading'), // TODO: implement Trading
    );
  }
}
