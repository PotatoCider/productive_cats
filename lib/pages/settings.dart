import 'package:flutter/material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: const NavigationDrawer(DrawerItems.settings),
      body: const Text('Settings'), // TODO: implement Settings
    );
  }
}
