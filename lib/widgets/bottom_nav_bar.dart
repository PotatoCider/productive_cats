import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
    this.index, {
    Key? key,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Usage',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Cats',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.compare_arrows),
          label: 'Trading',
        ),
      ],
      currentIndex: index,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/usage');
            break;
          case 1:
            context.go('/cats');
            break;
          case 2:
            context.go('/trading');
            break;
        }
      },
    );
  }
}
