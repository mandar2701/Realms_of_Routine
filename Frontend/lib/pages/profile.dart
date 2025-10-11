import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/player_manager.dart';
import '../providers/user_provider.dart';
import '../services/stats_service.dart';
import 'bottom_navbar.dart';

// Enum to manage the selected tab
enum ProfileTab { achievements, attachment, stats, about }

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileTab _selectedTab = ProfileTab.achievements;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _fetchStats);
  }

  Future<void> _fetchStats() async {
    if (!mounted) return;

    final statsService = StatsService();
    final playerManager = Provider.of<PlayerManager>(context, listen: false);

    final stats = await statsService.fetchPlayerStats(context);

    if (stats != null) {
      playerManager.updateStats(stats);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _onTabTapped(ProfileTab tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  // 🆕 Helper getter to safely resolve the name for the UI
  String get playerNameDisplay {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final player = Provider.of<PlayerManager>(context, listen: false);

    // Use the stronger user name, falling back to player name, or 'Player'
    return user.name.isNotEmpty ? user.name : (player.name ?? "Player");
  }

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<PlayerManager>(context);
    final user = Provider.of<UserProvider>(context).user;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
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
                  Flexible(
                    flex: 21,
                    child:
                        _isLoading
                            ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            )
                            : SingleChildScrollView(
                              child: Column(
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        playerNameDisplay,
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

                                  buildStatBar(
                                    "XP",
                                    player.xp,
                                    player.xpLimit,
                                    Colors.blue,
                                    screenWidth,
                                  ),
                                  SizedBox(height: screenHeight * 0.015),

                                  buildStatBar(
                                    "Coins",
                                    700,
                                    1000,
                                    Colors.orange,
                                    screenWidth,
                                  ),
                                  SizedBox(height: screenHeight * 0.02),

                                  Image.asset(
                                    "assets/Characters/profile.png",
                                    height: screenHeight * 0.3,
                                  ),
                                  SizedBox(height: screenHeight * 0.015),

                                  Container(
                                    padding: EdgeInsets.all(screenWidth * 0.04),
                                    constraints: BoxConstraints(
                                      minHeight: screenHeight * 0.34,
                                    ),
                                    width: screenWidth * 0.9,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                          161,
                                          208,
                                          127,
                                          6,
                                        ),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        _buildTabs(screenWidth),
                                        SizedBox(height: screenHeight * 0.015),
                                        _buildTabContent(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  const Flexible(flex: 2, child: BottomNavbar()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildTabItem("Achievement", ProfileTab.achievements, screenWidth),
        _buildTabItem("Attachment", ProfileTab.attachment, screenWidth),
        _buildTabItem("Stats", ProfileTab.stats, screenWidth),
        _buildTabItem("About", ProfileTab.about, screenWidth),
      ],
    );
  }

  Widget _buildTabItem(String title, ProfileTab tab, double screenWidth) {
    final isSelected = _selectedTab == tab;
    return GestureDetector(
      onTap: () => _onTabTapped(tab),
      child: Text(
        title,
        style: GoogleFonts.imFellEnglish(
          fontSize: screenWidth * 0.04,
          color:
              isSelected
                  ? const Color.fromARGB(255, 220, 205, 174)
                  : Colors.white54,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    final user = Provider.of<UserProvider>(context).user;
    final player = Provider.of<PlayerManager>(context);

    switch (_selectedTab) {
      case ProfileTab.stats:
        return const StatsView();
      case ProfileTab.achievements:
        return const AchievementsGrid();
      case ProfileTab.attachment:
        return Center(
          child: Text(
            "Attachments",
            style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18),
          ),
        );
      case ProfileTab.about:
        return Center(
          child: Text(
            "About $playerNameDisplay",
            style: GoogleFonts.imFellEnglish(color: Colors.white, fontSize: 18),
          ),
        );
      default:
        return const AchievementsGrid();
    }
  }
}

// 🔥 Stats View with Editable Radar Chart
// 🔀 CHANGED TO STATELESS WIDGET TO READ DATA FROM PROVIDER
class StatsView extends StatelessWidget {
  const StatsView({super.key});

  // Helper widget to build the stat slider item (moved out of the old state class)
  Widget _buildStatSlider(
    String statName,
    double statValue,
    double screenWidth,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Text(
            '$statName: ${statValue.toInt()}',
            style: GoogleFonts.imFellEnglish(
              color: Colors.white,
              fontSize: screenWidth * 0.04,
            ),
          ),
        ),
        Slider(
          value: statValue,
          min: 0,
          max: 10,
          divisions: 10,
          activeColor: Colors.orange,
          inactiveColor: Colors.orange.withOpacity(0.3),
          onChanged: (newValue) {
            // NOTE: Updating the slider here would require calling an API
            // to save the changes, but for now, we leave it without local update.
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // ✅ GET THE LIVE DATA FROM PLAYER MANAGER
    final player = Provider.of<PlayerManager>(context);
    final Map<String, double> statsData = player.statsAttributes;

    return Column(
      children: [
        SizedBox(
          height: screenWidth * 0.6,
          child: RadarChart(
            RadarChartData(
              radarBackgroundColor: Colors.transparent,
              radarBorderData: const BorderSide(color: Colors.transparent),
              tickCount: 5,
              ticksTextStyle: const TextStyle(color: Colors.transparent),
              tickBorderData: const BorderSide(color: Colors.white24),
              gridBorderData: const BorderSide(color: Colors.white38),
              borderData: FlBorderData(show: false),

              dataSets: [
                RadarDataSet(
                  fillColor: Colors.orange.withOpacity(0.3),
                  borderColor: Colors.orange,
                  entryRadius: 2.5,
                  borderWidth: 2,
                  // ✅ USE LIVE DATA
                  dataEntries:
                      statsData.values
                          .map((v) => RadarEntry(value: v))
                          .toList(),
                ),
              ],

              getTitle: (index, _) {
                final title = statsData.keys.elementAt(index);
                return RadarChartTitle(text: title);
              },

              titleTextStyle: GoogleFonts.imFellEnglish(
                color: Colors.white,
                fontSize: screenWidth * 0.035,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // ✅ USE LIVE DATA FOR SLIDERS
        ...statsData.keys
            .map((key) => _buildStatSlider(key, statsData[key]!, screenWidth))
            .toList(),
      ],
    );
  }
}

// 🔥 Achievements Grid Widget
class AchievementsGrid extends StatelessWidget {
  const AchievementsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            AchievementItem(
              "The finisher",
              "All task in one day",
              Colors.orange,
            ),
            AchievementItem("Challenger", "10 task in 12 hours", Colors.blue),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            AchievementItem("Deep focus", "10 task in 12 hours", Colors.green),
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
            AchievementItem("The grinder", "10 task in 12 hours", Colors.cyan),
            AchievementItem(
              "Early bird",
              "Finish 3 task before 9 AM",
              Colors.red,
            ),
          ],
        ),
      ],
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
  final progress = (max == 0) ? 0.0 : value / max;

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
            value: progress,
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
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.imFellEnglish(
                fontSize: screenWidth * 0.032,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
