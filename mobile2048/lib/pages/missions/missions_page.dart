import 'package:flutter/material.dart';

class MissionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: BackButton(), title: Text("2048")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/crazy-numbers'),
          child: Text("Crazy Numbers"),
        ),
      ),
    );
  }
}
