import 'package:flutter/material.dart';

class Utils {
  static bool isValidEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  static void showSnackBar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        content: Text(text),
      ));
}
