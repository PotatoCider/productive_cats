import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';

class BuddyPage extends StatefulWidget {
  const BuddyPage({Key? key}) : super(key: key);

  @override
  _BuddyPageState createState() => _BuddyPageState();
}

class _BuddyPageState extends State<BuddyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Buddy'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.buddy),
      body: const Text('Your Buddy'), // TODO: implement your buddy
    );
  }
}
