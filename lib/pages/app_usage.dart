import 'dart:ui';

import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:productive_cats/providers/app_usages.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:productive_cats/widgets/coin_display.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/widgets/percentage_bar.dart';
import 'package:provider/provider.dart';

class AppUsagePage extends StatelessWidget {
  const AppUsagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      drawer: NavigationDrawer(DrawerItems.appusage),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // title: const Text('App Usage'),
            floating: true,
            snap: true,
            expandedHeight: 256,
            flexibleSpace: AppUsageSpaceBar(),
          ),
          AppUsageList(),
        ],
      ),
    );
  }
}

class AppUsageList extends StatelessWidget {
  const AppUsageList({
    Key? key,
  }) : super(key: key);

  String categoryText(ApplicationCategory cat) {
    var text = cat.name;
    if (text == 'undefined') text = 'other';
    text = Utils.capsFirst(text);
    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppUsages>(
      builder: (context, usages, child) {
        var names = usages.durations.keys.toList();
        names.sort(
            (n1, n2) => usages.durations[n2]!.compareTo(usages.durations[n1]!));
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var name = names[index];
              var app = usages.apps[name];
              var duration = usages.durations[name]!;
              if (app == null) return const SizedBox.shrink();

              return ListTile(
                leading: Image.memory(app.icon),
                title: Text(app.appName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                        '${categoryText(app.category)} · ${_formatDuration(duration)}'),
                    PercentageBar(
                        duration.inSeconds / usages.totalDuration.inSeconds),
                  ],
                ),
              );
            },
            childCount: names.length,
          ),
          // padding: const EdgeInsets.only(top: 8),
        );
      },
    );
  }
}

class AppUsageSpaceBar extends StatelessWidget {
  const AppUsageSpaceBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      title: const Text('App Usage'),
      background: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CoinDisplay(
            scale: 2,
            additional: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: ' +1',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: '/day')
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Consumer<AppUsages>(
            builder: (context, usages, child) => RichText(
              text: TextSpan(children: [
                const TextSpan(text: 'Total Usage:\n'),
                TextSpan(
                  text: _formatDuration(usages.totalDuration),
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration dur) {
  var hours = dur.inHours == 0 ? '' : '${dur.inHours}h ';
  var mins = dur.inMinutes == 0 ? '' : '${dur.inMinutes % 60}m ';
  var secs = dur.inSeconds == 0 ? '' : '${dur.inSeconds % 60}s';

  return '$hours$mins${hours.isEmpty ? secs : ''}';
}