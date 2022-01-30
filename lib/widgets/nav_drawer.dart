import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:productive_cats/providers/user_info.dart';
import 'package:provider/provider.dart';

enum DrawerItems {
  none,
  buddy,
  collection,
  market,
  trading,
  statistics,
  leaderboard,
  settings,
  logout,
  register,
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer(this._selected, {Key? key}) : super(key: key);

  void Function() navigateRoute(BuildContext context, String route) {
    return () {
      Navigator.pop(context); // close drawer
      context.go(route);
    };
  }

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
                  decoration: BoxDecoration(color: Colors.grey),
                  child: Text('Drawer Header'),
                ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Productive Cats'),
                  selected: _selected == DrawerItems.buddy,
                  onTap: navigateRoute(context, '/buddy'),
                ),
                ListTile(
                  leading: const Icon(Icons.collections),
                  title: const Text('Your Cat Collection'),
                  selected: _selected == DrawerItems.collection,
                  onTap: navigateRoute(context, '/collection'),
                ),
                ListTile(
                  leading: const Icon(Icons.shopping_cart),
                  title: const Text('Market'),
                  selected: _selected == DrawerItems.market,
                  onTap: navigateRoute(context, '/market'),
                ),
                ListTile(
                  leading: const Icon(Icons.price_change),
                  title: const Text('Trading'),
                  selected: _selected == DrawerItems.trading,
                  onTap: navigateRoute(context, '/trading'),
                ),
                ListTile(
                  leading: const Icon(Icons.show_chart),
                  title: const Text('Statistics'),
                  selected: _selected == DrawerItems.statistics,
                  onTap: navigateRoute(context, '/statistics'),
                ),
                ListTile(
                  leading: const Icon(Icons.leaderboard),
                  title: const Text('Leaderboard'),
                  selected: _selected == DrawerItems.leaderboard,
                  onTap: navigateRoute(context, '/leaderboard'),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: _selected == DrawerItems.settings,
            onTap: navigateRoute(context, '/settings'),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            // selected: _selected == DrawerItems.logout,
            onTap: () => context.read<UserInfo>().logout(),
          ),
        ],
      ),
    );
  }
}
