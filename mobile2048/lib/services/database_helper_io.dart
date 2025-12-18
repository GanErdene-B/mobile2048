import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _db;
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'mobile2048.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE games(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data TEXT,
        bestScore INTEGER,
        undoCount INTEGER,
        timestamp TEXT,
        size INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE leaderboard(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        player TEXT,
        score INTEGER,
        timestamp TEXT
      )
    ''');
  }

  Future<int> insertGame(Map<String, dynamic> game) async {
    final db = await database;
    // If no id, assign a new one
    if (!game.containsKey('id')) {
      game['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    }
    final row = {
      'id': game['id'],
      'data': jsonEncode(game),
      'bestScore': game['bestScore'] ?? 0,
      'undoCount': game['undoCount'] ?? 0,
      'timestamp': game['timestamp'] ?? DateTime.now().toIso8601String(),
      'size': game['size'] ?? 4,
    };
    return await db.insert(
      'games',
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getSavedGames({int limit = 50}) async {
    final db = await database;
    final rows = await db.query(
      'games',
      orderBy: 'timestamp DESC',
      limit: limit,
    );
    return rows.map((row) {
      final data = jsonDecode(row['data'] as String) as Map<String, dynamic>;
      data['id'] = row['id'];
      return data;
    }).toList();
  }

  Future<int> insertLeaderboardEntry(String player, int score) async {
    final db = await database;
    final row = {
      'player': player,
      'score': score,
      'timestamp': DateTime.now().toIso8601String(),
    };
    return await db.insert('leaderboard', row);
  }

  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    final db = await database;
    final rows = await db.query(
      'leaderboard',
      orderBy: 'score DESC',
      limit: limit,
    );
    return rows;
  }

  // Delete a saved game by slot index (row used as slotIndex for compatibility)
  Future<int> deleteGameById(String id) async {
    final db = await database;
    return await db.delete('games', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getGameById(String id) async {
    final db = await database;
    final rows = await db.query(
      'games',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isNotEmpty) {
      final data =
          jsonDecode(rows.first['data'] as String) as Map<String, dynamic>;
      data['id'] = rows.first['id'];
      return data;
    }
    return null;
  }
}
