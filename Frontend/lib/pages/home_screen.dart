import 'dart:async'; // Import the Timer class
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/player_manager.dart';
import '../models/task_manager.dart';
import '../pages/bottom_navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> tasks = [];
  Timer? _dailyTimer; // Timer for daily task reset

  @override
  void initState() {
    super.initState();
    // Schedule the first task fetch at the next midnight
    _scheduleDailyTaskFetch();
    // Initially fetch tasks when the screen is first loaded
    // Only if there are no tasks yet
    final taskManager = Provider.of<TaskManager>(context, listen: false);
    if (taskManager.tasks.isEmpty) {
      fetchTasksFromAI();
    } else {
      tasks = List.from(taskManager.tasks);
    }
  }

  @override
  void dispose() {
    // Cancel the timer to prevent memory leaks
    _dailyTimer?.cancel();
    super.dispose();
  }

  void _scheduleDailyTaskFetch() {
    // Calculate the time until the next midnight
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0);
    final durationUntilMidnight = nextMidnight.difference(now);

    // Schedule the timer to run at the next midnight
    _dailyTimer = Timer(durationUntilMidnight, () {
      // Get the TaskManager instance
      final taskManager = Provider.of<TaskManager>(context, listen: false);

      // Clear all existing tasks
      taskManager.clearTasks();

      // Fetch new tasks from the AI
      fetchTasksFromAI();

      // Schedule a recurring timer to run every 24 hours
      _dailyTimer = Timer.periodic(const Duration(hours: 24), (timer) {
        taskManager.clearTasks();
        fetchTasksFromAI();
      });
    });
  }

  void fetchTasksFromAI() async {
    final taskManager = Provider.of<TaskManager>(context, listen: false);
    final uri = Uri.parse("http://localhost:5000/generate-task");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        // Clear local tasks list and add new tasks from the API
        setState(() {
          tasks.clear();
        });

        // Loop through the received tasks and add them with an animation
        for (int i = 0; i < data.length && i < 7; i++) {
          final task = data[i] as String;
          taskManager.addTask(task);
          setState(() {
            tasks.insert(i, task);
          });
          _listKey.currentState?.insertItem(
            i,
            duration: const Duration(milliseconds: 300),
          );
          await Future.delayed(const Duration(milliseconds: 100));
        }
      } else {
        print("Failed to load tasks: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void gainXP(int amount) {
    final player = Provider.of<PlayerManager>(context, listen: false);
    player.gainXP(amount);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "+$amount XP! Level: ${player.level}",
          style: _fantasyTextStyle(),
        ),
      ),
    );
  }

  TextStyle _fantasyTextStyle({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      fontFamily: 'Cinzel',
      color: color ?? Colors.white,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: fontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerManager>(context); // ✅ shared player state

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('Background/home_bg.png', fit: BoxFit.fill),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Flexible(flex: 5, child: _topProfileBar(player)),
                  Flexible(flex: 2, child: _objectiveCard()),
                  Flexible(flex: 14, child: _taskList()),
                  Flexible(flex: 2, child: BottomNavbar()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topProfileBar(PlayerManager player) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              player.name,
              style: _fantasyTextStyle(
                fontSize: 35,
                color: Colors.orangeAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            _customBar('Level ${player.level}', player.level / 50),
            const SizedBox(height: 4),
            _customBar('XP: ${player.xp}', player.xp / player.xpLimit),
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
        Text(label, style: _fantasyTextStyle(color: Colors.white)),
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
    final taskManager = Provider.of<TaskManager>(context);
    double progress = 0;
    if (taskManager.totalTasks > 0) {
      progress = (taskManager.completedTasks / taskManager.totalTasks).clamp(
        0.0,
        1.0,
      );
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
          Text("Objective", style: _fantasyTextStyle(fontSize: 16)),
          Row(
            children: [
              Expanded(child: _customBar('', progress)),
              const Spacer(),
              Text(
                "${taskManager.completedTasks}/${taskManager.totalTasks}",
                style: _fantasyTextStyle(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _taskList() {
    final taskManager = Provider.of<TaskManager>(context);

    return AnimatedList(
      key: _listKey,
      initialItemCount: taskManager.tasks.length,
      itemBuilder: (context, index, animation) {
        return _taskCard(taskManager.tasks[index], index);
      },
    );
  }

  Widget _buildRemovedItem(
    String task,
    int index,
    Animation<double> animation,
  ) {
    return Align(
      alignment: Alignment.center,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.4, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: FadeTransition(
          opacity: animation,
          child: _taskCard(task, index),
        ),
      ),
    );
  }

  Widget _taskCard(String task, int index) {
    final taskManager = Provider.of<TaskManager>(context, listen: false);

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
              HapticFeedback.selectionClick();
              final removedTask = taskManager.tasks[index];
              taskManager.removeTask(index);

              _listKey.currentState!.removeItem(
                index,
                (context, animation) =>
                    _buildRemovedItem(removedTask, index, animation),
                duration: const Duration(milliseconds: 500),
              );
            },
            child: Image.asset('assets/icons/minus.png', width: 60),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(task, style: _fantasyTextStyle(fontSize: 16))),
          GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              final taskManager = Provider.of<TaskManager>(
                context,
                listen: false,
              );
              final task = taskManager.tasks[index];
              taskManager.completeTask(index);
              _listKey.currentState!.removeItem(
                index,
                (context, animation) =>
                    _buildRemovedItem(task, index, animation),
                duration: const Duration(milliseconds: 500),
              );

              gainXP(500);
            },
            child: Image.asset('assets/icons/plus.png', width: 60),
          ),
        ],
      ),
    );
  }
}
