import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/player_manager.dart';
import '../pages/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerManager>(context);

    return Scaffold(
      body: Stack(
        children: [
          // 🔥 Background
          SizedBox.expand(
            child: Image.asset(
              'assets/Background/profile_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // 🔥 Main Content
          Column(
            children: [
              const SizedBox(height: 60),

              // Player name + level
              Column(
                children: [
                  Text(
                    player.name ?? "Player",
                    style: GoogleFonts.imFellEnglish(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    "Level ${player.level}",
                    style: GoogleFonts.imFellEnglish(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // XP bar
              buildStatBar("XP", player.xp, player.xpLimit, Colors.blue),

              const SizedBox(height: 12),

              // Coins bar
              buildStatBar("Coins", 700, 1000, Colors.orange),

              const SizedBox(height: 20),

              // Character Image
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset("Characters/profile.png", height: 550),
                ),
              ),

              // Achievements Section
              Container(
                padding: const EdgeInsets.all(32),
                height: 350,
                width: 390,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color.fromARGB(161, 208, 127, 6),
                  ),
                ),
                child: Column(
                  children: [
                    // Tabs Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Achivement",
                          style: GoogleFonts.imFellEnglish(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 220, 205, 174),
                          ),
                        ),
                        Text(
                          "Attachment",
                          style: GoogleFonts.imFellEnglish(
                            fontSize: 16,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          "Attributes",
                          style: GoogleFonts.imFellEnglish(
                            fontSize: 16,
                            color: Colors.white54,
                          ),
                        ),
                        Text(
                          "About",
                          style: GoogleFonts.imFellEnglish(
                            fontSize: 16,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Achievements grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        AchievementItem(
                          "The finisher",
                          "All task in one day",
                          Colors.orange,
                        ),
                        AchievementItem(
                          "Challenger",
                          "10 task in 12 hours",
                          Colors.blue,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        AchievementItem(
                          "Deep focus",
                          "10 task in 12 hours",
                          Colors.green,
                        ),
                        AchievementItem(
                          "Task streak",
                          "10 task in 12 hours",
                          Colors.purple,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        AchievementItem(
                          "The grinder",
                          "10 task in 12 hours",
                          Colors.cyan,
                        ),
                        AchievementItem(
                          "Early bird",
                          "Finish 3 task before 9 AM",
                          Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 🔥 Helper widget for stat bars
Widget buildStatBar(String label, int value, int max, Color color) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label    $value / $max",
          style: GoogleFonts.imFellEnglish(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value / max,
            minHeight: 10,
            backgroundColor: Colors.black26,
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    ),
  );
}

// 🔥 Achievement Item Widget
class AchievementItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;

  const AchievementItem(this.title, this.subtitle, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.imFellEnglish(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.imFellEnglish(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
