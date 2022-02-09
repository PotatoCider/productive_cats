import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:productive_cats/providers/user_info.dart';
import 'package:productive_cats/utils/appwrite.dart';
import 'package:productive_cats/widgets/format_text.dart';
import 'package:productive_cats/widgets/hero_material.dart';
import 'package:productive_cats/widgets/login_buttons.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:productive_cats/widgets/heading.dart';
import 'package:productive_cats/widgets/login_field.dart';
import 'package:provider/provider.dart';

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

  void _onRegister(bool googleSignUp) async {
    _formKey.currentState!.save();
    if (!googleSignUp && !_formKey.currentState!.validate()) return;

    UserInfo user = context.read<UserInfo>();
    try {
      // if a user registers using google, we also need the user to enter a
      // new username and password, hence google login is a two-step process
      // where the 2nd step is when user.registerGoogle == true
      if (googleSignUp) {
        await Appwrite.account.createOAuth2Session(provider: 'google');
        await user.fetch(); // fetch session
      } else {
        if (user.registerGoogle) {
          if (_name.isNotEmpty) await Appwrite.account.updateName(name: _name);
          await Appwrite.account.updatePassword(password: _password);
        } else {
          await Appwrite.account.create(
            userId: 'unique()',
            email: _email,
            password: _password,
            name: _name.isEmpty ? _username : _name,
          );
          await Appwrite.account.createSession(
            email: _email,
            password: _password,
          );
        }

        await Future<void>.delayed(const Duration(seconds: 1));
        await user.fetch();

        Appwrite.database.createDocument(
          collectionId: Appwrite.dbUsersID, // users
          documentId: 'unique()',
          data: <String, dynamic>{
            'user_id': user.user!.$id,
            'email': _email,
            'username': _username,
            'name': _name,
            'coins': 0,
          },
        );
        Utils.showSnackBar(context, 'Register successful');
      }
    } on AppwriteException catch (error) {
      var msg = error.message ?? 'Unknown Error';
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
    final user = context.watch<UserInfo>();
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.shrink(),
        title: const Text('Register'),
      ),
      // drawer: const NavigationDrawer(DrawerItems.register),
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
                const SizedBox(height: 8),
                if (user.registerGoogle)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).dialogBackgroundColor,
                    ),
                    child: Text(
                      'Please enter your Username and Password '
                      'to complete registration.',
                      style: TextStyle(color: Theme.of(context).indicatorColor),
                    ),
                  ),
                LoginFormField(
                  'Email',
                  validator: (value) {
                    if (!Utils.isValidEmail(value)) {
                      return 'Invalid Email';
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value ?? '',
                  initialValue: user.user?.email ?? '',
                  enabled: !user.registerGoogle,
                  heroTag: 'field1',
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
                  initialValue: user.user?.name ?? '',
                  enabled: !user.registerGoogle,
                  heroTag: 'field2',
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
                  'New Password',
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
                const SizedBox(height: 8),
                HeroMaterial(
                  tag: 'buttons',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: () => _onRegister(false),
                        child: const Text('REGISTER'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (!user.registerGoogle)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            PaddedButton(
                              child: const Text('OLD USER?'),
                              onPressed: () => context.push('/login'),
                            ),
                            GoogleButton(
                              'SIGN UP',
                              onPressed: () => _onRegister(true),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
