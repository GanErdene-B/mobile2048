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
            // put title and score side-by-side (now with outer padding)
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 8, 60, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("2048", style: TextStyle(fontSize: 32)),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFD264),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text("Оноо : 120", style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
            ),
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
            // colored container holding the TabBar and the thin header row
            Container(
              color: Color(0xFF91E6F5),
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.black54,
                    indicatorColor: Colors.black87,
                    tabs: [
                      Tab(text: "Daily"),
                      Tab(text: "Weekly"),
                    ],
                  ),
                  // thin header row with three labels aligned to task columns
                  Container(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black12, width: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "tasks",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Text(
                              "points",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 56,
                          child: Center(
                            child: Text(
                              "status",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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

  // sample tasks (in real app, keep state elsewhere)
  final List<Task> _tasks = [
    Task(name: 'Task 1', points: 10, completed: true),
    Task(name: 'Task 2', points: 20, completed: false),
  ];

  // expose tasks as plain maps for DB/queries
  List<Map<String, dynamic>> getTasksState() {
    return _tasks.map((t) => t.toMap(type: type)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // white background for the actual task list
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // example task rows (repeat / generate as needed)
          _taskRow("$type Task 1", "10 pts", Icons.check_circle, true),
          _taskRow(
            "$type Task 2",
            "20 pts",
            Icons.radio_button_unchecked,
            false,
          ),
        ],
      ),
    );
  }

  Widget _taskRow(String name, String points, IconData icon, bool done) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(name, style: TextStyle(fontSize: 16)),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFD264),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    points,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 56,
              child: Center(
                child: Icon(icon, color: done ? Colors.green : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// simple model useful for serialization / queries
class Task {
  final String name;
  final int points;
  final bool completed;

  Task({required this.name, required this.points, required this.completed});

  Map<String, dynamic> toMap({String? type}) {
    return {
      'type': type ?? 'unknown',
      'name': name,
      'points': points,
      'completed': completed,
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }
}
