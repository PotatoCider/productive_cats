import 'package:flutter/material.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:provider/provider.dart';

class TitleWithCoinDisplay extends StatelessWidget {
  const TitleWithCoinDisplay(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        const CoinDisplay(),
      ],
    );
  }
}

class CoinDisplay extends StatelessWidget {
  const CoinDisplay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 4, 4),
      margin: const EdgeInsets.only(right: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).splashColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/coin.png',
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Consumer<Coins>(
              builder: (context, coins, child) => Text(coins.value.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
