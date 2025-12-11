import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/database_helper.dart';

class CampaignPage extends StatefulWidget {
  @override
  _CampaignPageState createState() => _CampaignPageState();
}

class _CampaignPageState extends State<CampaignPage> {
  List<Map<String, dynamic>> slots = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedGames();
  }

  Future<void> _loadSavedGames() async {
    try {
      // Try to load from backend first
      final games = await ApiService.getSavedGames();

      // Initialize 4 slots (0-3)
      final newSlots = List.generate(4, (i) => {
            'saved': false,
            'score': 0,
            'difficulty': '',
            'player': '',
            'data': null,
            'id': null,
          });

      // Fill slots with saved games (take first 4 games, sorted by most recent)
      for (int i = 0; i < games.length && i < 4; i++) {
        final game = games[i];
        final gameData = game['data'] is String
            ? (game['data'] as String).isNotEmpty ? game['data'] : game
            : game;

        newSlots[i] = {
          'saved': true,
          'score': game['bestScore'] ?? 0,
          'difficulty': gameData is Map
              ? (gameData['difficulty'] ?? 'Unknown')
              : 'Unknown',
          'player': gameData is Map
              ? (gameData['player'] ?? 'Player')
              : (game['player'] ?? 'Player'),
          'data': game,
          'id': game['id'],
        };
      }

      setState(() {
        slots = newSlots;
        loading = false;
      });
    } catch (e) {
      debugPrint('Error loading saved games: $e');
      // Fall back to empty slots
      setState(() {
        slots = List.generate(4, (i) => {
              'saved': false,
              'score': 0,
              'difficulty': '',
              'player': '',
              'data': null,
              'id': null,
            });
        loading = false;
      });
    }
  }

  // return campaign/save-slot state for DB or queries
  Map<String, dynamic> campaignState() {
    return {
      'slots': slots.map((s) => {
            'saved': s['saved'],
            'score': s['score'],
            'difficulty': s['difficulty'],
            'player': s['player'],
          }).toList(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: const Text("2048"),
        centerTitle: true,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
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
                      child: ListView.builder(
                        itemCount: slots.length,
                        itemBuilder: (context, index) {
                          final slot = slots[index];
                          return GestureDetector(
                            onTap: () {
                              if (slot["saved"]) {
                                // Continue existing game
                                Navigator.pushNamed(
                                  context,
                                  "/game",
                                  arguments: {
                                    "slotIndex": index,
                                    "difficulty": slot["difficulty"],
                                    "savedGame": true,
                                    "gameData": slot["data"],
                                  },
                                );
                              } else {
                                // Start new game
                                Navigator.pushNamed(
                                  context,
                                  "/campaign-new",
                                  arguments: {"slotIndex": index},
                                );
                              }
                            },
                            child: Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          slot["saved"]
                                              ? Icons.save
                                              : Icons.add_box_outlined,
                                          size: 32,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            slot["saved"]
                                                ? "Save Slot ${index + 1}"
                                                : "New Game",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    if (slot["saved"]) ...[
                                      Text("Оноо: ${slot["score"]}"),
                                      const SizedBox(height: 4),
                                      Text("Түвшин: ${slot["difficulty"]}"),
                                      const SizedBox(height: 4),
                                      Text("Хэрэглэгч: ${slot["player"]}"),
                                    ] else
                                      Text("Slot ${index + 1} - Шинэ тоглоом эхлүүлнэ үү"),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
