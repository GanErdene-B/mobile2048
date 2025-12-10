import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';

class LeaderboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav2048(current: 2),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF5AA5D7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      "2048",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text("Leaderboards", style: TextStyle(fontSize: 22)),
                    const SizedBox(height: 12),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
