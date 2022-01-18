import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

// TODO:
// - add logo
// - add form validation
// - add forgot password
// - add show password (visible)

class _LoginScreenState extends State<LoginScreen> {
  void _onLogin() {
    Navigator.of(context).popAndPushNamed('/buddy');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.collection),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Username/Email',
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(10),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Password',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            onPressed: _onLogin,
            child: const Text('Login'),
          ),
        ),
      ]),
    );
  }
}
