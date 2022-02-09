import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
import 'package:productive_cats/pages/market.dart';
import 'package:productive_cats/providers/app_usages.dart';
import 'package:productive_cats/providers/cat_market.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:productive_cats/providers/daily_updater.dart';
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
  await Hive.openBox<String>('settings');
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final UserInfo user = UserInfo();
  late final Coins coins = Coins(user);
  final AppUsages usages = AppUsages();

  @override
  void initState() {
    super.initState();
    user.fetch();
  }

  @override
  void dispose() {
    user.dispose();
    coins.dispose();
    usages.dispose();
    super.dispose();
  }

  Widget _transitionBuilder(BuildContext context, Animation<double> animation,
          Animation<double> _, Widget child) =>
      FadeTransition(
        opacity: animation,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: user),
        ChangeNotifierProvider.value(value: coins),
        ChangeNotifierProvider.value(value: usages),
        ChangeNotifierProvider(
            create: (_) => DailyUpdater(user, usages, coins)),
        ChangeNotifierProvider(create: (_) => CatMarket()),
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
              debugShowCheckedModeBanner: false,
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
    initialLocation: '/login',
    refreshListenable: user,
    redirect: (state) {
      if (user.loading) return null;
      var isLoginScreen =
          (state.location == '/login' || state.location == '/register');
      if (isLoginScreen && user.loggedIn) return '/cats';
      if (!isLoginScreen && !user.loggedIn) return '/login';
      if (state.location != '/register' && user.registerGoogle) {
        return '/register';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const CatCollectionPage(),
          transitionsBuilder: _transitionBuilder,
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LoginPage(),
          transitionsBuilder: _transitionBuilder,
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const RegisterPage(),
          transitionsBuilder: _transitionBuilder,
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ),
      // GoRoute(
      //   path: '/buddy',
      //   builder: (context, state) => const BuddyPage(),
      // ),
      GoRoute(
        path: '/cats',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const CatCollectionPage(),
          transitionsBuilder: _transitionBuilder,
          transitionDuration: const Duration(milliseconds: 350),
        ),
        routes: [
          GoRoute(
            path: ':index',
            pageBuilder: (context, state) => CustomTransitionPage(
              child: CatInfoPage(
                Cat.catbox!.getAt(int.parse(state.params['index']!)),
              ),
              transitionsBuilder: _transitionBuilder,
              transitionDuration: const Duration(milliseconds: 350),
            ),
          ),
        ],
      ),
      // GoRoute(
      //   path: '/catbox',
      //   builder: (context, state) => const CatBoxPage(),
      // ),
      GoRoute(
        path: '/market',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const MarketPage(),
          transitionsBuilder: _transitionBuilder,
          transitionDuration: const Duration(milliseconds: 350),
        ),
        routes: [
          GoRoute(
            path: ':index',
            pageBuilder: (context, state) {
              var market = context.read<CatMarket>();
              return CustomTransitionPage(
                child: CatInfoPage(
                  market.cats[int.parse(state.params['index']!)],
                ),
                transitionsBuilder: _transitionBuilder,
                transitionDuration: const Duration(milliseconds: 350),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: '/usage',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const AppUsagePage(),
          transitionsBuilder: _transitionBuilder,
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ),
      // GoRoute(
      //   path: '/leaderboard',
      //   builder: (context, state) => const LeaderboardPage(),
      // ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const SettingsPage(),
          transitionsBuilder: _transitionBuilder,
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ),
    ],
  );
}
