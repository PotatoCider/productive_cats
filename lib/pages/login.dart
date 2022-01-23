import 'package:flutter/material.dart';
import 'package:productive_cats/drawer.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

// TODO:
// - add logo
// - add form validation
// - add forgot password
// - add show password (visible)

class _LoginPageState extends State<LoginPage> {
  void _onLogin() {
    Navigator.pushNamed(context, '/buddy');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.logout),
      body: SingleChildScrollView(
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Text(
              'Productive Cats',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 32,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Image.asset(
              'images/icon.png',
              height: 192,
              width: 192,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Username / Email',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username / Email',
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Password',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Password',
                  ),
                ),
              ],
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
      ),
    );
  }
}
