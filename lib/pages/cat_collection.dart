import 'package:flutter/material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/widgets/coin_display.dart';

class CatCollectionPage extends StatelessWidget {
  const CatCollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleWithCoinDisplay('Cat Collection'),
      ),
      drawer: const NavigationDrawer(DrawerItems.collection),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          ...List.generate(
            8,
            (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Mr Fluff'),
                const SizedBox(height: 4),
                const Flexible(child: const Placeholder()),
                Row(
                  children: const [
                    Text('LVL 90'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ), // TODO: implement Cat Collection
    );
  }
}
