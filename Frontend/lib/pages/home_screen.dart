import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../models/task_manager.dart';
import '../models/tasks.dart';
import '../models/player_manager.dart';
import '../pages/bottom_navbar.dart';
import '../providers/user_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  Timer? _dailyTimer;

  @override
  void initState() {
    super.initState();
    _scheduleDailyTaskFetch();

    final taskManager = Provider.of<TaskManager>(context, listen: false);
    if (taskManager.activeTasks.isEmpty) {
      fetchTasksFromAI();
    }
  }

  @override
  void dispose() {
    _dailyTimer?.cancel();
    super.dispose();
  }

  void _scheduleDailyTaskFetch() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1, 0, 0);
    final durationUntilMidnight = nextMidnight.difference(now);

    _dailyTimer = Timer(durationUntilMidnight, () {
      final taskManager = Provider.of<TaskManager>(context, listen: false);
      taskManager.clearTasks();
      fetchTasksFromAI();

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
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> taskNames = data["tasks"];
        final List<dynamic> taskDiffs = data["difficulties"];

        for (int i = 0; i < taskNames.length && i < 7; i++) {
          final task = Task(
            name: taskNames[i] as String,
            difficulty: taskDiffs[i] as String,
          );
          taskManager.addTask(task);
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
    final player = Provider.of<PlayerManager>(context);

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
                  const Flexible(flex: 2, child: BottomNavbar()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topProfileBar(PlayerManager player) {
    final user = Provider.of<UserProvider>(context).user;
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              user.name.isNotEmpty ? user.name : player.name,
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
      initialItemCount: taskManager.activeTasks.length,
      itemBuilder: (context, index, animation) {
        return _taskCard(taskManager.activeTasks[index], index);
      },
    );
  }

  Widget _buildRemovedItem(Task task, int index, Animation<double> animation) {
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

  Widget _taskCard(Task task, int index) {
    final taskManager = Provider.of<TaskManager>(context, listen: false);

    Color getDifficultyColor(String difficulty) {
      switch (difficulty.toLowerCase()) {
        case 'low':
        case '1':
          return Colors.greenAccent;
        case 'medium':
        case '2':
          return Colors.orangeAccent;
        case 'high':
        case '3':
          return Colors.redAccent;
        default:
          return Colors.white;
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color:
            task.status == TaskStatus.completed
                ? Colors.green.withOpacity(0.2)
                : task.status == TaskStatus.deleted
                ? Colors.red.withOpacity(0.2)
                : Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Delete button
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              taskManager.deleteTask(index);

              _listKey.currentState!.removeItem(
                index,
                (context, animation) =>
                    _buildRemovedItem(task, index, animation),
                duration: const Duration(milliseconds: 500),
              );
            },
            child: Image.asset('assets/icons/minus.png', width: 40),
          ),
          const SizedBox(width: 12),

          // Task details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: _fantasyTextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "Difficulty: ${task.difficulty}",
                  style: _fantasyTextStyle(
                    fontSize: 14,
                    color: getDifficultyColor(task.difficulty),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Complete button
          GestureDetector(
            onTap: () {
              if (task.status == TaskStatus.pending) {
                HapticFeedback.lightImpact();
                taskManager.completeTask(index);

                _listKey.currentState!.removeItem(
                  index,
                  (context, animation) =>
                      _buildRemovedItem(task, index, animation),
                  duration: const Duration(milliseconds: 500),
                );

                gainXP(500);
              }
            },
            child: Image.asset('assets/icons/plus.png', width: 40),
          ),
        ],
      ),
    );
  }
}
