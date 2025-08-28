import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../models/task_manager.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<String> tasks = [
    "Go to gym",
    "Complete assignment",
    "Complete assignment",
    "Complete assignment",
    "Complete assignment",
    "Complete assignment",
    "Complete assignment",
  ];

  @override
  Widget build(BuildContext context) {
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

          // Foreground content
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
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 0.2,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 0.2,
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
                                      // Delete icon (left)
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            tasks.removeAt(index);
                                          });
                                        },
                                        child: Image.asset(
                                          'assets/icons/delete.png',
                                          width: 60,
                                        ),
                                      ),

                                      // Task text
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            tasks[index],
                                            style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),

                                      // Complete icon (right)
                                      GestureDetector(
                                        onTap: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "${tasks[index]} completed ✅",
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.asset(
                                          'assets/icons/add.png',
                                          width: 60,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          // Add more task
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tasks.add("New Task");
                              });
                            },
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
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.015,
                    left: screenWidth * 0.025,
                    right: screenWidth * 0.025,
                  ),
                  child: _bottomNavBar(screenWidth, screenHeight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavBar(double screenWidth, double screenHeight) {
    return Container(
      height: screenHeight * 0.08,
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: Image.asset('assets/icons/home.png', width: 50),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TodoScreen()),
              );
            },
            child: Image.asset('assets/icons/todo.png', width: 60),
          ),
          Image.asset('assets/icons/profile.png', width: 70),
          Image.asset('assets/icons/calender.png', width: 50),
          Image.asset('assets/icons/ai.png', width: 50),
        ],
      ),
    );
  }
}
