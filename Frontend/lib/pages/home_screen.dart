import 'package:flutter/material.dart';

class LifeXPHomeScreen extends StatelessWidget {
  const LifeXPHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111428),
        toolbarHeight: 100,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                // Navigate to profile section
              },
              child: const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  'Mage',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 100,
                  child: LinearProgressIndicator(
                    value: 0.6,
                    backgroundColor: Colors.white24,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                const Text('Lvl 6', style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF111428),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
