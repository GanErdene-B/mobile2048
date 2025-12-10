import 'package:flutter/material.dart';

class BottomNav2048 extends StatelessWidget {
  final int current;

  BottomNav2048({required this.current});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: current,
      onTap: (i) {
        switch (i) {
          case 0:
            Navigator.pushNamed(context, '/home');
            break;
          case 1:
            Navigator.pushNamed(context, '/tasks');
            break;
          case 2:
            Navigator.pushNamed(context, '/leaderboard');
            break;
          case 3:
            Navigator.pushNamed(context, '/settings');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.checklist), label: "Tasks"),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: "Leaderboard",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}
