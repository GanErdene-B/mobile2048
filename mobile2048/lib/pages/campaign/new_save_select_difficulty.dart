import 'package:flutter/material.dart';

class NewGameDifficultyPage extends StatefulWidget {
  @override
  _NewGameDifficultyPageState createState() => _NewGameDifficultyPageState();
}

class _NewGameDifficultyPageState extends State<NewGameDifficultyPage> {
  int? selected;

  final difficulties = [
    ["Easy", "4x4 Board", "Chill experience"],
    ["Normal", "4x4 Board", "Standard 2048"],
    ["Hard", "5x5 Board", "More strategy"],
    ["Extreme", "6x6 Board", "For pros"],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("2048"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: difficulties.length,
              itemBuilder: (_, i) {
                return ListTile(
                  leading: Icon(Icons.grid_4x4),
                  title: Text(difficulties[i][0]),
                  subtitle: Text(
                    "${difficulties[i][1]} • ${difficulties[i][2]}",
                  ),
                  trailing: Radio(
                    value: i,
                    groupValue: selected,
                    onChanged: (v) => setState(() => selected = v as int),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: selected == null
                ? null
                : () => Navigator.pushNamed(
                    context,
                    "/game",
                    arguments: selected,
                  ),
            child: Text("Continue"),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
