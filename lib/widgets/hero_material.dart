import 'package:flutter/material.dart';

// HeroMaterial is used if text is not rendered
// correctly during a hero transition.
// see https://github.com/flutter/flutter/issues/30647#issuecomment-509712719
class HeroMaterial extends StatelessWidget {
  const HeroMaterial({
    required this.tag,
    required this.child,
    Key? key,
  }) : super(key: key);

  final String tag;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  }
}
