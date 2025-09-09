import 'package:flutter/material.dart';
import '../pages/create_task.dart';
import 'package:provider/provider.dart';
import '../models/task_manager.dart';
import 'home_screen.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

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
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.13),

                // Center Container with task list
                Expanded(
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.90,
                      height: screenHeight * 0.72,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black.withOpacity(0.2),
                      ),
                      child: Column(
                        children: [
                          // Task list
                          Expanded(
                            child: ListView.builder(
                              itemCount: taskManager.tasks.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.amber.withOpacity(0.7),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Delete icon
                                      GestureDetector(
                                        onTap:
                                            () => taskManager.removeTask(index),
                                        child: Image.asset(
                                          'assets/icons/delete.png',
                                          width: 40,
                                        ),
                                      ),

                                      // Task text
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            taskManager.tasks[index],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Complete icon
                                      GestureDetector(
                                        onTap: () {
                                          taskManager.completeTask(index);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text("Task completed ✅"),
                                            ),
                                          );
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

                // Bottom NavBar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              ),
                          child: Image.asset(
                            'assets/icons/home.png',
                            width: 40,
                          ),
                        ),
                        Image.asset('assets/icons/todo.png', width: 40),
                        Image.asset('assets/icons/profile.png', width: 50),
                        Image.asset('assets/icons/calender.png', width: 40),
                        Image.asset('assets/icons/ai.png', width: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
