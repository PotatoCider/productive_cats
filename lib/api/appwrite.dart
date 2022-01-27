import 'package:appwrite/appwrite.dart';

class Appwrite {
  static final Client client = Client()
      .setEndpoint('***REMOVED***')
      .setProject('***REMOVED***');

  static final Account account = Account(client);
  static final Account database = Account(client);
  static final Account storage = Account(client);

  static bool isValidID(String id) =>
      RegExp(r"^[a-zA-Z][a-zA-Z0-9.\-_]*").hasMatch(id);
}
