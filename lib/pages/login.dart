import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:productive_cats/providers/user_info.dart';
import 'package:productive_cats/utils/appwrite.dart';
import 'package:productive_cats/widgets/format_text.dart';
import 'package:productive_cats/widgets/hero_material.dart';
import 'package:productive_cats/widgets/login_buttons.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:productive_cats/widgets/login_field.dart';
import 'package:provider/provider.dart';

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

  String _email = '';
  String _password = '';

  void _onLogin(bool google) async {
    _formKey.currentState!.save();
    if (!google && !_formKey.currentState!.validate()) return;

    try {
      if (google) {
        await Appwrite.account.createOAuth2Session(provider: 'google');
      } else {
        await Appwrite.account.createSession(
          email: _email,
          password: _password,
        );
      }
      UserInfo user = context.read<UserInfo>();

      await Future<void>.delayed(const Duration(seconds: 1));
      await user.fetch(); // fetch session

      if (!user.registerGoogle) {
        Utils.showSnackBar(context, 'Login successful');
      }
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
    var user = context.watch<UserInfo>();
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text('Login'),
      ),
      // drawer: const NavigationDrawer(DrawerItems.none),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const FormatText('Productive Cats',
                    size: 32, bold: true, center: true, hero: true),
                const SizedBox(height: 16),
                Image.asset(
                  'images/icon.png',
                  height: 160,
                  width: 160,
                  color: Theme.of(context).primaryColor,
                ),
                if (user.loading)
                  const CircularProgressIndicator()
                else
                  const SizedBox(height: 24),
                LoginFormField(
                  'Email', // TODO: allow username login too
                  validator: (value) {
                    if (!Utils.isValidEmail(value)) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value ?? '',
                  heroTag: 'field1',
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
                  heroTag: 'field2',
                ),
                const SizedBox(height: 16),
                HeroMaterial(
                  tag: 'buttons',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PaddedButton(
                        onPressed: () => _onLogin(false),
                        child: const Text('LOGIN'),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PaddedButton(
                            onPressed: () => context.push('/register'),
                            child: const Text('NEW USER?'),
                          ),
                          GoogleButton(
                            'SIGN IN',
                            onPressed: () => _onLogin(true),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
