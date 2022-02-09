import 'package:flutter/material.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:productive_cats/widgets/format_text.dart';
import 'package:productive_cats/widgets/hero_material.dart';
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
    this.margin,
    this.value,
    this.checkAfford = false,
    Key? key,
  })  : assert(!checkAfford || value != null),
        super(key: key);

  final double scale;
  final double? value;
  final bool checkAfford;
  final List<Widget>? additional;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    var size = Theme.of(context).textTheme.headline6?.fontSize ?? 14;
    size *= scale;
    Widget widget = Card(
      margin: margin,
      color: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16 * scale),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8 * scale),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: ResizeImage(
                const AssetImage('images/coin.png'),
                height: size.toInt() * 2,
              ),
              height: size,
            ),
            SizedBox(width: 4 * scale),
            Flexible(
              child: Consumer<Coins>(
                builder: (context, coins, child) => FormatText(
                  value?.round().toString() ?? coins.coinsInt.toString(),
                  size: size,
                  bold: true,
                  color:
                      checkAfford && coins.coins < value! ? Colors.red : null,
                ),
              ),
            ),
            ...?additional?.map((widget) => Flexible(child: widget)),
          ],
        ),
      ),
    );
    if (value == null) {
      widget = HeroMaterial(tag: 'coin_display', child: widget);
    }
    return widget;
  }
}
