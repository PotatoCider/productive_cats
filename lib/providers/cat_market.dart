import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/utils/appwrite.dart';
import 'package:productive_cats/utils/utils.dart';

class CatMarket extends ChangeNotifier {
  bool fetched = false;
  List<Cat> cats = [];
  RealtimeSubscription? subscription;

  @override
  void dispose() {
    subscription?.close();
    return super.dispose();
  }

  Future<void> fetch() async {
    fetched = false;
    cats = [];
    var docs = await Appwrite.database.listDocuments(
      collectionId: Appwrite.dbCatsID,
    );
    for (var doc in docs.documents) {
      cats.add(await Cat.fromPayload(doc.data));
    }
    if (subscription == null) {
      subscription = Appwrite.realtime
          .subscribe(['collections.${Appwrite.dbCatsID}.documents']);
      subscription!.stream.listen((event) async {
        var i =
            cats.indexWhere((cat) => cat.id == event.payload["id"] as String);
        if (i != -1 && event.event == 'database.documents.delete') {
          cats.removeAt(i);
        } else if (i != -1) {
          cats[i] = await Cat.fromPayload(event.payload);
        } else {
          cats.add(await Cat.fromPayload(event.payload));
        }
        notifyListeners();
      });
    }
    fetched = true;
    notifyListeners();
  }
}
