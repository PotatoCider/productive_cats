import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.settings),
      body: const Text('Settings'), // TODO: implement Settings
    );
  }
}
