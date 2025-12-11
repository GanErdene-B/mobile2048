import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool sound = true;
  bool vibration = true;

  // Provide a plain map representation of current settings for DB storage / queries
  Map<String, dynamic> get settingsData => {
    'sound': sound,
    'vibration': vibration,
    'updatedAt': DateTime.now().toIso8601String(),
  };

  // placeholder save settings helper
  void saveSettings() {
    debugPrint('SETTINGS_SAVE: $settingsData');
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
          // optional: small save button to persist settings
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
        ],
      ),
    );
  }
}
