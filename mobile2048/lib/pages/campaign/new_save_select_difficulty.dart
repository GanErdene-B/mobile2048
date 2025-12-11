import 'package:flutter/material.dart';

class NewGameDifficultyPage extends StatefulWidget {
  @override
  _NewGameDifficultyPageState createState() => _NewGameDifficultyPageState();
}

class _NewGameDifficultyPageState extends State<NewGameDifficultyPage> {
  int? selected;

  final difficulties = [
    ["Амархан", "Хязгааргүй буцаах", "Хязгааргүй аврах", "Оноо 0.5x"],
    ["Энгийн", "10 Удаа буцаах", "4 Удаа аврах", "Оноо 1x"],
    ["Хүнд", "Буцаах боломжгүй", "Аврах боломжгүй", "Оноо 2x"],
  ];

  // Map representation of the currently selected difficulty (or null if none)
  Map<String, dynamic>? get selectedDifficultyData {
    if (selected == null) return null;
    final d = difficulties[selected!];
    return {
      'index': selected,
      'name': d[0],
      'rule1': d[1],
      'rule2': d[2],
      'multiplier': d[3],
      'selectedAt': DateTime.now().toIso8601String(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("2048"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Align(alignment: Alignment.centerLeft),
            const SizedBox(height: 12),

            // container that holds the options, different background + thin white border
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
                    Expanded(
                      child: ListView.builder(
                        itemCount: difficulties.length,
                        itemBuilder: (context, i) {
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () => setState(() => selected = i),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 14,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: List.generate(
                                        i + 1,
                                        (index) => Icon(
                                          Icons.star,
                                          size: 24,
                                          color: Colors.amber,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            difficulties[i][0],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            difficulties[i][1],
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          Text(
                                            difficulties[i][2],
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                          Text(
                                            difficulties[i][3],
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Radio<int>(
                                      value: i,
                                      groupValue: selected,
                                      onChanged: (v) =>
                                          setState(() => selected = v),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: selected == null
                          ? null
                          : () => Navigator.pushNamed(
                              context,
                              "/game",
                              arguments: selected,
                            ),
                      child: const Text("Continue"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
