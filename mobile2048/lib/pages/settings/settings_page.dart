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
      body: ListView(
        children: [
          SizedBox(height: 40),
          Center(child: Text("2048 Settings", style: TextStyle(fontSize: 24))),
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
        ],
      ),
    );
  }
}
