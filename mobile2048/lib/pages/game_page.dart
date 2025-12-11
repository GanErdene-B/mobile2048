import '../services/database_helper.dart';
import 'package:flutter/material.dart';
import '../game/game.dart';
import '../game/game_ui.dart';
import '../services/api_service.dart';

class GamePage extends StatefulWidget {
  final int size;

  const GamePage({super.key, this.size = 4});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Board board;
  int bestScore = 0;
  int undoCount = 10;
  String difficulty = 'Unknown';
  bool isRestoredGame = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    // Don't access ModalRoute here; defer to didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize after the widget tree is fully built
    if (!_initialized) {
      _initializeGame();
      _initialized = true;
    }
  }

  void _initializeGame() {
    // Get arguments passed from campaign page
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args != null && args['gameData'] != null) {
      // Restore from saved game
      final gameData = args['gameData'];
      final boardData = gameData['board'];
      
      board = Board.fromMap(boardData);
      bestScore = gameData['bestScore'] ?? 0;
      undoCount = gameData['undoCount'] ?? 10;
      difficulty = args['difficulty'] ?? 'Unknown';
      isRestoredGame = true;
    } else {
      // Start new game
      board = Board(row: widget.size, col: widget.size);
      difficulty = args?['difficulty'] ?? 'Unknown';
      isRestoredGame = false;
    }
  }

  // prepare a plain map of everything necessary to save / query the current game
  Map<String, dynamic> getSaveData() {
    return {
      'board': board.toMap(),
      'bestScore': bestScore,
      'undoCount': undoCount,
      'timestamp': DateTime.now().toIso8601String(),
      'size': widget.size,
      'difficulty': difficulty,
    };
  }

  // Save game with optional player name
  Future<void> saveGame() async {
    final payload = getSaveData();

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

    if (playerName != null) {
      payload['player'] = playerName;
    }

    try {
      // Write locally
      await DatabaseHelper.instance.insertGame(payload);

      // Send to backend
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
        try {
          DatabaseHelper.instance.deleteGame(board.row, board.col);
        } catch (_) {}
        Navigator.pushReplacementNamed(context, '/campaign');
      }
    });
  }

  void handleSwipe(DragEndDetails details, Axis axis) {
    final velocity = details.primaryVelocity;
    if (velocity == null) return;

    setState(() {
      if (axis == Axis.vertical) {
        if (velocity < 0) {
          board.moveUp();
        } else {
          board.moveDown();
        }
      } else {
        if (velocity < 0) {
          board.moveLeft();
        } else {
          board.moveRight();
        }
      }
      if (board.score > bestScore) {
        bestScore = board.score;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2048 - $difficulty"),
        centerTitle: true,
      ),
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
                            "$undoCount",
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
                  ElevatedButton.icon(
                    onPressed: board.canRewind() ? rewindGame : null,
                    icon: const Icon(Icons.undo),
                    label: Text("Буцаах ($undoCount)"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => saveGame(),
                    icon: const Icon(Icons.save),
                    label: const Text("Хадгалах"),
                  ),
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
