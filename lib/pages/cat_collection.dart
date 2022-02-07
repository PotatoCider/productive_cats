import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/widgets/hero_material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/widgets/coin_display.dart';
import 'package:productive_cats/widgets/format_text.dart';
import 'package:productive_cats/widgets/percentage_bar.dart';

class CatCollectionPage extends StatelessWidget {
  const CatCollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleWithCoinDisplay('Cat Collection'),
      ),
      drawer: const NavigationDrawer(DrawerItems.collection),
      floatingActionButton: const FloatingActionButton(
        tooltip: 'Generate Cat',
        onPressed: Cat.generate,
        child: Icon(Icons.add),
      ),
      body: ValueListenableBuilder<Box<Cat>>(
        valueListenable: Cat.catbox.listenable(),
        builder: (context, box, child) {
          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.76,
            children: List.generate(
                box.length, (index) => CatGridItem(box.getAt(index)!, index)),
          );
        },
      ),
    );
  }
}

class CatGridItem extends StatelessWidget {
  const CatGridItem(this.cat, this.index, {Key? key}) : super(key: key);

  final Cat cat;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        child: InkWell(
          // onLongPress: cat.delete,
          onTap: () => context.go('/cats/$index'),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormatText(
                cat.name,
                weight: FontWeight.bold,
                hero: true,
              ),
              const SizedBox(height: 8),
              Hero(
                tag: cat.imagePath,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                          image: FileImage(File(cat.imagePath))),
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
// TODO: store locally using sqlfite
