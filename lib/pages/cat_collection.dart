import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:productive_cats/providers/daily_updater.dart';
import 'package:productive_cats/utils/settings.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:productive_cats/widgets/bottom_nav_bar.dart';
import 'package:productive_cats/widgets/hero_material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/widgets/coin_display.dart';
import 'package:productive_cats/widgets/format_text.dart';
import 'package:productive_cats/widgets/percentage_bar.dart';
import 'package:provider/provider.dart';

class CatCollectionPage extends StatefulWidget {
  const CatCollectionPage({Key? key}) : super(key: key);

  @override
  State<CatCollectionPage> createState() => _CatCollectionPageState();
}

class _CatCollectionPageState extends State<CatCollectionPage> {
  final ScrollController _scrollController = ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  void _scrollEnd() async {
    // ignore: invalid_use_of_protected_member
    _scrollController.position.saveOffset();
    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void _showBuyDialog(BuildContext context) {
    var coins = context.read<Coins>();
    if (coins.coins < 100) {
      Utils.showSnackBar(context, 'You don\'t have 100 coins to buy a cat.');
      return;
    }
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Buy Cat for 100 coins?'),
        content: RichText(
          text: TextSpan(
            style: TextStyle(
                color: Settings.box.get('dark_mode') == '1'
                    ? Colors.white
                    : Colors.black),
            children: [
              const TextSpan(
                  text: 'Are you sure you want to buy a random cat\nfor 100 '),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Image.asset(
                  'images/coin.png',
                  height: 14,
                ),
              ),
              const TextSpan(text: ' ?'),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            minWidth: 64,
            child: const Text('No'),
            onPressed: Navigator.of(context).pop,
          ),
          MaterialButton(
            minWidth: 64,
            child: const Text('Yes'),
            onPressed: () async {
              Navigator.of(context).pop();
              var future = Cat.generate();
              setState(() => generating = true);
              coins.coins -= 100;
              WidgetsBinding.instance!
                  .addPostFrameCallback((_) => _scrollEnd());
              await future;
              setState(() => generating = false);
            },
          ),
        ],
      ),
    );
  }

  bool generating = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleWithCoinDisplay('Cat Collection'),
      ),
      bottomNavigationBar: const BottomNavBar(1),
      drawer: const NavigationDrawer(DrawerItems.collection),
      floatingActionButton: InkWell(
        splashColor: Colors.blue,
        onLongPress: () {
          var box = Hive.box<String>('settings');
          if (box.get('dev_mode') == '1') {
            var days = int.tryParse(box.get('time_travel') ?? '1');
            context.read<DailyUpdater>().update(true, days ?? 1);
          }
        },
        child: FloatingActionButton(
          onPressed: generating ? () {} : () => _showBuyDialog(context),
          child: generating
              ? const CircularProgressIndicator()
              : const Icon(Icons.add),
        ),
      ),
      body: ValueListenableBuilder<Box<Cat>>(
        valueListenable: Cat.catbox!.listenable(),
        builder: (context, box, child) {
          return GridView.count(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.76,
            children: List.generate(
              generating ? box.length + 1 : box.length,
              (index) => index == box.length
                  ? const CatGridItem(-1)
                  : CatGridItem(index),
            ),
          );
        },
      ),
    );
  }
}

class CatGridItem extends StatelessWidget {
  const CatGridItem(this.index, {Key? key}) : super(key: key);

  final int index;
  @override
  Widget build(BuildContext context) {
    if (index == -1) {
      return const Center(child: CircularProgressIndicator());
    }
    var cat = Cat.catbox!.getAt(index)!;
    return Material(
      child: Ink(
        child: InkWell(
          // onLongPress: cat.delete,
          onTap: () => context.push('/cats/$index'),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormatText(
                cat.name,
                weight: FontWeight.bold,
                heroTag: cat.id + '_name',
              ),
              const SizedBox(height: 8),
              Hero(
                tag: cat.id + '_image',
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                          image: FileImage(File(cat.imagePath!))),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              HeroMaterial(
                tag: cat.id + '_level',
                child: Row(
                  children: [
                    FormatText(
                      'LVL ${cat.level}',
                      weight: FontWeight.bold,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: PercentageBar(cat.experience / cat.maxExperience),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
