import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:productive_cats/utils/appwrite.dart';
import 'package:productive_cats/utils/utils.dart';

class UserInfo with ChangeNotifier {
  bool loading = true;
  User? user;
  AppwriteException? error;

  bool get loggedIn => user != null && user!.passwordUpdate != 0;
  bool get registerGoogle => user != null && user!.passwordUpdate == 0;
  bool get timedOut =>
      error?.message != null && error!.message!.contains('SocketException');

  Future<User?> fetch() async {
    debugPrint('fetch');
    loading = true;
    error = null;
    try {
      user = await Appwrite.account.get();
    } on AppwriteException catch (e) {
      error = e;
      Utils.logNamed('login error', e);
    }
    loading = false;
    notifyListeners();
    return user;
  }

  Future<void> logout() async {
    loading = true;
    error = null;
    try {
      await Appwrite.account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      error = e;
      Utils.logNamed('logout error', e);
    }
    user = null;
    loading = false;
    notifyListeners();
  }
}
