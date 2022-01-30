import 'package:flutter/material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/widgets/coin_display.dart';

class CatCollectionPage extends StatelessWidget {
  const CatCollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleWithCoinDisplay('Cat Collection'),
      ),
      drawer: const NavigationDrawer(DrawerItems.collection),
      body: const Text('Cat Collection'), // TODO: implement Cat Collection
    );
  }
}
