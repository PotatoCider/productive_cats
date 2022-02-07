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
    this.hero = false,
    this.heroTag,
    this.center = false,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color? color;
  final FontWeight? weight;
  final bool bold;
  final double? size;
  final bool center;
  final EdgeInsetsGeometry padding;
  final bool hero;
  final String? heroTag;

  @override
  Widget build(BuildContext context) {
    Widget widget = Text(
      text,
      // softWrap: false prevents text from cutting during hero transition
      // see https://github.com/flutter/flutter/issues/10246
      softWrap: !hero,
      style: TextStyle(
        color: color,
        fontWeight: weight ?? (bold ? FontWeight.bold : null),
        fontSize: size,
      ),
    );

    if (center) {
      widget = Center(child: widget);
    }
    if (padding != EdgeInsets.zero) {
      widget = Padding(padding: padding, child: widget);
    }
    if (hero) {
      widget = HeroMaterial(tag: heroTag ?? text, child: widget);
    }
    return widget;
  }
}
