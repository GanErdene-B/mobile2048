import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool sound = true;
  bool vibration = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav2048(current: 3),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF5AA5D7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6),
                    width: 0.8,
                  ),
                ),
                child: ListView(
                  children: [
                    const SizedBox(height: 24),
                    Column(
                      children: [
                        Text(
                          "2048",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Settings", style: TextStyle(fontSize: 22)),
                      ],
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
