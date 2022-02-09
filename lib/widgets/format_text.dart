import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:productive_cats/widgets/hero_material.dart';

class FormatText extends StatelessWidget {
  const FormatText(
    this.text, {
    this.color,
    this.weight,
    this.bold = false,
    this.size,
    this.padding = EdgeInsets.zero,
    bool hero = false,
    this.heroTag,
    this.center = false,
    this.shadow = false,
    this.softWrap = true,
    Key? key,
  })  : isHero = heroTag != null || hero,
        super(key: key);

  final String text;
  final Color? color;
  final FontWeight? weight;
  final bool bold;
  final double? size;
  final bool center;
  final EdgeInsetsGeometry padding;
  final bool isHero;
  final String? heroTag;
  final bool shadow;
  final bool softWrap;

  @override
  Widget build(BuildContext context) {
    Widget widget = AutoSizeText(
      text,
      // softWrap: false prevents text from cutting during hero transition
      // see https://github.com/flutter/flutter/issues/10246
      softWrap: !isHero && softWrap,
      style: TextStyle(
        color: color,
        fontWeight: weight ?? (bold ? FontWeight.bold : null),
        fontSize: size,
        shadows: shadow
            ? [
                const Shadow(
                  offset: Offset(0.1, 0.1),
                  blurRadius: 0.5,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ]
            : null,
      ),
    );

    if (center) {
      widget = Center(child: widget);
    }
    if (padding != EdgeInsets.zero) {
      widget = Padding(padding: padding, child: widget);
    }
    if (isHero) {
      widget = HeroMaterial(tag: heroTag ?? text, child: widget);
    }
    return widget;
  }
}
