import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav2048(current: 0),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "2048",
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Тоглох төрлөө сонгоно уу",
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, "/campaign"),
                    child: Text("Энгийн"),
                  ),
                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, "/missions"),
                    child: Text("Нэмэлт"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
