import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/widgets/coin_display.dart';

class BuddyPage extends StatelessWidget {
  const BuddyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleWithCoinDisplay('Your Buddy'),
      ),
      drawer: const NavigationDrawer(DrawerItems.buddy),
      body: Padding(
        padding: const EdgeInsets.all(64),
        child: ValueListenableBuilder(
          valueListenable: Cat.catbox!.listenable(),
          builder: (context, box, child) => Column(
            children: [
              const Text(
                'Mr Marshmallow',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 16),
              const Placeholder(
                fallbackHeight: 256,
                fallbackWidth: 256,
              ),
              const SizedBox(height: 32),
              Column(
                children: const [
                  Text(
                    'Happiness',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BuddyWidget extends StatelessWidget {
  const BuddyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
