import 'package:flutter/material.dart';

class PercentageBar extends StatelessWidget {
  const PercentageBar(
    this.percentage, {
    this.color,
    this.backgroundColor,
    Key? key,
  }) : super(key: key);

  final double percentage;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
      child: LinearProgressIndicator(
        value: percentage,
        backgroundColor: backgroundColor,
        color: color,
        minHeight: 8,
      ),
    );
  }
}
