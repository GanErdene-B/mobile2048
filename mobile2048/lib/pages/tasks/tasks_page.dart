import 'package:flutter/material.dart';
import '../../widgets/bottom_nav.dart';

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNav2048(current: 1),
      body: SafeArea(
        child: Column(
          children: [
            Text("2048 Tasks", style: TextStyle(fontSize: 28)),
            Text("Completed: 3/10"),
            TabBarExample(),
          ],
        ),
      ),
    );
  }
}

class TabBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: "Daily"),
                Tab(text: "Weekly"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  TaskList(type: "Daily"),
                  TaskList(type: "Weekly"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  final String type;
  TaskList({required this.type});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text("$type Task 1"),
          subtitle: Text("Reward: 10 pts"),
          trailing: Icon(Icons.check_circle_outline),
        ),
        ListTile(
          title: Text("$type Task 2"),
          subtitle: Text("Reward: 20 pts"),
          trailing: Icon(Icons.circle_outlined),
        ),
      ],
    );
  }
}
