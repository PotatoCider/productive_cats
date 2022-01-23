import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  void Function() navigateRoute(String route) {
    return () {
      Navigator.pop(context); // close drawer
      context.go(route);
    };
  }

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
                  onTap: navigateRoute('/buddy'),
                ),
                ListTile(
                  leading: const Icon(Icons.collections),
                  title: const Text('Your Cat Collection'),
                  selected: widget._selected == DrawerItems.collection,
                  onTap: navigateRoute('/collection'),
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Market'),
                  selected: widget._selected == DrawerItems.market,
                  onTap: navigateRoute('/market'),
                ),
                ListTile(
                  leading: const Icon(Icons.price_change),
                  title: const Text('Trading'),
                  selected: widget._selected == DrawerItems.trading,
                  onTap: navigateRoute('/trading'),
                ),
                ListTile(
                  leading: const Icon(Icons.show_chart),
                  title: const Text('Statistics'),
                  selected: widget._selected == DrawerItems.statistics,
                  onTap: navigateRoute('/statistics'),
                ),
                ListTile(
                  leading: const Icon(Icons.leaderboard),
                  title: const Text('Leaderboard'),
                  selected: widget._selected == DrawerItems.leaderboard,
                  onTap: navigateRoute('/leaderboard'),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: widget._selected == DrawerItems.settings,
            onTap: navigateRoute('/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            selected: widget._selected == DrawerItems.logout,
            onTap: navigateRoute('/login'),
          ),
        ],
      ),
    );
  }
}
