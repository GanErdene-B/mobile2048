import 'package:flutter/material.dart';
import '../game/game.dart';
import '../game/game_ui.dart';

class GamePage extends StatefulWidget {
  final int size; // e.g., 4 for 4×4 board

  const GamePage({super.key, this.size = 4});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Board board;
  int bestScore = 0;

  // number of available rewinds; expose for saving
  int undoCount = 0;

  @override
  void initState() {
    super.initState();
    board = Board(row: widget.size, col: widget.size);
  }

  // prepare a plain map of everything necessary to save / query the current game
  Map<String, dynamic> getSaveData() {
    return {
      'board': board.toMap(),
      'bestScore': bestScore,
      'undoCount': undoCount,
      'timestamp': DateTime.now().toIso8601String(),
      'size': widget.size,
    };
  }

  // placeholder save method - replace with actual DB call
  Future<void> saveGame() async {
    final payload = getSaveData();
    // TODO: send payload to DB here. For now just print so it's query-able during testing.
    debugPrint('SAVE_PAYLOAD: $payload');
  }

  void handleSwipe(DragEndDetails details, Axis axis) {
    final velocity = details.primaryVelocity;
    if (velocity == null) return;

    setState(() {
      if (axis == Axis.vertical) {
        // Negative velocity = swipe up, Positive = swipe down
        if (velocity < 0) {
          board.moveUp();
        } else {
          board.moveDown();
        }
      } else {
        // Axis.horizontal
        // Negative velocity = swipe left, Positive = swipe right
        if (velocity < 0) {
          board.moveLeft();
        } else {
          board.moveRight();
        }
      }
      // Update best score if current exceeds it
      if (board.score > bestScore) {
        bestScore = board.score;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("2048"), centerTitle: true),
      body: GestureDetector(
        onVerticalDragEnd: (details) => handleSwipe(details, Axis.vertical),
        onHorizontalDragEnd: (details) => handleSwipe(details, Axis.horizontal),

        child: Column(
          children: [
            const SizedBox(height: 12),

            // Three info fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Буцаах",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "0",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Оноо",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${board.score}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Дээд оноо",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$bestScore",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: Center(child: GameUI(board: board)),
            ),

            const SizedBox(height: 16),

            // Three action buttons at bottom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Rewind button
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: implement rewind logic
                    },
                    icon: Icon(Icons.undo),
                    label: Text("Буцаах"),
                  ),
                  // Save button
                  ElevatedButton.icon(
                    onPressed: () => saveGame(),
                    icon: Icon(Icons.save),
                    label: Text("Хадгалах"),
                  ),
                  // Delete button
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: implement delete logic
                    },
                    icon: Icon(Icons.delete),
                    label: Text("Устгах"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
