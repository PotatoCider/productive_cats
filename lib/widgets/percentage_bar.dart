import 'package:flutter/material.dart';

class PercentageBar extends StatelessWidget {
  const PercentageBar(
    this.percentage, {
    this.color,
    this.backgroundColor,
    this.minHeight,
    this.borderRadius = 4,
    Key? key,
  }) : super(key: key);

  final double percentage;
  final Color? color;
  final Color? backgroundColor;
  final double? minHeight;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LinearProgressIndicator(
        value: percentage,
        backgroundColor: backgroundColor,
        color: color,
        minHeight: minHeight ?? 8,
      ),
    );
  }
}
