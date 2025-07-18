import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../pages/todo_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Variables:
  int level = 24;
  int xp = 2500;
  int xpLimit = 5000;
  int totalTasks = 5;
  int completedTasks = 0;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> tasks = [];

  @override
  void initState() {
    super.initState();
    fetchTasksFromAI();
  }

  void fetchTasksFromAI() async {
    final uri = Uri.parse("http://localhost:5000/generate-task");
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Add tasks one by one to AnimatedList
        for (int i = 0; i < data.length; i++) {
          final task = data[i] as String;
          tasks.insert(i, task);
          _listKey.currentState?.insertItem(
            i,
            duration: Duration(milliseconds: 300),
          );
          await Future.delayed(
            const Duration(milliseconds: 100),
          ); // For slight animation stagger
        }
      } else {
        print("Failed to load tasks: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void gainXP(int amount) {
    setState(() {
      xp += amount;

      while (xp >= xpLimit) {
        xp -= xpLimit; // Carry forward leftover XP
        level++; // Increase level
        xpLimit += 1000; // Optional: make each level harder

        // Optional feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("🎉 Level Up! You’re now Level $level")),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset('assets/Background.png', fit: BoxFit.cover),
          ),

          // UI content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Flexible(flex: 5, child: _topProfileBar()),
                  Flexible(flex: 2, child: _objectiveCard()),
                  Flexible(flex: 14, child: _taskList()),
                  Flexible(flex: 2, child: _bottomNavBar()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topProfileBar() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            Text(
              'Player',
              style: TextStyle(
                fontSize: 35,
                fontFamily: 'Cinzel',
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            _customBar('Level $level', level / 50),
            const SizedBox(height: 4),
            _customBar('XP: $xp', xp / xpLimit),
          ],
        ),
        const Spacer(),
        Image.asset('assets/warrior.png', width: 150),
      ],
    );
  }

  Widget _customBar(String label, double percent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Container(
          height: 8,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white24,
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percent,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.orange,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _objectiveCard() {
    final total = tasks.length + completedTasks;
    double progress = 0;
    if (total > 0) {
      progress = (completedTasks / total).clamp(0.0, 1.0);
    }
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orangeAccent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Objective",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          Row(
            children: [
              Expanded(child: _customBar('', progress)),
              const Spacer(),
              Text(
                "$completedTasks/${tasks.length + completedTasks}",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _taskList() {
    return AnimatedList(
      key: _listKey,
      initialItemCount: tasks.length,
      itemBuilder: (context, index, animation) {
        return _taskCard(tasks[index], index);
      },
    );
  }

  //for animated list
  Widget _buildRemovedItem(
    String task,
    int index,
    Animation<double> animation,
  ) {
    return Align(
      alignment: Alignment.center, // fix weird starting point
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.4, 0.0),
          end: const Offset(0.0, 0.0), // slide slightly left
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: FadeTransition(
          opacity: animation,
          child: _taskCard(task, index), // your full task card
        ),
      ),
    );
  }

  Widget _taskCard(String task, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Action when minus icon is tapped
              HapticFeedback.selectionClick();
              setState(() {
                // remove deleted task from list
                final removedTask = tasks[index];
                tasks.removeAt(index);
                _listKey.currentState!.removeItem(
                  index,
                  (context, animation) =>
                      _buildRemovedItem(removedTask, index, animation),
                  duration: const Duration(milliseconds: 500),
                );
              });
            },
            child: Image.asset('assets/icons/minus.png', width: 60),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              task,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Action when plus icon is tapped
              HapticFeedback.lightImpact();
              setState(() {
                completedTasks++;
                // remove completed task from list
                final removedTask = tasks[index];
                tasks.removeAt(index);
                _listKey.currentState!.removeItem(
                  index,
                  (context, animation) =>
                      _buildRemovedItem(removedTask, index, animation),
                  duration: const Duration(milliseconds: 500),
                );
              });
              gainXP(2000); //  Use XP function
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("+2000 XP for completing: $task")),
              );
            },
            child: Image.asset('assets/icons/plus.png', width: 60),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset('assets/icons/home.png', width: 50),
          GestureDetector(
            onTap: () {
              // Action when minus icon is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TodoScreen()),
              );
            },
            child: Image.asset('assets/icons/todo.png', width: 60),
          ),

          //Column(
          // children: [
          Image.asset('assets/icons/profile.png', width: 70),
          //const Text("Avatar", style: TextStyle(color: Colors.orange)),
          //],
          //),
          Image.asset('assets/icons/calender.png', width: 50),
          Image.asset('assets/icons/ai.png', width: 50),
        ],
      ),
    );
  }
}
