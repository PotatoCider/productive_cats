import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';

class Utils {
  static bool isValidEmail(String email) => RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);

  static void showSnackBar(BuildContext context, String text) =>
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          content: Text(text),
        ));
      });

  static String capsFirst(String text) => text.isEmpty
      ? ''
      : text.characters.first.toUpperCase() + text.substring(1);

  static void log(Object? obj) => debugPrint(inspect(obj).toString());
  static void logNamed(String info, Object? obj) =>
      debugPrint('$info: ${inspect(obj).toString()}');

  // note: end exclusive
  static int randomInt(int min, int max) => Random().nextInt(max - min) + min;
}
