import 'package:hive/hive.dart';

class Settings {
  static Future<Box<String>> openBox() => Hive.openBox('settings');
  static Box<String> get box => Hive.box('settings');
}
