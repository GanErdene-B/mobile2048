import '../services/database_helper.dart';
import 'package:flutter/material.dart';
import '../game/game.dart';
import '../game/game_ui.dart';
import '../services/api_service.dart';

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
  int undoCount = 10;

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

    // Ask for optional player name before sending to backend (simple dialog)
    String? playerName = await showDialog<String?>(
      context: context,
      builder: (ctx) {
        String name = '';
        return AlertDialog(
          title: const Text('Save game'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'Player name (optional)'),
            onChanged: (v) => name = v,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Cancel')),
            TextButton(onPressed: () => Navigator.of(ctx).pop(name.trim().isEmpty ? null : name.trim()), child: const Text('Save')),
          ],
        );
      },
    );

    // include player name if provided
    if (playerName != null) {
      payload['player'] = playerName;
    }

    try {
      // first write locally (optional)
      await DatabaseHelper.instance.insertGame(payload);

      // then attempt to send to backend
      final resp = await ApiService.saveGame(payload);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Saved (server ok: ${resp['ok'] == true})')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Save failed: $e')),
      );
    }
  }

  // Rewind the last move
  void rewindGame() {
    if (!board.canRewind()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No moves to rewind')),
      );
      return;
    }

    setState(() {
      board.rewind();
      undoCount--;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rewound! Rewinds left: $undoCount')),
    );
  }

  // Delete the current save and return to campaign page
  void deleteGame() {
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Save'),
        content: const Text('Are you sure? This will reset all progress and return you to the save selection screen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        // Reset game state and navigate back to campaign
        try {
          DatabaseHelper.instance.deleteGame(board.row, board.col);
        } catch (_) {
          // ignore if DB not available
        }
        Navigator.pushReplacementNamed(context, '/campaign');
      }
    });
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
                    onPressed: board.canRewind() ? rewindGame : null,
                    icon: const Icon(Icons.undo),
                    label: Text("Буцаах ($undoCount)"),
                  ),
                  // Save button
                  ElevatedButton.icon(
                    onPressed: () => saveGame(),
                    icon: const Icon(Icons.save),
                    label: const Text("Хадгалах"),
                  ),
                  // Delete button
                  ElevatedButton.icon(
                    onPressed: deleteGame,
                    icon: const Icon(Icons.delete),
                    label: const Text("Устгах"),
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
