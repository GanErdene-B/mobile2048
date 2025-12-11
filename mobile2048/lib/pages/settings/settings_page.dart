import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';
import '../../services/api_service.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool sound = true;
  bool vibration = true;
  String? testStatus;
  bool isTesting = false;

  // Provide a plain map representation of current settings for DB storage / queries
  Map<String, dynamic> get settingsData => {
    'sound': sound,
    'vibration': vibration,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  // placeholder save settings helper
  void saveSettings() {
    debugPrint('SETTINGS_SAVE: $settingsData');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved')),
    );
  }

  // Test API connection
  Future<void> testApiConnection() async {
    setState(() {
      isTesting = true;
      testStatus = 'Testing...';
    });

    try {
      // Test 1: Health check
      debugPrint('Testing health check...');
      final health = await ApiService.testConnection();
      debugPrint('✓ Health check passed: $health');

      // Test 2: Leaderboard fetch
      debugPrint('Testing leaderboard fetch...');
      final leaderboard = await ApiService.testLeaderboard();
      debugPrint('✓ Leaderboard fetched: ${leaderboard.length} entries');

      // Test 3: Save game
      debugPrint('Testing save endpoint...');
      final save = await ApiService.testSave();
      debugPrint('✓ Save test passed: $save');

      setState(() {
        testStatus = '✓ All tests passed!\n✓ Connected to backend\n✓ Leaderboard OK\n✓ Save OK';
        isTesting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✓ API connection successful')),
      );
    } catch (e) {
      debugPrint('✗ Test failed: $e');
      setState(() {
        testStatus = '✗ Connection failed:\n$e';
        isTesting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✗ Connection failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav2048(current: 3),
      body: ListView(
        children: [
          SizedBox(height: 40),
          Center(
            child: Text(
              "2048",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          SwitchListTile(
            title: Text("Sound Effects"),
            value: sound,
            onChanged: (v) => setState(() => sound = v),
          ),
          SwitchListTile(
            title: Text("Vibration"),
            value: vibration,
            onChanged: (v) => setState(() => vibration = v),
          ),
          // Save settings button
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 8.0,
            ),
            child: ElevatedButton(
              onPressed: saveSettings,
              child: Text('Save settings'),
            ),
          ),
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
            child: Divider(),
          ),
          // Test API Connection section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'API Connection Test',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ElevatedButton(
              onPressed: isTesting ? null : testApiConnection,
              child: isTesting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Test Backend Connection'),
            ),
          ),
          if (testStatus != null) ...[
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: testStatus!.contains('✓')
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: testStatus!.contains('✓')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
                child: Text(
                  testStatus!,
                  style: TextStyle(
                    fontSize: 14,
                    color: testStatus!.contains('✓')
                        ? Colors.green.shade900
                        : Colors.red.shade900,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
