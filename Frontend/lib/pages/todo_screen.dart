import 'package:flutter/material.dart';
import 'home_screen.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/todo_background.png', fit: BoxFit.fill),
          ),

          // Centered Container (accounting for full height)
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.13), // Empty space at top
                // Center Container with flexible height
                Expanded(
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.90,
                      height: screenHeight * 0.7,
                      padding: const EdgeInsets.all(20),
                    ),
                  ),
                ),

                // Bottom NavBar
                Padding(
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.015,
                    left: screenWidth * 0.015,
                    right: screenWidth * 0.015,
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
      height:
          screenHeight * 0.09, // Responsive height (e.g., 9% of screen height)
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
