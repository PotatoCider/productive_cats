import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:productive_cats/providers/user_info.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:productive_cats/widgets/coin_display.dart';
import 'package:productive_cats/widgets/hero_material.dart';
import 'package:productive_cats/widgets/login_buttons.dart';
import 'package:productive_cats/widgets/percentage_bar.dart';
import 'package:productive_cats/widgets/format_text.dart';
import 'package:provider/provider.dart';

class CatInfoPage extends StatelessWidget {
  const CatInfoPage(
    this._cat, {
    Key? key,
  }) : super(key: key);

  final Cat? _cat;

  void _showDialog(BuildContext context, Cat cat, bool buy) {
    var coins = context.read<Coins>();
    if (buy && coins.coins < cat.price) {
      Utils.showSnackBar(
          context, 'You don\'t have enough coins to buy ${cat.name}');
      return;
    }
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${buy ? 'Buy' : 'Sell'} ${cat.name}?'),
        content: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text:
                      'Are you sure you want to ${buy ? 'buy' : 'sell'} ${cat.name}\nfor ${cat.price.round()} '),
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
            onPressed: () => Navigator.of(context).pop(),
          ),
          MaterialButton(
            minWidth: 64,
            child: const Text('Yes'),
            onPressed: buy
                ? () async {
                    coins.coins -= cat.price;
                    var buyFuture = cat.buyFromMarket();

                    Navigator.of(context).pop();
                    await Future<void>.delayed(
                        const Duration(milliseconds: 300));
                    await buyFuture;
                    context.go('/cats');
                    await cat.removeFromMarket();
                  }
                : () async {
                    var userInfo = context.read<UserInfo>();
                    coins.coins += cat.price;
                    var sellFuture = cat.sellToMarket(userInfo);
                    Navigator.of(context).pop();

                    // wait for animation
                    await Future<void>.delayed(
                        const Duration(milliseconds: 300));
                    await sellFuture;
                    await Future<void>.delayed(
                        const Duration(milliseconds: 300)); // wait for network
                    context.go('/market');
                    await cat.removeFromDatabase();
                  },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var cat = _cat!;
    var isMarket = cat.imageBytes != null;
    var canAfford = !isMarket || context.watch<Coins>().coins >= cat.price;
    return Scaffold(
      appBar: AppBar(
        title: Text(isMarket ? 'Purchase Cat' : 'Cat Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            FormatText(
              cat.name,
              weight: FontWeight.bold,
              size: 32,
              heroTag: cat.id + '_name',
            ),
            const SizedBox(height: 8),
            Center(
              child: Hero(
                tag: cat.id + '_image',
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    image: isMarket
                        ? DecorationImage(image: MemoryImage(cat.imageBytes!))
                        : DecorationImage(
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
                    'LEVEL ${cat.level}',
                    weight: FontWeight.bold,
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Tooltip(
                      triggerMode: TooltipTriggerMode.tap,
                      padding: const EdgeInsets.all(8),
                      message:
                          'EXP: ${cat.experience.round()} / ${cat.maxExperience.toInt()}',
                      child: PercentageBar(
                        cat.experience / cat.maxExperience,
                        minHeight: 16,
                      ),
                    ),
                  ),
                  // const SizedBox(width: 16)
                  if (!isMarket) ...[
                    const SizedBox(width: 4),
                    const Tooltip(
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration: Duration(seconds: 10),
                      padding: EdgeInsets.all(8),
                      message:
                          'Try spending less time on your phone to gain exp.',
                      child: Icon(Icons.help),
                    ),
                  ]
                ],
              ),
            ),
            const SizedBox(height: 8),
            if (!isMarket)
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 18),
                  children: [
                    const TextSpan(text: 'You\'ve earned '),
                    TextSpan(
                      text: '${cat.todayExp.round()} EXP',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: ' today'),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            if (isMarket)
              Row(
                children: [
                  const FormatText('Sold by ', size: 20),
                  FormatText(cat.soldBy!, size: 20, bold: true),
                ],
              ),
            const Spacer(),
            PaddedButton(
              color: isMarket ? null : const Color.fromARGB(255, 189, 24, 12),
              onPressed: () => _showDialog(context, cat, isMarket),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 20),
                  children: [
                    TextSpan(
                        text: '${isMarket ? 'Buy' : 'Sell'} ${cat.name} for '),
                    TextSpan(
                      text: '${cat.price.round()} ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: canAfford ? null : Colors.red,
                      ),
                    ),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Image.asset(
                        'images/coin.png',
                        height: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
