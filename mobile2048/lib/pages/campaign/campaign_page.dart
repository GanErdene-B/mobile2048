import 'package:flutter/material.dart';

class CampaignPage extends StatelessWidget {
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
          Text("Choose Game Slot", style: TextStyle(fontSize: 22)),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(20),
              itemCount: 4,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (_, i) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/campaign-new");
                  },
                  child: Card(
                    elevation: 2,
                    child: Center(child: Text("Save Slot ${i + 1}")),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
