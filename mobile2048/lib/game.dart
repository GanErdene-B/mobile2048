import 'dart:math';

class Board {
  int row;
  int col;
  int score = 0;

  Board({required this.row, required this.col}) {
    initBoard();
  }

  late final List<List<Tile>> gameBoard;

  void initBoard() {
    gameBoard = List.generate(
      row,
      (r) => List.generate(
        col,
        (c) => Tile(row: r, col: c, value: 0, isMerged: false),
      ),
    );
    score = 0;
    randomEmptyTile(2);
  }

  void randomEmptyTile(int count) {
    final allEmptyTiles = <Tile>[];
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < col; c++) {
        if (gameBoard[r][c].isEmpty()) {
          allEmptyTiles.add(gameBoard[r][c]);
        }
      }
    }
    if (allEmptyTiles.isEmpty) {
      return;
    }
    for (int i = 0; i < count; i++) {
      Random random = Random();
      int randIndex = random.nextInt(allEmptyTiles.length);
      allEmptyTiles[randIndex].value = random.nextInt(10) == 0 ? 4 : 2;
      allEmptyTiles.remove(allEmptyTiles[randIndex]);
    }
  }

  bool canMerge(Tile a, Tile b) {
    return (!a.isMerged && (b.value == a.value && !b.isEmpty()) ||
        (a.isEmpty() && !b.isEmpty()));
  }

  void merge(Tile a, Tile b) {
    if (!canMerge(a, b)) {
      if (a.isEmpty() && !b.isEmpty()) {
        b.isMerged = true;
      }
    }

    if (a.isEmpty()) {
      a.value = b.value;
      b.value = 0;
    } else if (a.value == b.value) {
      a.value = a.value + b.value;
      a.isMerged = true;
      b.value = 0;
    } else {
      b.isMerged = true;
    }
  }

  // Mergers
  void mergeLeft(int r, int c) {
    while (c > 0) {
      merge(gameBoard[r][c - 1], gameBoard[r][c]);
      c--;
    }
  }

  void mergeRight(int r, int c) {
    while (c < col - 1) {
      merge(gameBoard[r][c + 1], gameBoard[r][c]);
      c++;
    }
  }

  void mergeUp(int r, int c) {
    while (r > 0) {
      merge(gameBoard[r - 1][c], gameBoard[r][c]);
      r--;
    }
  }

  void mergeDown(int r, int c) {
    while (r < row - 1) {
      merge(gameBoard[r + 1][c], gameBoard[r][c]);
      r++;
    }
  }

  // Movement Checkers
  bool canMoveLeft() {
    for (int r = 0; r < row; r++) {
      for (int c = 1; c < col; c++) {
        if (canMerge(gameBoard[r][c - 1], gameBoard[r][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveRight() {
    for (int r = 0; r < row; r++) {
      for (int c = col - 1; c >= 0; c--) {
        if (canMerge(gameBoard[r][c + 1], gameBoard[r][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveUp() {
    for (int c = 0; c < col; c++) {
      for (int r = 0; r < row; r++) {
        if (canMerge(gameBoard[r - 1][c], gameBoard[r][c])) {
          return true;
        }
      }
    }
    return false;
  }

  bool canMoveDown() {
    for (int c = 0; c < col; c++) {
      for (int r = row - 1; r >= 0; r--) {
        if (canMerge(gameBoard[r + 1][c], gameBoard[r][c])) {
          return true;
        }
      }
    }
    return false;
  }

  // Movements
  void moveLeft() {
    if (!canMoveLeft()) {
      return;
    }
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < col; c++) {
        mergeLeft(r, c);
      }
    }
    resetMergeState();
    randomEmptyTile(1);
  }

  void moveRight() {
    if (!canMoveRight()) {
      return;
    }
    for (int r = 0; r < row; r++) {
      for (int c = col - 1; c >= 0; c--) {
        mergeRight(r, c);
      }
    }
    resetMergeState();
    randomEmptyTile(1);
  }

  void moveUp() {
    if (!canMoveUp()) {
      return;
    }
    for (int c = 0; c < col; c++) {
      for (int r = 0; r < row; r++) {
        mergeUp(r, c);
      }
    }
    resetMergeState();
    randomEmptyTile(1);
  }

  void moveDown() {
    if (!canMoveDown()) {
      return;
    }
    for (int c = 0; c < col; c++) {
      for (int r = row - 1; r >= 0; r--) {
        mergeDown(r, c);
      }
    }
    resetMergeState();
    randomEmptyTile(1);
  }

  void resetMergeState() {
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < col; c++) {
        gameBoard[r][c].isMerged = false;
      }
    }
  }

  bool isGameOver() {
    return (!canMoveLeft() &&
        !canMoveRight() &&
        !canMoveUp() &&
        !canMoveDown());
  }
}

class Tile {
  int row;
  int col;
  int value;
  bool isMerged;

  Tile({
    required this.row,
    required this.col,
    required this.value,
    required this.isMerged,
  });

  bool isEmpty() {
    return value == 0;
  }
}
