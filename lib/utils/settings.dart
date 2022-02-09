import 'package:hive/hive.dart';

class Settings {
  static Box<String> get box => Hive.box('settings');
}
