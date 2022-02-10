import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/utils/appwrite.dart';
import 'package:productive_cats/utils/settings.dart';
import 'package:productive_cats/utils/utils.dart';

class UserInfo with ChangeNotifier {
  bool loading = true;
  User? user;

  String? username;

  String? get id => Settings.box.get('login_uid');
  set id(String? username) => Settings.box.put('login_uid', username as String);

  AppwriteException? error;

  static Future<Box<String>> openBox(String uid) => Hive.openBox('user_$uid');
  Box<String>? get box => user == null ? null : Hive.box('user_${user!.$id}');

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
      if (user != null) {
        id = user!.$id;
        var docs = await Appwrite.database.listDocuments(
          collectionId: Appwrite.dbUsersID,
          queries: <dynamic>[Query.equal('user_id', user!.$id)],
        );
        if (docs.sum > 0) {
          username = docs.documents.first.data['username'] as String;
        }
        await Cat.openBox(id!);
        await openBox(id!);
        Utils.log(username);
      }
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
