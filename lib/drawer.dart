import 'package:flutter/material.dart';

class ProductiveCatsDrawer extends StatefulWidget {
  const ProductiveCatsDrawer(this._selected, {Key? key}) : super(key: key);

  final DrawerItems _selected;

  @override
  State<ProductiveCatsDrawer> createState() => _ProductiveCatsDrawerState();
}

enum DrawerItems {
  buddy,
  collection,
  market,
  trading,
  statistics,
  leaderboard,
  settings,
  logout
}

class _ProductiveCatsDrawerState extends State<ProductiveCatsDrawer> {
  void Function() _onNavigateItem(String route) =>
      ModalRoute.of(context)?.settings.name == route
          ? () => Navigator.pop(context)
          : () => Navigator.popAndPushNamed(context, route);

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
                  selected: widget._selected == DrawerItems.buddy,
                  onTap: _onNavigateItem('/buddy'),
                ),
                ListTile(
                  leading: const Icon(Icons.collections),
                  title: const Text('Your Cat Collection'),
                  selected: widget._selected == DrawerItems.collection,
                  onTap: _onNavigateItem('/collection'),
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Market'),
                  selected: widget._selected == DrawerItems.market,
                  onTap: _onNavigateItem('/market'),
                ),
                ListTile(
                  leading: const Icon(Icons.price_change),
                  title: const Text('Trading'),
                  selected: widget._selected == DrawerItems.trading,
                  onTap: _onNavigateItem('/trading'),
                ),
                ListTile(
                  leading: const Icon(Icons.show_chart),
                  title: const Text('Statistics'),
                  selected: widget._selected == DrawerItems.statistics,
                  onTap: _onNavigateItem('/statistics'),
                ),
                ListTile(
                  leading: const Icon(Icons.leaderboard),
                  title: const Text('Leaderboard'),
                  selected: widget._selected == DrawerItems.leaderboard,
                  onTap: _onNavigateItem('/leaderboard'),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: widget._selected == DrawerItems.settings,
            onTap: _onNavigateItem('/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            selected: widget._selected == DrawerItems.logout,
            onTap: _onNavigateItem('/login'),
          ),
        ],
      ),
    );
  }
}
