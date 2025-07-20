import 'package:flutter/material.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

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
              width: screenWidth * 0.90, // 90% of screen width
              height: screenHeight * 0.7,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                //  color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
