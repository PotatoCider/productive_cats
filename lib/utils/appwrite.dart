import 'package:appwrite/appwrite.dart';
import 'package:flutter_config/flutter_config.dart';

class Appwrite {
  static final Client client = Client();

  static void init() {
    client
        .setEndpoint(FlutterConfig.get('APPWRITE_ENDPOINT').toString())
        .setProject(FlutterConfig.get('APPWRITE_PROJECT_ID').toString());
  }

  static final Account account = Account(client);
  static final Database database = Database(client);
  static final Storage storage = Storage(client);
  static final Realtime realtime = Realtime(client);

  static bool isValidID(String id) =>
      RegExp(r"^[a-zA-Z][a-zA-Z0-9.\-_]*").hasMatch(id);

  static String get dbUsersID =>
      FlutterConfig.get('APPWRITE_DB_USERS').toString();
}
