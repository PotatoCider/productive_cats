import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:productive_cats/widgets/format_text.dart';

enum DrawerItems {
  none,
  buddy,
  collection,
  catbox,
  market,
  usage,
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
      context.push(route);
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
                DrawerHeader(
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    fit: StackFit.expand,
                    children: [
                      ImageFiltered(
                        imageFilter: ImageFilter.blur(
                          sigmaY: 5,
                          sigmaX: 5,
                          tileMode: TileMode.clamp,
                        ),
                        child: Image.asset(
                          'images/cat.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      const FormatText(
                        'Productive Cats',
                        bold: true,
                      ),
                    ],
                  ),
                ),
                // ListTile(
                //   leading: const Icon(Icons.home),
                //   title: const Text('Productive Cats'),
                //   selected: _selected == DrawerItems.buddy,
                //   onTap: navigateRoute(context, '/buddy'),
                // ),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Your Cat Collection'),
                  selected: _selected == DrawerItems.collection,
                  onTap: navigateRoute(context, '/cats'),
                ),
                // ListTile(
                //   leading: const Icon(Icons.add_box),
                //   title: const Text('Cat Box'),
                //   selected: _selected == DrawerItems.catbox,
                //   onTap: navigateRoute(context, '/catbox'),
                // ),
                ListTile(
                  leading: const Icon(Icons.show_chart),
                  title: const Text('App Usage'),
                  selected: _selected == DrawerItems.usage,
                  onTap: navigateRoute(context, '/usage'),
                ),
                ListTile(
                  leading: const Icon(Icons.compare_arrows),
                  title: const Text('Market'),
                  selected: _selected == DrawerItems.market,
                  onTap: navigateRoute(context, '/market'),
                ),
                // ListTile(
                //   leading: const Icon(Icons.leaderboard),
                //   title: const Text('Leaderboard'),
                //   selected: _selected == DrawerItems.leaderboard,
                //   onTap: navigateRoute(context, '/leaderboard'),
                // ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            selected: _selected == DrawerItems.settings,
            onTap: navigateRoute(context, '/settings'),
          ),
          // ListTile(
          //   leading: const Icon(Icons.logout),
          //   title: const Text('Logout'),
          //   // selected: _selected == DrawerItems.logout,
          //   onTap: () => context.read<UserInfo>().logout(),
          // ),
        ],
      ),
    );
  }
}
