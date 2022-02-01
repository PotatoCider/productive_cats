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
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text),
        const Spacer(),
        const CoinDisplay(),
        const SizedBox(width: 32),
      ],
    );
  }
}

class CoinDisplay extends StatelessWidget {
  const CoinDisplay({
    this.scale = 1,
    this.additional,
    Key? key,
  }) : super(key: key);

  final double scale;
  final List<Widget>? additional;

  @override
  Widget build(BuildContext context) {
    var size = Theme.of(context).textTheme.headline6?.fontSize;
    if (size != null) size *= scale;
    return Card(
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16 * scale)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8 * scale),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/coin.png',
              height: size,
            ),
            SizedBox(width: 8 * scale),
            Consumer<Coins>(
              builder: (context, coins, child) => Row(
                children: [
                  Text(
                    coins.value.toString(),
                    style: TextStyle(
                      fontSize: size,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ...?additional,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
