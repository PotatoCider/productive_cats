import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/widgets/hero_material.dart';
import 'package:productive_cats/widgets/percentage_bar.dart';
import 'package:productive_cats/widgets/format_text.dart';

class CatInfoPage extends StatelessWidget {
  const CatInfoPage(this.cat, {Key? key}) : super(key: key);

  final Cat cat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cat Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: PercentageBar(
                      cat.experience / cat.maxExperience,
                      minHeight: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Tooltip(
                    triggerMode: TooltipTriggerMode.tap,
                    showDuration: const Duration(seconds: 10),
                    padding: const EdgeInsets.all(8),
                    message:
                        '${cat.name} gains the most experience from spending less time in the _ apps category.',
                    child: const Icon(Icons.help),
                  ),
                ],
              ),
            ),
            // Text(
            //   'Max Happiness: ${cat.maxHappiness}',
            //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            // ),
            // // PercentageBar(cat.happiness / cat.maxHappiness),
            // Text('FIT: ${cat.fitness} / ${cat.maxFitness}'),
          ],
        ),
      ),
    );
  }
}
