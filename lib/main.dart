import 'package:flutter/material.dart';
import 'package:productive_cats/buddy.dart';

import 'package:productive_cats/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Productive Cats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(),
      routes: {
        // '/': (context) => SplashScreen(), // TODO: add splash screen
        '/login': (context) => const LoginScreen(),
        '/buddy': (context) => const ProductiveBuddyScreen(),
      },
    );
  }
}
