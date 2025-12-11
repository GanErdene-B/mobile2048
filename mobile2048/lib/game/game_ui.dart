import 'package:flutter/material.dart';
import '../game/tile_widget.dart';
import 'game.dart';

class GameUI extends StatelessWidget {
  final Board board;

  const GameUI({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: GridView.builder(
        key: ValueKey(board.hashCode),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: board.row,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemCount: board.row * board.col,
        itemBuilder: (context, index) {
          final r = index ~/ board.col;
          final c = index % board.col;
          final value = board.gameBoard[r][c].value;

          return TileWidget(value: value);
        },
      ),
    );
  }
}
