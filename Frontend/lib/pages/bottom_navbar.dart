import 'package:flutter/material.dart';

import 'game.dart';
import 'home_screen.dart';
import 'profile.dart';
import 'quest_calendar.dart';
import 'todo_screen.dart';

class BottomNavbar extends StatelessWidget {
  const BottomNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home icon (currently no navigation)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: Image.asset('assets/icons/home.png', width: 50),
          ),

          // TodoScreen
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TodoScreen()),
              );
            },
            child: Image.asset('assets/icons/todo.png', width: 60),
          ),

          // ProfileScreen
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
            child: Image.asset('assets/icons/profile.png', width: 70),
          ),

          // QuestCalendarScreen
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuestCalendarScreen(),
                ),
              );
            },
            child: Image.asset('assets/icons/calender.png', width: 50),
          ),

          // GameScreen
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
