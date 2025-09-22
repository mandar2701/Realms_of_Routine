import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/player_manager.dart';
import 'bottom_navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerManager>(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 🔥 Background
          Positioned.fill(
            child: Image.asset(
              'assets/Background/profile_bg.png',
              fit: BoxFit.fill,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Top spacer

                  // Main Profile Content
                  Flexible(
                    flex: 21,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          // Player name + level
                          Column(
                            children: [
                              Text(
                                player.name ?? "Player",
                                style: GoogleFonts.imFellEnglish(
                                  fontSize: screenWidth * 0.08,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                  letterSpacing: 2,
                                ),
                              ),
                              Text(
                                "Level ${player.level}",
                                style: GoogleFonts.imFellEnglish(
                                  fontSize: screenWidth * 0.045,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // XP bar
                          buildStatBar(
                            "XP",
                            player.xp,
                            player.xpLimit,
                            Colors.blue,
                            screenWidth,
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          // Coins bar
                          buildStatBar(
                            "Coins",
                            700,
                            1000,
                            Colors.orange,
                            screenWidth,
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          // Character Image
                          Image.asset(
                            "Characters/profile.png",
                            height: screenHeight * 0.3,
                          ),

                          SizedBox(height: screenHeight * 0.015),

                          // Achievements Section
                          Container(
                            padding: EdgeInsets.all(screenWidth * 0.06),
                            height: screenHeight * 0.34,
                            width: screenWidth * 0.9,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Achivement",
                                      style: GoogleFonts.imFellEnglish(
                                        fontSize: screenWidth * 0.04,
                                        color: const Color.fromARGB(
                                          255,
                                          220,
                                          205,
                                          174,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Attachment",
                                      style: GoogleFonts.imFellEnglish(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.white54,
                                      ),
                                    ),
                                    Text(
                                      "Attributes",
                                      style: GoogleFonts.imFellEnglish(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.white54,
                                      ),
                                    ),
                                    Text(
                                      "About",
                                      style: GoogleFonts.imFellEnglish(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.white54,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.015),

                                // Achievements grid
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Flexible(flex: 2, child: BottomNavbar()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 🔥 Helper widget for stat bars
Widget buildStatBar(
  String label,
  int value,
  int max,
  Color color,
  double screenWidth,
) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label    $value / $max",
          style: GoogleFonts.imFellEnglish(
            fontSize: screenWidth * 0.04,
            color: Colors.white,
          ),
        ),
        SizedBox(height: screenWidth * 0.015),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: value / max,
            minHeight: screenWidth * 0.025,
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
    final screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.imFellEnglish(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: GoogleFonts.imFellEnglish(
                fontSize: screenWidth * 0.035,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
