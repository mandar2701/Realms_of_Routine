import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LifeXPHomeScreen extends StatefulWidget {
  const LifeXPHomeScreen({super.key});

  @override
  State<LifeXPHomeScreen> createState() => _LifeXPHomeScreenState();
}

class _LifeXPHomeScreenState extends State<LifeXPHomeScreen> {
  final Map<String, bool> _questStatus = {
    'Do Laundry': false,
    'Read Notes (10 mins)': false,
    'Drink Water': false,
    'Workout (30 mins)': false,
    'Meditate (5 mins)': false,
    'Write Journal': false,
  };

  final String flaskUrl = 'http://10.0.2.2:5000/generate-task?class=mage';

  Future<void> _fetchNewQuest() async {
    try {
      final response = await http.get(Uri.parse(flaskUrl));
      if (response.statusCode == 200) {
        final String newTask = jsonDecode(response.body)['task'];
        setState(() {
          _questStatus[newTask] = false;
        });
      } else {
        print('Failed to load quest: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching quest: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/Background.png', fit: BoxFit.cover),
          ),

          // Main UI
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 100,
              title: Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const CircleAvatar(radius: 24),
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
                      const Text(
                        'Lvl 6',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.blueAccent,
              onPressed: _fetchNewQuest,
              child: const Icon(Icons.add),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: Colors.amber,
              unselectedItemColor: Colors.white70,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory),
                  label: 'Inventory',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profile',
                ),
              ],
            ),
            body: Stack(
              children: [
                Positioned(
                  left: 16,
                  right: 16,
                  top: 110,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: _questsSection(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _questsSection() {
    return Column(
      children: [
        const Center(
          child: Text(
            'Quick Quests',
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (var entry in _questStatus.entries)
          _questItem(entry.key, '${(entry.key.length % 5 + 1) * 5} XP'),
      ],
    );
  }

  Widget _questItem(String title, String xp) {
    return ListTile(
      leading: Checkbox(
        value: _questStatus[title],
        onChanged: (val) {
          setState(() {
            _questStatus[title] = val!;
          });
        },
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      trailing: Text(
        xp,
        style: const TextStyle(color: Colors.amberAccent, fontSize: 20),
      ),
    );
  }
}
