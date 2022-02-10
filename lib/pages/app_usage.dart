import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:productive_cats/providers/app_usages.dart';
import 'package:productive_cats/providers/daily_updater.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:productive_cats/widgets/bottom_nav_bar.dart';
import 'package:productive_cats/widgets/coin_display.dart';
import 'package:productive_cats/widgets/format_text.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/widgets/percentage_bar.dart';
import 'package:provider/provider.dart';
import 'package:usage_stats/usage_stats.dart';

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
    if (!(await UsageStats.checkUsagePermission() ?? false)) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Allow App Usage Permission'),
            content: const Text(
                'In order to use app usages, please allow Productive Cats to get your application usage.'),
            actions: [
              TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await UsageStats.grantUsagePermission();
                  },
                  child: const Text('OK')),
            ],
          );
        },
      );
    } else {
      if (!usages.fetched) await usages.fetch();
      context.read<DailyUpdater>().update().then((updated) {
        if (updated) Utils.log('updated');
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      init();
    }
  }

  Future<void> _selectPeriod() async {
    DateTime start, end;
    var usages = context.read<AppUsages>();

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: usages.selected.start,
      helpText: 'Pick a start date',
      firstDate: DateTime(2010),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    start = picked;
    picked = await showDatePicker(
      context: context,
      initialDate: usages.selected.end,
      helpText: 'Pick an end date',
      firstDate: start,
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    end = picked;
    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      Utils.showSnackBar(context, 'Please pick 2 different dates');
      return;
    }

    usages.selected = AppUsagePeriod(start: start, end: end);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavBar(0),
      drawer: const NavigationDrawer(DrawerItems.usage),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectPeriod,
        child: const Icon(Icons.calendar_today),
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
    if (sel.custom) dropdown.add(null);
    var isNeg = usages.yesterday.offlineDuration.isNegative;
    return FlexibleSpaceBar(
      title: Row(
        children: [
          const Text('App Usage'),
          const SizedBox(width: 8),
          DropdownButton(
            iconSize: 18,
            value: sel.custom ? null : sel,
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
                FormatText(
                  ' ${isNeg ? '0' : '+' + (usages.yesterday.offlineDuration.inMinutes / 60.0).round().toString()}',
                  size: 20,
                  color: isNeg ? null : Colors.green,
                  bold: !isNeg,
                  // softWrap: false,
                ),
              const FormatText('/day'),
            ],
          ),
          const SizedBox(width: 32),
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
