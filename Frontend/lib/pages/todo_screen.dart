import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_manager.dart';
import '../models/tasks.dart';
import '../pages/create_task.dart';
import 'bottom_navbar.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  Color getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case '1':
      case 'low':
        return Colors.greenAccent;
      case '2':
      case 'medium':
        return Colors.orangeAccent;
      case '3':
      case 'high':
        return Colors.redAccent;
      default:
        return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskManager = Provider.of<TaskManager>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/Background/todo_bg.png',
              fit: BoxFit.fill,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: SizedBox(height: screenHeight * 0.15),
                  ),

                  // Center Container with task list
                  Flexible(
                    flex: 19,
                    child: Center(
                      child: Container(
                        width: screenWidth * 0.90,
                        height: screenHeight * 0.7,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Task list
                            Expanded(
                              child: ListView.builder(
                                itemCount: taskManager.activeTasks.length,
                                itemBuilder: (context, index) {
                                  final task = taskManager.activeTasks[index];
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          task.status == TaskStatus.completed
                                              ? Colors.green.withOpacity(0.2)
                                              : task.status ==
                                                  TaskStatus.deleted
                                              ? Colors.red.withOpacity(0.2)
                                              : Colors.white10,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Colors.amber.withOpacity(0.7),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Delete icon
                                        GestureDetector(
                                          onTap: () {
                                            taskManager.deleteTask(index);
                                          },
                                          child: Image.asset(
                                            'assets/icons/delete.png',
                                            width: 40,
                                          ),
                                        ),

                                        // Task text + difficulty
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                task.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Difficulty: ${task.difficulty}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: getDifficultyColor(
                                                    task.difficulty,
                                                  ),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Complete icon
                                        GestureDetector(
                                          onTap: () {
                                            if (task.status ==
                                                TaskStatus.pending) {
                                              taskManager.completeTask(index);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    "Task completed ✅",
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Image.asset(
                                            'assets/icons/add.png',
                                            width: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),

                            // Add more task button
                            GestureDetector(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const CreateTaskScreen(),
                                    ),
                                  ),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Add more task",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.amber,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Flexible(flex: 2, child: BottomNavbar()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
