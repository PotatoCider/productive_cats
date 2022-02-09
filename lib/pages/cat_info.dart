import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:productive_cats/widgets/hero_material.dart';
import 'package:productive_cats/widgets/login_buttons.dart';
import 'package:productive_cats/widgets/percentage_bar.dart';
import 'package:productive_cats/widgets/format_text.dart';
import 'package:provider/provider.dart';

class CatInfoPage extends StatelessWidget {
  const CatInfoPage(this.index, {Key? key}) : super(key: key);

  final int index;

  void _showDeleteDialog(BuildContext context, Cat cat) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sell ${cat.name}?'),
        content: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text:
                      'Are you sure you want to sell ${cat.name}\nfor ${cat.price.toInt()} '),
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
            onPressed: () async {
              context.read<Coins>().coins += cat.price;
              Navigator.of(context).pop();
              context.pop();
              await Future<void>.delayed(const Duration(seconds: 1));
              await cat.delete();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70),
        child: ValueListenableBuilder<Box<Cat>>(
          valueListenable: Cat.catbox.listenable(),
          builder: (context, box, child) {
            var cat = box.getAt(index);
            if (cat == null) return const SizedBox.shrink();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                FormatText(
                  cat.name,
                  weight: FontWeight.bold,
                  size: 32,
                  hero: true,
                ),
                const SizedBox(height: 8),
                Hero(
                  tag: cat.imagePath,
                  child: Container(
                    height: 256,
                    width: 256,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      image: DecorationImage(
                        image: FileImage(File(cat.imagePath)),
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
                      const SizedBox(width: 4),
                      const Tooltip(
                        triggerMode: TooltipTriggerMode.tap,
                        showDuration: Duration(seconds: 10),
                        padding: EdgeInsets.all(8),
                        message:
                            'Try spending less time on your phone to gain exp.',
                        child: Icon(Icons.help),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
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
                const Spacer(),
                PaddedButton(
                  color: const Color.fromARGB(255, 189, 24, 12),
                  onPressed: () => _showDeleteDialog(context, cat),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 20),
                      children: [
                        TextSpan(text: 'Sell ${cat.name} for '),
                        TextSpan(text: '${cat.price.toInt()} '),
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
            );
          },
        ),
      ),
    );
  }
}
