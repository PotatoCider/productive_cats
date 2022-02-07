import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:productive_cats/models/cat.dart';
import 'package:productive_cats/pages/buddy.dart';
import 'package:productive_cats/pages/cat_collection.dart';
import 'package:productive_cats/pages/cat_info.dart';
import 'package:productive_cats/pages/leaderboard.dart';

import 'package:productive_cats/pages/login.dart';
import 'package:productive_cats/pages/cat_box.dart';
import 'package:productive_cats/pages/register.dart';
import 'package:productive_cats/pages/settings.dart';
import 'package:productive_cats/pages/app_usage.dart';
import 'package:productive_cats/pages/trading.dart';
import 'package:productive_cats/providers/app_usages.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:productive_cats/providers/user_info.dart';
import 'package:productive_cats/utils/appwrite.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();
  Appwrite.init();
  Wakelock.enable();

  Hive.registerAdapter(CatAdapter());

  await Hive.initFlutter();
  await Future.wait([
    Cat.openBox(),
    Hive.openBox<String>('settings'),
  ]);

  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key})
      : user = UserInfo(),
        super(key: key);

  final UserInfo user;

  @override
  Widget build(BuildContext context) {
    user.fetch();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: user),
        ChangeNotifierProvider(create: (_) => Coins()),
        ChangeNotifierProvider(create: (_) => AppUsages(), lazy: false),
      ],
      child: ValueListenableBuilder<Box<String>>(
          valueListenable: Hive.box<String>('settings').listenable(),
          builder: (context, box, child) {
            var themeMode = ThemeMode.system;
            if (box.containsKey('dark_mode')) {
              themeMode = box.get('dark_mode') == '1'
                  ? ThemeMode.dark
                  : ThemeMode.light;
            }
            return MaterialApp.router(
              title: 'Productive Cats',
              themeMode: themeMode,
              theme: ThemeData(
                primarySwatch: Colors.indigo,
                brightness: Brightness.light,
              ),
              darkTheme: ThemeData(
                primarySwatch: Colors.indigo,
                brightness: Brightness.dark,
              ),
              routeInformationParser: _router.routeInformationParser,
              routerDelegate: _router.routerDelegate,
            );
          }),
    );
  }

  late final _router = GoRouter(
    initialLocation: '/cats',
    refreshListenable: user,
    redirect: (state) {
      if (user.loading) return null;
      var isLoginScreen =
          (state.location == '/login' || state.location == '/register');
      if (isLoginScreen && user.loggedIn) return '/buddy';
      if (!isLoginScreen && !user.loggedIn) return '/login';
      if (state.location != '/register' && user.registerGoogle) {
        return '/register';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const BuddyPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/buddy',
        builder: (context, state) => const BuddyPage(),
      ),
      GoRoute(
        path: '/cats',
        builder: (context, state) => const CatCollectionPage(),
        routes: [
          GoRoute(
            path: ':index',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: CatInfoPage(
                Cat.catbox.getAt(int.parse(state.params['index']!))!,
              ),
              transitionsBuilder: (context, animation, _, child) =>
                  FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/catbox',
        builder: (context, state) => const CatBoxPage(),
      ),
      GoRoute(
        path: '/trading',
        builder: (context, state) => const TradingPage(),
      ),
      GoRoute(
        path: '/appusage',
        builder: (context, state) => const AppUsagePage(),
      ),
      GoRoute(
        path: '/leaderboard',
        builder: (context, state) => const LeaderboardPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
}
