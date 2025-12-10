import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav2048(current: 2),
      body: Column(
        children: [
          SizedBox(height: 40),
          Text(
            "2048",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text("Leaderboards", style: TextStyle(fontSize: 22)),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_, i) {
                return ListTile(
                  leading: Text("#${i + 1}"),
                  title: Text("Player ${i + 1}"),
                  trailing: Text("${(10 - i) * 2400} pts"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
