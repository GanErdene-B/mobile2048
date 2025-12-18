import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // DELETE /api/games/:id
  static Future<bool> deleteGameById(String id) async {
    await _resolveBaseUrl();
    final uri = _makeUri('/api/games/$id');
    final resp = await http
        .delete(uri, headers: _defaultHeaders())
        .timeout(const Duration(seconds: 6));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
      return decoded['ok'] == true;
    }
    throw Exception('Delete failed: ${resp.statusCode}');
  }

  // Try to resolve the correct base URL once at runtime and cache it.
  // You can still override using --dart-define=API_BASE_URL=...
  static final String _envBase = const String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static final String _apiKey = const String.fromEnvironment(
    'API_KEY',
    defaultValue: 'uz5y7iu9x1mnf4atz2g8jr4he',
  );
  static String? _resolvedBaseUrl;
  static int _retryCount = 0;
  static const int _maxRetries = 3;

  static final List<String> _candidates = [
    // if provided at build/run time
    _envBase,
    // Docker Desktop on mac/windows exposes host as host.docker.internal
    'http://host.docker.internal:3000',
    // Android emulator
    'http://10.0.2.2:3000',
    // local machine
    'http://localhost:3000',
    'http://127.0.0.1:3000',
  ];

  static Map<String, String> _defaultHeaders() => {
    'Content-Type': 'application/json',
    'x-api-key': _apiKey,
  };

  // Resolve a working base URL by probing /api/health or /api/leaderboard with retry
  static Future<void> _resolveBaseUrl() async {
    if (_resolvedBaseUrl != null) return;

    for (final candidate in _candidates) {
      if (candidate == null || candidate.isEmpty) continue;

      // Try with retries for each candidate
      for (int attempt = 0; attempt < _maxRetries; attempt++) {
        try {
          final uri = Uri.parse('$candidate/api/health');
          final resp = await http
              .get(uri, headers: _defaultHeaders())
              .timeout(const Duration(seconds: 2));
          if (resp.statusCode >= 200 && resp.statusCode < 300) {
            _resolvedBaseUrl = candidate;
            return;
          }
          // fallback try leaderboard if no /api/health present
          final uri2 = Uri.parse('$candidate/api/leaderboard');
          final resp2 = await http
              .get(uri2, headers: _defaultHeaders())
              .timeout(const Duration(seconds: 2));
          if (resp2.statusCode >= 200 && resp2.statusCode < 300) {
            _resolvedBaseUrl = candidate;
            return;
          }
        } catch (e) {
          if (attempt < _maxRetries - 1) {
            // Wait briefly before retry
            await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
          }
        }
      }
    }
    // If none worked, fall back to env or first candidate (useful for error messages)
    _resolvedBaseUrl = _envBase.isNotEmpty ? _envBase : _candidates.last;
  }

  static Uri _makeUri(String path) {
    final base = _resolvedBaseUrl ?? _candidates.last;
    return Uri.parse('$base$path');
  }

  // POST /api/save
  static Future<Map<String, dynamic>> saveGame(
    Map<String, dynamic> payload,
  ) async {
    await _resolveBaseUrl();
    final uri = _makeUri('/api/save');
    final resp = await http
        .post(uri, headers: _defaultHeaders(), body: jsonEncode(payload))
        .timeout(const Duration(seconds: 6));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Save failed: ${resp.statusCode} ${resp.body}');
  }

  // GET /api/leaderboard
  static Future<List<Map<String, dynamic>>> getLeaderboard() async {
    await _resolveBaseUrl();
    final uri = _makeUri('/api/leaderboard');
    final resp = await http
        .get(uri, headers: _defaultHeaders())
        .timeout(const Duration(seconds: 6));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
      final items = decoded['leaderboard'] as List<dynamic>? ?? [];
      return items.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    throw Exception('Leaderboard fetch failed: ${resp.statusCode}');
  }

  // GET /api/games
  static Future<List<Map<String, dynamic>>> getSavedGames() async {
    await _resolveBaseUrl();
    final uri = _makeUri('/api/games');
    final resp = await http
        .get(uri, headers: _defaultHeaders())
        .timeout(const Duration(seconds: 6));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final decoded = jsonDecode(resp.body) as Map<String, dynamic>;
      final items = decoded['games'] as List<dynamic>? ?? [];
      return items.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    throw Exception('Fetch games failed: ${resp.statusCode}');
  }

  // TEST: Ping the backend to verify connectivity
  static Future<Map<String, dynamic>> testConnection() async {
    await _resolveBaseUrl();
    final uri = _makeUri('/api/health');
    final resp = await http
        .get(uri, headers: _defaultHeaders())
        .timeout(const Duration(seconds: 6));
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      return jsonDecode(resp.body) as Map<String, dynamic>;
    }
    throw Exception('Health check failed: ${resp.statusCode}');
  }

  // TEST: Verify leaderboard connectivity
  static Future<List<Map<String, dynamic>>> testLeaderboard() async {
    return getLeaderboard();
  }

  // TEST: Verify save endpoint with a test payload
  static Future<Map<String, dynamic>> testSave() async {
    final testPayload = {
      'board': {'row': 4, 'col': 4, 'score': 100},
      'bestScore': 100,
      'undoCount': 5,
      'timestamp': DateTime.now().toIso8601String(),
      'size': 4,
      'player': 'TestUser',
    };
    return saveGame(testPayload);
  }
}
