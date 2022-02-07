import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/providers/app_usages.dart';
import 'package:productive_cats/providers/user_info.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/widgets/format_text.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          MaterialButton(
            minWidth: 64,
            child: const Text('No'),
            onPressed: Navigator.of(context).pop,
          ),
          MaterialButton(
            minWidth: 64,
            child: const Text('Yes'),
            onPressed: context.read<UserInfo>().logout,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var box = Hive.box<String>('settings');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      drawer: const NavigationDrawer(DrawerItems.settings),
      body: ValueListenableBuilder<Box<String>>(
        valueListenable: box.listenable(),
        builder: (context, box, child) {
          var isDarkMode = box.get('dark_mode', defaultValue: '1') == '1';
          return ListView(
            // padding: const EdgeInsets.all(8),
            children: [
              const Divider(),
              const SettingsHeading('Appearance'),
              ListTile(
                leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
                title: Text('Switch to ${isDarkMode ? "Light" : "Dark"} Mode'),
                onTap: () => box.put('dark_mode', isDarkMode ? '0' : '1'),
              ),
              const Divider(),
              const SettingsHeading('Account'),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const FormatText('Logout', color: Colors.red),
                onTap: () => _showLogoutDialog(context),
              ),
              const Divider(),
              const SettingsHeading('Developer'),
              ListTile(
                  leading: const Icon(Icons.developer_mode),
                  title: const FormatText('Simulate cat experience gain'),
                  onTap: () {
                    Cat.updateDailyUsage(context.read<AppUsages>());
                  }),
            ],
          );
        },
      ),
    );
  }
}

class SettingsHeading extends StatelessWidget {
  const SettingsHeading(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return FormatText(
      text,
      weight: FontWeight.bold,
      size: 16,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }
}
