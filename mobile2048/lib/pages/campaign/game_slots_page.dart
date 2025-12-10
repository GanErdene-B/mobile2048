import 'package:flutter/material.dart';

class GameSlotsPage extends StatelessWidget {
  final List<Map<String, dynamic>> slots = [
    {"saved": false, "score": 0, "difficulty": ""},
    {"saved": false, "score": 0, "difficulty": ""},
    {"saved": false, "score": 0, "difficulty": ""},
    {"saved": false, "score": 0, "difficulty": ""},
  ];

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
            const Text(
              "Select a Slot",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.1,
                ),
                itemBuilder: (context, index) {
                  final slot = slots[index];

                  return GestureDetector(
                    onTap: () {
                      // If saved slot → continue game
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
                        // New save → go to difficulty select
                        Navigator.pushNamed(
                          context,
                          "/campaign-new",
                          arguments: {"slotIndex": index},
                        );
                      }
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              slot["saved"]
                                  ? Icons.save
                                  : Icons.add_box_outlined,
                              size: 40,
                            ),
                            const SizedBox(height: 10),

                            Text(
                              slot["saved"]
                                  ? "Save Slot ${index + 1}"
                                  : "New Game",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 6),

                            if (slot["saved"]) ...[
                              Text("Score: ${slot["score"]}"),
                              Text("Difficulty: ${slot["difficulty"]}"),
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
          ],
        ),
      ),
    );
  }
}
