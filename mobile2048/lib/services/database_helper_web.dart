import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Box? _box;
  Future<Box> get box async {
    if (_box != null) return _box!;
    _box = await Hive.openBox('mobile2048');
    return _box!;
  }

  Future<String> insertGame(Map<String, dynamic> game) async {
    final b = await box;
    final uuid = const Uuid().v4();
    game['id'] = uuid;
    await b.put(uuid, jsonEncode(game));
    return uuid;
  }

  Future<List<Map<String, dynamic>>> getSavedGames({int limit = 50}) async {
    final b = await box;
    final keys = b.keys.toList().take(limit);
    return keys
        .map((k) => jsonDecode(b.get(k) as String) as Map<String, dynamic>)
        .toList();
  }

  Future<int> insertLeaderboardEntry(String player, int score) async {
    // Not implementing leaderboard for web in this quick fix
    return 0;
  }

  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    return [];
  }

  Future<int> deleteGameById(String id) async {
    final b = await box;
    if (b.containsKey(id)) {
      await b.delete(id);
      return 1;
    }
    return 0;
  }

  Future<Map<String, dynamic>?> getGameById(String id) async {
    final b = await box;
    if (b.containsKey(id)) {
      return jsonDecode(b.get(id) as String) as Map<String, dynamic>;
    }
    return null;
  }
}
