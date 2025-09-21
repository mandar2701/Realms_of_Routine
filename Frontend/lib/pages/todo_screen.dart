import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/task_manager.dart';
import '../pages/create_task.dart';
import 'bottom_navbar.dart';

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
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Flexible(
                    flex: 2,
                    child: SizedBox(height: screenHeight * 0.13),
                  ),
                  // Center Container with task list
                  Flexible(
                    flex: 19,
                    child: Expanded(
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
                            //  color: Colors.black.withOpacity(0.2),
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
                                            color: Colors.amber.withOpacity(
                                              0.7,
                                            ),
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
                                                () => taskManager.removeTask(
                                                  index,
                                                ),
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
                                                  content: Text(
                                                    "Task completed ✅",
                                                  ),
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
                                            (context) =>
                                                const CreateTaskScreen(),
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
                  ),
                  Flexible(flex: 2, child: BottomNavbar()),

                  // Bottom NavBar
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
