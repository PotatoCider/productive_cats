import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:productive_cats/api/appwrite.dart';
import 'package:productive_cats/drawer.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:productive_cats/widgets/heading.dart';
import 'package:productive_cats/widgets/login_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

// TODO:
// - add forgot password
// - add show password (visible)
// - add email verification

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  String _username = '';
  String _email = '';
  String _password = '';
  String _name = '';

  void _onRegister(bool google) async {
    _formKey.currentState!.save();
    if (!google && !_formKey.currentState!.validate()) return;

    try {
      if (google) {
        await Appwrite.account.createOAuth2Session(
          provider: 'google',
        );
      } else {
        await Appwrite.account.create(
          userId: _username,
          email: _email,
          password: _password,
          name: _name.isEmpty ? _username : _name,
        );
      }
      Utils.showSnackBar(context, 'Register successful');
    } on AppwriteException catch (error) {
      String msg = error.message ?? 'Unknown Error';
      if (msg == 'Too many requests') {
        msg = "Too many register attempts. Try again later.";
      }
      Utils.showSnackBar(context, msg);
    } on PlatformException catch (error) {
      debugPrint(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.register),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox.square(dimension: 32),
              const Heading('Productive Cats'),
              LoginFormField(
                'Email',
                validator: (value) {
                  if (!Utils.isValidEmail(value)) {
                    return 'Invalid Email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value ?? '',
              ),
              LoginFormField(
                'Name',
                optional: true,
                validator: (value) {
                  if (value.length > 36) {
                    return 'Max 36 chars';
                  }
                  return null;
                },
                onSaved: (value) => _name = value ?? '',
              ),
              LoginFormField(
                'Username',
                validator: (value) {
                  if (value.length > 36) {
                    return 'Max 36 chars';
                  }
                  if (!Appwrite.isValidID(value)) {
                    return 'Invalid username';
                  }
                  return null;
                },
                onSaved: (value) => _username = value ?? '',
              ),
              LoginFormField(
                'Password',
                obscureText: true,
                validator: (value) {
                  if (value.length < 8 || value.length > 64) {
                    return 'Only 8-64 chars';
                  }
                  return null;
                },
                onSaved: (value) => _password = value ?? '',
              ),
              LoginFormField(
                'Confirm Password',
                obscureText: true,
                validator: (value) {
                  if (value != _password) {
                    return 'Password does not match';
                  }
                  return null;
                },
              ),
              // if (_errorMsg.isNotEmpty)
              //   Container(
              //     alignment: Alignment.center,
              //     padding: const EdgeInsets.all(16),
              //     child: Text(
              //       _errorMsg,
              //       style: const TextStyle(color: Colors.red),
              //     ),
              //   ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                child: ElevatedButton(
                  onPressed: () => _onRegister(false),
                  onLongPress: () async {
                    try {
                      User user = await Appwrite.account.get();
                      debugPrint(user.toString());
                    } on AppwriteException catch (error) {
                      debugPrint(error.toString());
                    }
                  },
                  child: const Text('REGISTER'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => context.go('/login'),
                      child: const Text('OLD USER?'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _onRegister(true),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/google.png',
                            height: 24,
                          ),
                          const SizedBox.square(dimension: 8),
                          const Text('SIGN UP'),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
