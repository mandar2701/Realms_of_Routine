import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

import 'bottom_navbar.dart';

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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Flexible(
                  flex: 21,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                        255,
                        207,
                        203,
                        203,
                      ).withOpacity(0.2),
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
                                    color:
                                        quest["xp"] > 0
                                            ? Colors.green
                                            : Colors.red,
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
                              backgroundColor: Colors.amber.shade700,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () {
                              addQuest("New Custom Quest", 25, "completed");
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text(
                              "Set Quest",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                // Bottom navigation
                Flexible(flex: 2, child: BottomNavbar()),
              ],
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
