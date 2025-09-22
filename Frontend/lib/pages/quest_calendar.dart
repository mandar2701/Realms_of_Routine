import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import 'game.dart';
import 'profile.dart';
import 'todo_screen.dart';

class QuestCalendarScreen extends StatefulWidget {
  const QuestCalendarScreen({super.key});

  @override
  State<QuestCalendarScreen> createState() => _QuestCalendarScreenState();
}

class _QuestCalendarScreenState extends State<QuestCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  /// Example XP events (day → type of quest done)
  final Map<DateTime, String> _events = {
    DateTime.utc(2025, 9, 17): "failed",
    DateTime.utc(2025, 9, 18): "completed",
    DateTime.utc(2025, 9, 19): "bonus",
  };

  List<Map<String, dynamic>> dailyQuests = [
    {"title": "Office presentation", "xp": 20, "status": "completed"},
    {"title": "Skipped the gym !", "xp": -20, "status": "failed"},
    {"title": "Spent whole day with family", "xp": 40, "status": "bonus"},
  ];

  void addQuest(String title, int xp, String status) {
    setState(() {
      dailyQuests.add({"title": title, "xp": xp, "status": status});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("Background/cal_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 207, 203, 203).withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Real Calendar
                _buildCalendar(),

                const SizedBox(height: 10),
                Text(
                  "DAILY QUESTS",
                  style: GoogleFonts.cinzelDecorative(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.amberAccent,
                    letterSpacing: 2,
                  ),
                ),
                const Divider(color: Colors.amber),

                Expanded(
                  child: ListView.builder(
                    itemCount: dailyQuests.length,
                    itemBuilder: (context, index) {
                      final quest = dailyQuests[index];
                      return ListTile(
                        leading: Icon(
                          quest["status"] == "completed"
                              ? Icons.shield
                              : quest["status"] == "failed"
                              ? Icons.close_rounded
                              : Icons.favorite,
                          color:
                              quest["status"] == "completed"
                                  ? Colors.amber
                                  : quest["status"] == "failed"
                                  ? Colors.red
                                  : Colors.greenAccent,
                        ),
                        title: Text(
                          quest["title"],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        trailing: Text(
                          "${quest["xp"] > 0 ? "+" : ""}${quest["xp"]}XP",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: quest["xp"] > 0 ? Colors.green : Colors.red,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Set Quest Button
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(
                        255,
                        207,
                        203,
                        203,
                      ).withOpacity(0.2),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: const BorderSide(
                          // 👈 Border added
                          color: const Color.fromARGB(255, 238, 228, 190),
                          width: 0.25,
                        ),
                      ),
                    ),
                    onPressed: () {
                      addQuest("New Custom Quest", 25, "completed");
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: Text(
                      "Set Quest",
                      style: GoogleFonts.cinzelDecorative(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color.fromARGB(255, 238, 228, 190),
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom navigation
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 75,
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('assets/icons/home.png', width: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TodoScreen(),
                        ),
                      );
                    },
                    child: Image.asset('assets/icons/todo.png', width: 60),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: Image.asset('assets/icons/profile.png', width: 70),
                  ),
                  Image.asset('assets/icons/calender.png', width: 50),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(),
                        ),
                      );
                    },
                    child: Image.asset('assets/icons/ai.png', width: 50),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return Container(
      child: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Colors.amber.shade700,
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Colors.blueAccent,
            shape: BoxShape.circle,
          ),
          defaultTextStyle: const TextStyle(color: Colors.white),
          weekendTextStyle: const TextStyle(color: Colors.redAccent),
        ),
        headerStyle: HeaderStyle(
          titleTextStyle: GoogleFonts.cinzel(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          formatButtonVisible: false,
          titleCentered: true,
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
          rightChevronIcon: const Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
        calendarBuilders: CalendarBuilders(
          markerBuilder: (context, day, events) {
            final status = _events[DateTime.utc(day.year, day.month, day.day)];
            if (status == "completed") {
              return const Icon(Icons.shield, color: Colors.amber, size: 16);
            } else if (status == "failed") {
              return const Icon(Icons.close, color: Colors.red, size: 16);
            } else if (status == "bonus") {
              return const Icon(
                Icons.favorite,
                color: Colors.greenAccent,
                size: 16,
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
