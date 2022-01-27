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

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

// TODO:
// - add forgot password
// - add show password (visible)

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final passwordFocus = FocusNode();

  String _email = '';
  String _password = '';

  void _onLogin(bool google) async {
    _formKey.currentState!.save();
    if (!google && !_formKey.currentState!.validate()) return;

    try {
      if (google) {
        await Appwrite.account.createOAuth2Session(
          provider: 'google',
        );
      } else {
        await Appwrite.account.createSession(
          email: _email,
          password: _password,
        );
      }
      Utils.showSnackBar(context, 'Login successful');
    } on AppwriteException catch (error) {
      String msg = error.message ?? 'Unknown Error';
      if (msg == 'Too many requests') {
        msg = "Too many login attempts. Try again later.";
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
        title: const Text('Login'),
      ),
      drawer: const ProductiveCatsDrawer(DrawerItems.logout),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox.square(dimension: 32),
              const Heading('Productive Cats'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Image.asset(
                  'images/icon.png',
                  height: 160,
                  width: 160,
                ),
              ),
              // Container(
              //   alignment: Alignment.center,
              //   padding: const EdgeInsets.all(8),
              //   child: Text(_errorMsg,
              //       style: const TextStyle(
              //         color: Colors.red,
              //       )),
              // ),
              LoginFormField(
                'Email', // TODO: allow username login too
                validator: (value) {
                  if (!Utils.isValidEmail(value)) {
                    return 'Invalid Email';
                  }
                  return null;
                },
                onSaved: (value) => _email = value ?? '',
              ),
              LoginFormField(
                'Password',
                obscureText: true,
                validator: (value) {
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
                onSaved: (value) => _password = value ?? '',
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                child: ElevatedButton(
                  onPressed: () => _onLogin(false),
                  child: const Text('LOGIN'),
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
                      onPressed: () => context.go('/register'),
                      child: const Text('NEW USER?'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _onLogin(true),
                      child: Row(
                        children: [
                          Image.asset(
                            'images/google.png',
                            height: 24,
                          ),
                          const SizedBox.square(dimension: 8),
                          const Text('SIGN IN'),
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
