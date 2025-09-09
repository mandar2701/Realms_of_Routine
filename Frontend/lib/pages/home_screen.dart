import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/player_manager.dart';
import '../pages/todo_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pages/profile.dart';
import '../pages/game.dart';
import '../models/task_manager.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<String> tasks = [];

  final supabase = Supabase.instance.client;
  String? username;
  bool isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTasksFromAI();
    });
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final response =
        await supabase
            .from('profiles')
            .select('username')
            .eq('id', user.id)
            .maybeSingle();

    if (mounted && response != null) {
      final player = Provider.of<PlayerManager>(context, listen: false);
      player.setName(response['username'] as String);
    }
  }

  void fetchTasksFromAI() async {
    final taskManager = Provider.of<TaskManager>(context, listen: false);

    if (taskManager.tasks.isNotEmpty) return;
    final uri = Uri.parse("http://localhost:5000/generate-task");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        for (int i = 0; i < 7; i++) {
          final task = data[i] as String;

          setState(() {
            tasks.insert(i, task);
            taskManager.addTask(task);

            _listKey.currentState?.insertItem(
              i,
              duration: const Duration(milliseconds: 300),
            );
          });

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
            child: Image.asset(
              'assets/Background/home_bg.jpg',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Flexible(flex: 5, child: _topProfileBar(player)),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TodoScreen()),
              );
            },
            child: Image.asset('assets/icons/todo.png', width: 60),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Image.asset('assets/icons/profile.png', width: 70),
          ),
          Image.asset('assets/icons/calender.png', width: 50),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GameScreen()),
              );
            },
            child: Image.asset('assets/icons/ai.png', width: 50),
          ),
        ],
      ),
    );
  }
}
