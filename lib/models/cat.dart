import 'dart:io';
import 'dart:math';

import 'package:device_apps/device_apps.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
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
    required this.imagePath,
    required this.name,
    this.level = 1,
    this.experience = 0,
    required this.preferences,
    this.todayExp = 0,
  })  : happiness = maxHappiness.toDouble(),
        fitness = maxFitness.toDouble();

  static const minHappinessValue = 100;
  static const maxHappinessValue = 500;
  static const minFitnessValue = 100;
  static const maxFitnessValue = 500;

  static late Box<Cat> _box;

  static Box<Cat> get catbox => _box;

  static Future<Box<Cat>> openBox() async => _box = await Hive.openBox('cats');

  static Cat? get buddy => Cat.catbox.get('buddy');

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
        file = File('${dir.path}/images/$id');
        await file.create(recursive: true);
        file.writeAsBytes((await futureRes).bodyBytes);
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

    var box = Cat.catbox;
    if (buddy) {
      box.put('buddy', cat);
    } else {
      box.add(cat);
    }

    generating = false;
    return cat;
  }

  @HiveField(0)
  final String id;

  @HiveField(1)
  final int maxHappiness;

  @HiveField(2)
  final int maxFitness;

  @HiveField(3)
  final String imagePath;

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
    if (period.durations.isEmpty) return 0;

    // first we take into account of the app usage of each app,
    // based on the cat's preferences of app's category.
    // In order to quantify this, we take the weighted
    // sum of the percentage that each app used based on the cat's
    // preference of the app

    // first calculate the weighted factor of each category based on the
    // *present* categories listed in the current period.
    var activeCategories =
        period.durations.keys // all app with usage from yesterday
            .map((name) => apps[name]!.category.name) // get app category
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
      var cat = apps[name]!.category.name;
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

  double get price {
    return 50 + level * 50;
  }

  @override
  Future<void> delete() {
    File(imagePath).delete();
    return super.delete();
  }
}
