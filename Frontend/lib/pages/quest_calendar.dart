import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:glassmorphism/glassmorphism.dart';

import '../models/task_manager.dart';
import '../models/tasks.dart';
import 'bottom_navbar.dart';
import 'create_task.dart'; // Import the CreateTask screen

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

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Load all tasks when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskManager>(context, listen: false).loadTasks(context);
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
                image: AssetImage("assets/Background/cal_bg.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Flexible(
                    flex: 11,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GlassmorphicContainer(
                        width: double.infinity,
                        height: double.infinity,
                        borderRadius: 20,
                        blur: 20,
                        alignment: Alignment.center,
                        border: 1,
                        linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color.fromARGB(
                              138,
                              255,
                              255,
                              255,
                            ).withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ],
                        ),
                        borderGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.4),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Calendar
                            _buildCalendar(),

                            const SizedBox(height: 10),

                            // Divider + Title
                            Row(
                              children: [
                                const Expanded(
                                  child: Divider(
                                    color: Color.fromARGB(255, 233, 214, 142),
                                    thickness: 1,
                                    endIndent: 10,
                                  ),
                                ),
                                Text(
                                  "DAILY QUESTS",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                      255,
                                      233,
                                      214,
                                      142,
                                    ),
                                    letterSpacing: 2,
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Color.fromARGB(255, 233, 214, 142),
                                    thickness: 1,
                                    indent: 10,
                                  ),
                                ),
                              ],
                            ),

                            // Quest List
                            _buildQuestList(),

                            // ✅ FIX: Set Quest Button restored and functional
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white.withOpacity(
                                    0.15,
                                  ),
                                  minimumSize: const Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                      color: Color.fromARGB(255, 238, 228, 190),
                                      width: 0.25,
                                    ),
                                  ),
                                ),
                                onPressed: () async {
                                  // Navigate to CreateTask screen and wait for result
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => const CreateTaskScreen(),
                                    ),
                                  );
                                  // Refresh the tasks list when returning
                                  if (mounted) {
                                    Provider.of<TaskManager>(
                                      context,
                                      listen: false,
                                    ).loadTasks(context);
                                  }
                                },
                                icon: const Icon(
                                  Icons.add_box_outlined,
                                  color: Color.fromARGB(255, 238, 228, 190),
                                  size: 24,
                                ),
                                label: Text(
                                  "Set Quest",
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color.fromARGB(
                                      255,
                                      238,
                                      228,
                                      190,
                                    ),
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Flexible(flex: 1, child: BottomNavbar()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
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
        selectedDecoration: const BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: GoogleFonts.cinzelDecorative(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        weekendTextStyle: GoogleFonts.cinzelDecorative(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
        ),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: GoogleFonts.cinzel(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1,
        ),
        weekendStyle: GoogleFonts.cinzel(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
          letterSpacing: 1,
        ),
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
        rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
      ),
      calendarBuilders: CalendarBuilders(
        markerBuilder: (context, day, events) {
          final status = _events[DateTime.utc(day.year, day.month, day.day)];
          if (status == "completed") {
            return const Icon(Icons.shield, color: Colors.amber, size: 18);
          } else if (status == "failed") {
            return const Icon(Icons.close, color: Colors.red, size: 18);
          } else if (status == "bonus") {
            return const Icon(
              Icons.favorite,
              color: Colors.greenAccent,
              size: 18,
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildQuestList() {
    return Expanded(
      child: Consumer<TaskManager>(
        builder: (context, taskManager, child) {
          // Filter tasks based on the selected day's createdAt date
          final dailyQuests =
              taskManager.tasks.where((task) {
                if (task.createdAt == null || _selectedDay == null) {
                  return false;
                }
                return isSameDay(task.createdAt, _selectedDay);
              }).toList();

          if (dailyQuests.isEmpty) {
            return const Center(
              child: Text(
                'No quests for this day.',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return ListView.builder(
            itemCount: dailyQuests.length,
            itemBuilder: (context, index) {
              final quest = dailyQuests[index];
              final status =
                  quest.status == TaskStatus.completed
                      ? "completed"
                      : (quest.status == TaskStatus.deleted
                          ? "failed"
                          : "pending");

              return ListTile(
                leading: Icon(
                  status == "completed"
                      ? Icons.shield
                      : status == "failed"
                      ? Icons.close_rounded
                      : Icons.hourglass_empty,
                  color:
                      status == "completed"
                          ? Colors.amber
                          : status == "failed"
                          ? Colors.red
                          : Colors.grey,
                ),
                title: Text(
                  quest.name,
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 238, 228, 190),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
