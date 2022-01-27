import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  const Heading(this.text, {Key? key}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
      ),
    );
  }
}
