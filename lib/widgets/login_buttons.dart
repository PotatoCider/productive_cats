import 'package:flutter/material.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton(
    this.text, {
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return PaddedButton(
      onPressed: onPressed,
      child: Row(
        children: [
          Image.asset(
            'images/google.png',
            height: 18,
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}

class PaddedButton extends StatelessWidget {
  const PaddedButton({
    required this.child,
    required this.onPressed,
    this.padding = 16,
    Key? key,
  }) : super(key: key);

  final Widget? child;
  final void Function()? onPressed;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(padding),
      ),
    );
  }
}
