import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:productive_cats/providers/coins.dart';
import 'package:productive_cats/providers/user_info.dart';
import 'package:productive_cats/widgets/nav_drawer.dart';
import 'package:productive_cats/widgets/coin_display.dart';
import 'package:provider/provider.dart';

class BuddyPage extends StatelessWidget {
  const BuddyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TitleWithCoinDisplay('Your Buddy'),
      ),
      drawer: const NavigationDrawer(DrawerItems.buddy),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => context.read<Coins>().increment(),
              child: const Text('Increment'),
            ),
            Consumer2<UserInfo, Coins>(
              builder: (context, user, coins, child) {
                if (user.loading) return const CircularProgressIndicator();
                if (!user.loggedIn) return const SizedBox.shrink();
                return Text(
                    'Logined as ${user.user!.name}, Coins: ${coins.value}');
              },
            )
          ],
        ),
      ),
    );
  }
}

class BuddyWidget extends StatelessWidget {
  const BuddyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
