import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../models/player_manager.dart';
import '../models/task_manager.dart';
import '../models/tasks.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialTasks();
    });
    _scheduleDailyTaskFetch();
  }

  Future<void> _loadInitialTasks() async {
    if (!mounted) return;
    final taskManager = Provider.of<TaskManager>(context, listen: false);
    await taskManager.loadTasks(context);

    if (!mounted) return;

    final loadedTasks = taskManager.activeTasks;
    for (int i = 0; i < loadedTasks.length; i++) {
      // We add a small delay to allow for a staggered animation effect
      await Future.delayed(const Duration(milliseconds: 50));
      _listKey.currentState?.insertItem(
        i,
        duration: const Duration(milliseconds: 300),
      );
    }

    if (taskManager.activeTasks.isEmpty) {
      await fetchTasksFromAI();
    }
  }

  @override
  void dispose() {
    _dailyTimer?.cancel();
    super.dispose();
  }

  void _scheduleDailyTaskFetch() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    _dailyTimer = Timer(durationUntilMidnight, () {
      if (mounted) {
        _handleDailyTasks();
      }
    });
  }

  Future<void> _handleDailyTasks() async {
    if (!mounted) return;
    final taskManager = Provider.of<TaskManager>(context, listen: false);
    taskManager.clearTasks();
    await fetchTasksFromAI();

    _dailyTimer = Timer.periodic(const Duration(hours: 24), (timer) async {
      if (mounted) {
        final taskManager = Provider.of<TaskManager>(context, listen: false);
        taskManager.clearTasks();
        await fetchTasksFromAI();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> fetchTasksFromAI() async {
    if (!mounted) return;
    final taskManager = Provider.of<TaskManager>(context, listen: false);
    final token = Provider.of<UserProvider>(context, listen: false).user.token;

    if (token.isEmpty) {
      print("Error: User token not available.");
      return;
    }

    // ✅ FIX: Use 'localhost' for desktop/web, '10.0.2.2' for Android emulator
    // When running as a desktop app, 'localhost' is correct.
    final uri = Uri.parse("http://localhost:5000/generate-task");

    try {
      final response = await http.get(uri);

      if (!mounted) return;

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> taskNames = data["tasks"];
        final List<dynamic> taskDiffs = data["difficulties"];

        final List<Task> tasksToInsert = [];
        for (int i = 0; i < taskNames.length; i++) {
          tasksToInsert.add(
            Task(
              name: taskNames[i] as String,
              priority: taskDiffs[i] as String,
            ),
          );
        }

        if (tasksToInsert.isEmpty) return;

        for (final task in tasksToInsert) {
          if (!mounted) return;
          int insertIndex = taskManager.activeTasks.length;

          await taskManager.addTask(task, token);

          _listKey.currentState?.insertItem(
            insertIndex,
            duration: const Duration(milliseconds: 300),
          );
          await Future.delayed(const Duration(milliseconds: 100));
        }
      } else {
        print("❌ AI Service Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception fetching AI tasks: $e");
    }
  }

  void gainXP(int amount) {
    if (!mounted) return;
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
            child: Image.asset(
              'assets/Background/home_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(flex: 25, child: _topProfileBar(player)),
                  const SizedBox(height: 10),
                  Expanded(flex: 10, child: _objectiveCard()),
                  const SizedBox(height: 10),
                  Expanded(flex: 60, child: _taskList()),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: BottomNavbar(),
                  ),
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
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user.name.isNotEmpty ? user.name : (player.name ?? "Player"),
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
        ),
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
            widthFactor: percent.clamp(0.0, 1.0),
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
        if (index >= taskManager.activeTasks.length)
          return const SizedBox.shrink();
        return _buildAnimatedTaskItem(
          taskManager.activeTasks[index],
          animation,
        );
      },
    );
  }

  Widget _buildAnimatedTaskItem(Task task, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: _taskCard(task),
    );
  }

  Widget _buildRemovedItem(Task task, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: _taskCard(task),
    );
  }

  Widget _taskCard(Task task) {
    final taskManager = Provider.of<TaskManager>(context, listen: false);
    final token = Provider.of<UserProvider>(context, listen: false).user.token;

    Color getPriorityColor(String priority) {
      switch (priority.toLowerCase()) {
        case 'low':
          return Colors.greenAccent;
        case 'medium':
          return Colors.orangeAccent;
        case 'high':
          return Colors.redAccent;
        default:
          return Colors.white;
      }
    }

    Color containerColor =
        task.status == TaskStatus.completed
            ? Colors.green.withOpacity(0.2)
            : (task.status == TaskStatus.deleted
                ? Colors.red.withOpacity(0.2)
                : Colors.white10);

    int getTaskIndex(Task t) => taskManager.activeTasks.indexWhere(
      (activeTask) => activeTask.id == t.id,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              final indexToRemove = getTaskIndex(task);
              if (indexToRemove != -1) {
                final taskToRemove = taskManager.activeTasks[indexToRemove];
                _listKey.currentState?.removeItem(
                  indexToRemove,
                  (context, animation) =>
                      _buildRemovedItem(taskToRemove, animation),
                  duration: const Duration(milliseconds: 500),
                );
                taskManager.deleteTask(taskToRemove, token);
              }
            },
            child: Image.asset('assets/icons/minus.png', width: 40),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.name,
                  style: _fantasyTextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  "Priority: ${task.priority}",
                  style: _fantasyTextStyle(
                    fontSize: 14,
                    color: getPriorityColor(task.priority),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (task.status == TaskStatus.pending) {
                final indexToRemove = getTaskIndex(task);
                if (indexToRemove != -1) {
                  final taskToComplete = taskManager.activeTasks[indexToRemove];
                  _listKey.currentState?.removeItem(
                    indexToRemove,
                    (context, animation) =>
                        _buildRemovedItem(taskToComplete, animation),
                    duration: const Duration(milliseconds: 500),
                  );
                  taskManager.completeTask(taskToComplete, token);
                  gainXP(500);
                }
              }
            },
            child: Image.asset('assets/icons/plus.png', width: 40),
          ),
        ],
      ),
    );
  }
}
