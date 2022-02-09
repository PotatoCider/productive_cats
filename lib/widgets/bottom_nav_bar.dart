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
          label: 'Market',
        ),
      ],
      currentIndex: index,
      onTap: (index) {
        switch (index) {
          case 0:
            context.push('/usage');
            break;
          case 1:
            context.push('/cats');
            break;
          case 2:
            context.push('/market');
            break;
        }
      },
    );
  }
}
