import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:productive_cats/providers/cat_market.dart';
import 'package:productive_cats/widgets/bottom_nav_bar.dart';
import 'package:productive_cats/widgets/coin_display.dart';
import 'package:productive_cats/widgets/format_text.dart';
import 'package:productive_cats/widgets/hero_material.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:provider/provider.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  late CatMarket catMarket;
  @override
  void initState() {
    super.initState();
    catMarket = context.read<CatMarket>();
    if (!catMarket.fetched) catMarket.fetch();
    catMarket.subscribe();
  }

  @override
  Widget build(BuildContext context) {
    var market = context.watch<CatMarket>();
    return Scaffold(
      appBar: AppBar(
        title: const TitleWithCoinDisplay('Market'),
      ),
      bottomNavigationBar: const BottomNavBar(2),
      drawer: const NavigationDrawer(DrawerItems.market),
      body: market.fetched
          ? GridView.count(
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
              children: List.generate(
                market.cats.length,
                (index) => CatMarketItem(index),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

class CatMarketItem extends StatelessWidget {
  const CatMarketItem(this.index, {Key? key}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    var market = context.read<CatMarket>();
    var cat = market.cats[index];
    if (index == -1) {
      return const Center(child: CircularProgressIndicator());
    }
    return Material(
      child: Ink(
        child: InkWell(
          onTap: () => context.push('/market/$index'),
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
                        image: MemoryImage(cat.imageBytes!),
                      ),
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 8),
              HeroMaterial(
                tag: cat.id + '_level',
                child: Row(
                  children: [
                    FormatText(
                      'LVL ${cat.level}',
                      weight: FontWeight.bold,
                    ),
                    const Spacer(),
                    CoinDisplay(
                      value: cat.price,
                      scale: 0.8,
                      margin: null,
                      checkAfford: true,
                    ),
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
