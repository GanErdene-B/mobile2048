import 'api_service.dart';

/// Test API connectivity and database integration
Future<void> testApiConnection() async {
  print('\n========================================');
  print('API Connection Test');
  print('========================================\n');

  try {
    // Test 1: Health check
    print('📋 Test 1: Health Check...');
    final health = await ApiService.testConnection();
    print('✓ Health check passed');
    print('   Response: $health\n');

    // Test 2: Leaderboard fetch
    print('📋 Test 2: Leaderboard Fetch...');
    final leaderboard = await ApiService.testLeaderboard();
    print('✓ Leaderboard fetched successfully');
    print('   Entries: ${leaderboard.length}');
    if (leaderboard.isNotEmpty) {
      print('   Top entry: ${leaderboard.first}\n');
    } else {
      print('   (Empty leaderboard)\n');
    }

    // Test 3: Save game
    print('📋 Test 3: Save Game...');
    final save = await ApiService.testSave();
    print('✓ Save test passed');
    print('   Response: $save\n');

    print('========================================');
    print('✓ ALL TESTS PASSED');
    print('✓ Backend is connected');
    print('✓ Database is accessible');
    print('========================================\n');
  } catch (e) {
    print('========================================');
    print('✗ TEST FAILED');
    print('Error: $e');
    print('========================================\n');
  }
}
