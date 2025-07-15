import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  List<String> tasks = [
    "Tap here to edit this task",
    "Slay 10 Push-ups",
    "Read Scroll of Wisdom",
    "Clean Potion Shelf",
    "Water The Mystic Plant",
  ];

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
              _customBar(
                '',
                totalTasks == 0
                    ? 0
                    : completedTasks / (tasks.length + completedTasks),
              ),
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
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (_, i) => _taskCard(tasks[i], i),
    );
  }

  Widget _taskCard(String task, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amberAccent),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              // Action when minus icon is tapped
              HapticFeedback.selectionClick();
              setState(() {
                tasks.removeAt(index); // remove deleted task from list
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
                tasks.removeAt(index); // remove completed task from list
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
          Image.asset('assets/icons/todo.png', width: 50),
          Column(
            children: [
              Image.asset('assets/icons/profile.png', width: 30),
              const Text("Avatar", style: TextStyle(color: Colors.orange)),
            ],
          ),
          Image.asset('assets/icons/calender.png', width: 50),
          Image.asset('assets/icons/ai.png', width: 50),
        ],
      ),
    );
  }
}
