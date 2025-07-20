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
          // Background
          Positioned.fill(
            child: Image.asset('assets/todo_background.png', fit: BoxFit.fill),
          ),

          // Foreground Container
          Center(
            child: Container(
              width: screenWidth * 0.90,
              height: screenHeight * 0.7,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange, width: 2),
              ),
            ),
          ),

          // Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _bottomNavBar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
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
              // Currently on TodoScreen, you might want to highlight or disable this
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
