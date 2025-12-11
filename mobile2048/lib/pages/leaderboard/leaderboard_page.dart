import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import '../../services/api_service.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Map<String, dynamic>> entries = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    try {
      final rows = await ApiService.getLeaderboard();
      setState(() {
        entries = rows;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      // Keep entries empty on error and show a SnackBar
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load leaderboard: $e')));
      });
    }
  }

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
                      child: loading
                          ? const Center(child: CircularProgressIndicator())
                          : entries.isEmpty
                              ? const Center(child: Text('No leaderboard entries'))
                              : ListView.builder(
                                  itemCount: entries.length,
                                  itemBuilder: (_, i) {
                                    final e = entries[i];
                                    return ListTile(
                                      leading: Text("#${i + 1}"),
                                      title: Text(e['player'] ?? 'Player'),
                                      trailing: Text("${e['score'] ?? 0} pts"),
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
