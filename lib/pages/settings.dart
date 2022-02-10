import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:productive_cats/providers/user_info.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:productive_cats/widgets/coin_display.dart';
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          MaterialButton(
            minWidth: 64,
            child: const Text('Yes'),
            onPressed: () => context.read<UserInfo>().logout(),
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
        title: const TitleWithCoinDisplay('Settings'),
      ),
      drawer: const NavigationDrawer(DrawerItems.settings),
      body: ValueListenableBuilder<Box<String>>(
        valueListenable: box.listenable(),
        builder: (context, box, child) {
          var isDarkMode = box.get('dark_mode', defaultValue: '1') == '1';
          var isDevMode = box.get('dev_mode', defaultValue: '0') == '1';
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
              const SettingsHeading('Developer', color: Colors.grey),
              ListTile(
                leading: const Icon(Icons.developer_mode, color: Colors.grey),
                title: FormatText('Developer Mode ${isDevMode ? 'on' : 'off'}',
                    color: Colors.grey),
                trailing: Checkbox(
                  value: isDevMode,
                  onChanged: (checked) =>
                      box.put('dev_mode', checked ?? false ? '1' : '0'),
                  activeColor: Colors.blue,
                ),
              ),
              if (isDevMode) ...[
                ListTile(
                  leading: const Icon(Icons.money),
                  title: const FormatText(
                    'Give me coins',
                  ),
                  onTap: () => context.read<Coins>().coins += 100,
                  onLongPress: () => context.read<Coins>().coins += 1000,
                ),
                ListTile(
                  leading: const Icon(Icons.timelapse),
                  title: Row(
                    children: [
                      const Text('Holding + time travels '),
                      const SizedBox(width: 4),
                      Expanded(
                        child: TextFormField(
                          initialValue:
                              box.get('time_travel', defaultValue: '1'),
                          keyboardType: TextInputType.number,
                          onFieldSubmitted: (value) {
                            box.put('time_travel', value);
                            Utils.showSnackBar(context, 'Set to $value day(s)');
                          },
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text('day(s)'),
                    ],
                  ),
                ),
              ]
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
    this.color,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return FormatText(
      text,
      weight: FontWeight.bold,
      size: 16,
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }
}
