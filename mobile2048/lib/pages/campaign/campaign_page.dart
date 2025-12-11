import 'package:flutter/material.dart';

class CampaignPage extends StatelessWidget {
  final List<Map<String, dynamic>> slots = [
    {"saved": true, "score": 3500, "difficulty": "Амархан"},
    {"saved": false, "score": 0, "difficulty": ""},
    {"saved": false, "score": 0, "difficulty": ""},
    {"saved": false, "score": 0, "difficulty": ""},
  ];

  // return campaign/save-slot state for DB or queries
  Map<String, dynamic> campaignState() {
    return {
      'slots': slots.map((s) => Map<String, dynamic>.from(s)).toList(),
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
      body: Padding(
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
                          Navigator.pushNamed(
                            context,
                            "/game",
                            arguments: {
                              "slotIndex": index,
                              "difficulty": slot["difficulty"],
                              "savedGame": true,
                            },
                          );
                        } else {
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
                                  Text(
                                    slot["saved"]
                                        ? "Save Slot ${index + 1}"
                                        : "New Game",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              if (slot["saved"]) ...[
                                Text("Оноо: ${slot["score"]}"),
                                const SizedBox(height: 4),
                                Text("Түвшин: ${slot["difficulty"]}"),
                              ] else
                                Text("Slot ${index + 1}"),
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
