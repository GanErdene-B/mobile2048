import 'package:flutter/material.dart';

class CrazyNumbersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text("Crazy Numbers")),
      body: Center(
        child: ElevatedButton(
          child: Text("Start / Continue"),
          onPressed: () => Navigator.pushNamed(context, "/game"),
        ),
      ),
    );
  }
}
