import 'package:flutter/material.dart';

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
              onTap: () {},
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
      body: Stack(
        children: [
          Positioned(
            left: 16,
            right: 16,
            top: 10,
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
