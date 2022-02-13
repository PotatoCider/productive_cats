import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:device_apps/device_apps.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:productive_cats/providers/user_info.dart';
import 'package:productive_cats/utils/appwrite.dart';
import 'package:productive_cats/utils/cat_names.dart';
import 'package:productive_cats/providers/app_usages.dart';
import 'package:productive_cats/utils/utils.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

part 'cat.g.dart';

@HiveType(typeId: 1)
class Cat extends HiveObject {
  Cat({
    required this.id,
    required this.maxHappiness,
    required this.maxFitness,
    this.imagePath,
    required this.name,
    this.level = 1,
    this.experience = 0,
    required this.preferences,
    this.todayExp = 0,
    this.imageBytes,
    double? price,
    this.soldBy,
    this.docID,
  })  : happiness = maxHappiness.toDouble(),
        fitness = maxFitness.toDouble(),
        _price = price;

  static const minHappinessValue = 100;
  static const maxHappinessValue = 500;
  static const minFitnessValue = 100;
  static const maxFitnessValue = 500;

  static Box<Cat>? _box;

  static Box<Cat>? get catbox => _box;

  static Future<Box<Cat>> openBox(String id) async =>
      _box = await Hive.openBox('${id}_cats');

  // static Cat? get buddy => Cat.catbox.get('buddy');

  static bool generating = false;

  static Future<Cat?> generate([bool buddy = false]) async {
    if (generating) return null;
    generating = true;
    var id = const Uuid().v4();
    late File file;

    // fetch image
    var futureRes = http.get(Uri.parse('https://thiscatdoesnotexist.com/'));

    // save image
    try {
      await getApplicationDocumentsDirectory().then((dir) async {
        file = File('${dir.path}/images/$id.jpg');
        await file.create(recursive: true);
        await file.writeAsBytes((await futureRes).bodyBytes);
      });
    } catch (err) {
      Utils.logNamed('generate cats', err);
      generating = false;
      return null;
    }

    // generate cat preference
    Map<String, double> prefs = {};
    for (var cat in ApplicationCategory.values) {
      prefs[cat.name] = Random().nextDouble();
    }
    // normalize preferences with probability 1
    double total = prefs.values.reduce((total, p) => total + p);
    for (var cat in ApplicationCategory.values) {
      prefs[cat.name] = prefs[cat.name]! / total;
    }

    // create cat
    Cat cat = Cat(
      id: id,
      maxHappiness: Utils.randomInt(minHappinessValue, maxHappinessValue + 1),
      maxFitness: Utils.randomInt(minFitnessValue, maxFitnessValue + 1),
      name: catNames[Random().nextInt(catNames.length)],
      imagePath: file.path,
      preferences: prefs,
    );

    var box = Cat.catbox!;
    if (buddy) {
      box.put('buddy', cat);
    } else {
      box.add(cat);
    }

    generating = false;
    return cat;
  }

  static Future<Cat> fromPayload(Map<String, dynamic> payload) async {
    var fileBytes = await Appwrite.storage
        .getFilePreview(fileId: payload['file'] as String);
    return Cat(
      id: payload['id'] as String,
      maxHappiness: payload['max_happiness'] as int,
      maxFitness: payload['max_fitness'] as int,
      name: payload['name'] as String,
      level: payload['level'] as int,
      experience: (payload['experience'] as num).toDouble(),
      preferences: Map<String, double>.from(
          jsonDecode(payload['preferences'] as String) as Map),
      imageBytes: fileBytes,
      price: (payload['price'] as num).toDouble(),
      soldBy: payload['owner'] as String?,
      docID: payload['\$id'] as String,
    );
  }

  String? soldBy; // user id
  String? docID;
  double? _price;
  Uint8List? imageBytes;

  double get price {
    return _price ?? 50 + level * 50;
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int maxHappiness;

  @HiveField(2)
  final int maxFitness;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  String name;

  @HiveField(5)
  double happiness;

  @HiveField(6)
  double fitness;

  @HiveField(7, defaultValue: 1)
  int level;

  @HiveField(8, defaultValue: 0)
  double experience;

  @HiveField(9)
  late final Map<String, double> preferences;

  @HiveField(10, defaultValue: 0)
  double todayExp;

  // consumeDailyUsage is used to calculate and add the cat's experience
  // from today's usage. This method is intended to be called once per day.
  double consumeDailyUsage(
      AppUsagePeriod period, Map<String, ApplicationWithIcon> apps) {
    if (period.durations.isEmpty || period.offlineDuration.isNegative) return 0;

    // first we take into account of the app usage of each app,
    // based on the cat's preferences of app's category.
    // In order to quantify this, we take the weighted
    // sum of the percentage that each app used based on the cat's
    // preference of the app

    // first calculate the weighted factor of each category based on the
    // *present* categories listed in the current period.
    var activeCategories =
        period.durations.keys // all app with usage from yesterday
            .map((name) => apps[name]?.category.name) // get app category
            .whereType<String>()
            .toSet();
    var totalp = activeCategories
        .map((cat) => preferences[cat]!)
        .reduce((totalp, p) => totalp + p);
    var pweighted = preferences.map((cat, p) {
      if (!activeCategories.contains(cat)) return MapEntry(cat, 0);
      return MapEntry(cat, p / totalp);
    });

    // then we take the weighted sum
    var rsum = 0.0;
    for (var name in period.appNamesByUsage) {
      var cat = apps[name]?.category.name;
      if (!preferences.containsKey(cat)) continue;

      // ratio of app usage
      var r =
          period.durations[name]!.inSeconds / period.totalDuration.inSeconds;

      // multiply with how much the cat prefers this app
      var rweighted = r * pweighted[cat]!;
      rsum += rweighted;
    }
    Utils.log(rsum);
    Utils.log(maxExperience);
    Utils.log(baselineExp);

    // then we take the weighted sum of app usage and multiply it
    // with the max exp and offline time. This makes it so that the cat
    // gains more exp when you are not using your phone.
    var offlineRatio =
        period.offlineDuration.inSeconds / period.maxDuration.inSeconds;
    var exp = maxExperience * rsum * offlineRatio;

    todayExp = exp;
    addExperience(exp);
    return exp;
  }

  static const double baselineExp = 100;

  // experience needed to get to the next level
  double get maxExperience => baselineExp * pow(2, level - 1).toDouble();

  double addExperience(double exp) {
    assert(exp > 0);
    experience += exp;
    while (experience >= maxExperience) {
      experience -= maxExperience;
      level++;
    }

    save();
    return experience;
  }

  Future<void> buyFromMarket() async {
    if (imageBytes == null) return;
    // save image
    late File file;
    try {
      await getApplicationDocumentsDirectory().then((dir) async {
        file = File('${dir.path}/images/$id.jpg');
        await file.create(recursive: true);
        await file.writeAsBytes(imageBytes!);
      });
    } catch (err) {
      Utils.logNamed('buy cat', err);
      return;
    }
    imagePath = file.path;
    _price = null;
    imageBytes = null;
    soldBy = null;
    await Cat.catbox!.add(this);
  }

  Future<void> removeFromMarket() async {
    await Future.wait<dynamic>([
      Appwrite.storage.deleteFile(fileId: id),
      Appwrite.database.deleteDocument(
        collectionId: Appwrite.dbCatsID,
        documentId: docID!,
      ),
    ]);
  }

  Future<void> sellToMarket(UserInfo userInfo) async {
    var multipartFile = await http.MultipartFile.fromPath('file', imagePath!,
        filename: id + '.jpg');
    await Appwrite.storage.createFile(
      fileId: id,
      file: multipartFile,
      read: <String>['role:member'],
      write: <String>['role:member'],
    );

    await Appwrite.database.createDocument(
      collectionId: Appwrite.dbCatsID,
      documentId: 'unique()',
      data: <String, dynamic>{
        'id': id,
        'file': id,
        'owner': userInfo.username,
        'price': (price * (1 + Random().nextDouble() / 2)).round(),
        'name': name,
        'level': level,
        'experience': experience,
        'max_happiness': maxHappiness,
        'max_fitness': maxFitness,
        'preferences': jsonEncode(preferences),
      },
      read: <String>['role:member'],
      write: <String>['role:member'],
    );
  }

  Future<void> removeFromDatabase() async {
    File(imagePath!).delete();
    return super.delete();
  }
}
