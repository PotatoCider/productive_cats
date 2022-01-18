import 'package:flutter/material.dart';

enum DrawerItems {
  home,
  collection,
  market,
  trading,
  statistics,
  leaderboard,
  settings
}

class ProductiveCatsDrawer extends StatelessWidget {
  const ProductiveCatsDrawer(this._selected, {Key? key}) : super(key: key);

  final DrawerItems _selected;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                  ),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Productive Cats'),
                  selected: _selected == DrawerItems.home,
                ),
                ListTile(
                  leading: const Icon(Icons.collections),
                  title: const Text('Your Cat Collection'),
                  selected: _selected == DrawerItems.collection,
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Market'),
                  selected: _selected == DrawerItems.market,
                ),
                ListTile(
                  leading: const Icon(Icons.price_change),
                  title: const Text('Trading'),
                  selected: _selected == DrawerItems.trading,
                ),
                ListTile(
                  leading: const Icon(Icons.show_chart),
                  title: const Text('Statistics'),
                  selected: _selected == DrawerItems.statistics,
                ),
                ListTile(
                  leading: const Icon(Icons.leaderboard),
                  title: const Text('Leaderboard'),
                  selected: _selected == DrawerItems.leaderboard,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: _selected == DrawerItems.settings,
          ),
        ],
      ),
    );
  }
}
