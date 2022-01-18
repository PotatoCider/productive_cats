import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';

class ProductiveBuddyScreen extends StatefulWidget {
  const ProductiveBuddyScreen({Key? key}) : super(key: key);

  @override
  _ProductiveBuddyScreenState createState() => _ProductiveBuddyScreenState();
}

class _ProductiveBuddyScreenState extends State<ProductiveBuddyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brr'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.home),
      body: const Text('Productive Buddy'),
    );
  }
}
