import 'dart:ui';

import 'package:app_usage/app_usage.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:productive_cats/providers/app_usages.dart';
import 'package:productive_cats/providers/daily_updater.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:productive_cats/widgets/bottom_nav_bar.dart';
import 'package:productive_cats/widgets/coin_display.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/widgets/percentage_bar.dart';
import 'package:provider/provider.dart';

class AppUsagePage extends StatefulWidget {
  const AppUsagePage({Key? key}) : super(key: key);

  @override
  State<AppUsagePage> createState() => _AppUsagePageState();
}

class _AppUsagePageState extends State<AppUsagePage>
    with WidgetsBindingObserver {
  late AppUsages usages;

  @override
  void initState() {
    super.initState();
    usages = context.read<AppUsages>();
    WidgetsBinding.instance!.addObserver(this);
    init();
  }

  void init() async {
    if (!usages.fetched) await usages.fetch();
    context.read<DailyUpdater>().update().then((updated) {
      if (updated) Utils.log('updated');
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      usages.fetch();
    }
  }

  Future<void> _selectPeriod() async {
    DateTime start, end;
    var usages = context.read<AppUsages>();

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: usages.selected.start,
      helpText: 'Pick a start date',
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked == null) return;
    start = picked;
    picked = await showDatePicker(
      context: context,
      initialDate: usages.selected.end,
      helpText: 'Pick an end date',
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked == null) return;
    end = picked;

    usages.selected = AppUsagePeriod(start: start, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(0),
      drawer: const NavigationDrawer(DrawerItems.usage),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectPeriod,
        child: const Icon(Icons.edit_calendar),
      ),
      body: const CustomScrollView(
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
        var selected = usages.selected;
        if (!selected.fetched) {
          return const SliverList(
            delegate: SliverChildListDelegate.fixed([
              AspectRatio(
                aspectRatio: 1,
                child: Center(child: CircularProgressIndicator()),
              ),
            ]),
          );
        }
        var names = selected.appNamesByUsage;

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              var name = names[index];
              var app = usages.apps[name];
              var duration = selected.durations[name]!;

              if (app == null) return const SizedBox();
              return ListTile(
                leading: Image.memory(app.icon),
                title: Text(app.appName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                        '${categoryText(app.category)} · ${_formatDuration(duration)}'),
                    PercentageBar(
                        duration.inSeconds / selected.totalDuration.inSeconds),
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
    var usages = context.watch<AppUsages>();
    var sel = usages.selected;
    List<AppUsagePeriod?> dropdown = [
      usages.yesterday,
      usages.lastMonth,
      usages.lastYear
    ];
    if (usages.selected.custom) dropdown.add(null);

    return FlexibleSpaceBar(
      title: Row(
        children: [
          const Text('App Usage'),
          const SizedBox(width: 8),
          DropdownButton(
            iconSize: 18,
            value: usages.selected.custom ? null : usages.selected,
            items: dropdown
                .map((period) => DropdownMenuItem(
                      child: Text(
                        period?.text ?? 'custom',
                        style: const TextStyle(fontSize: 12),
                      ),
                      value: period,
                    ))
                .toList(),
            onChanged: (AppUsagePeriod? period) {
              context.read<AppUsages>().selected = period!;
            },
          )
        ],
      ),
      background: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CoinDisplay(
            scale: 1.5,
            additional: [
              if (usages.fetched)
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: ' +${usages.yesterday.offlineDuration.inHours}',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(text: '/day')
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          if (usages.fetched)
            RichText(
              text: TextSpan(children: [
                const TextSpan(text: 'Total Usage:\n'),
                TextSpan(
                  text: _formatDuration(sel.totalDuration),
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.headline5?.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(text: '\n' + sel.text),
              ]),
            ),
        ],
      ),
    );
  }
}

String _formatDuration(Duration dur) {
  var days = dur.inDays == 0 ? '' : '${dur.inDays}d ';
  var hours = dur.inHours == 0 ? '' : '${dur.inHours % 24}h ';
  var mins = dur.inMinutes == 0 ? '' : '${dur.inMinutes % 60}m ';
  var secs = dur.inSeconds == 0 ? '' : '${dur.inSeconds % 60}s';

  return '$days$hours$mins${hours.isEmpty ? secs : ''}';
}
