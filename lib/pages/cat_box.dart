import 'package:flutter/material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';

class CatBoxPage extends StatelessWidget {
  const CatBoxPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Box'),
      ),
      drawer: const NavigationDrawer(DrawerItems.catbox),
      body: const Text('Cat Box'),
    );
  }
}
