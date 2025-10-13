// Frontend/lib/models/player_manager.dart

import 'package:flutter/material.dart';

import 'player_stats.dart';

class PlayerManager extends ChangeNotifier {
  String? name = "Player";
  int level = 1; // Set to 1 for the demo start state
  int xp = 0; // Set to 0 for the demo start state
  int xpLimit = 100;
  int statPoints = 0;

  // Actual stats data for the chart/display
  Map<String, double> statsAttributes = {
    'Strength': 1,
    'Agility': 1,
    'Vigor': 1,
    'Stamina': 1,
    'Defense': 1,
  };

  void updateStats(PlayerStats stats) {
    // Keep this part as it reads the initial mocked data
    level = stats.level;
    xp = stats.xp;
    statPoints = stats.statPoints;
    xpLimit = level * 100;

    statsAttributes['Strength'] = stats.attributes.strength.toDouble();
    statsAttributes['Agility'] = stats.attributes.agility.toDouble();
    statsAttributes['Vigor'] = stats.attributes.vigor.toDouble();
    statsAttributes['Stamina'] = stats.attributes.stamina.toDouble();
    statsAttributes['Defense'] = stats.attributes.defense.toDouble();

    notifyListeners();
  }

  void setName(String newName) {
    name = newName;
    notifyListeners();
  }

  // *** CRITICAL MOCK LOGIC: Use this for the presentation ***
  void gainXP(int amount) {
    // Use the existing public class fields: 'xp' and 'level'
    xp += amount;

    int levelsGained = 0;

    // Loop to handle potential multiple level-ups in one step
    while (xp >= level * 100) {
      xp -= level * 100;
      level += 1;
      levelsGained++;
    }

    if (levelsGained > 0) {
      // Grant 2 stat points for every level gained
      statPoints += levelsGained * 2;
      print(
        'User leveled up to $level! Gained ${levelsGained * 2} stat points.',
      );
    }

    // Update the XP Limit to the new threshold for the UI display
    xpLimit = level * 100;

    notifyListeners(); // Notify UI to redraw with new values
    print('Gained $amount XP. Current Level: $level, Current XP: $xp/$xpLimit');
  }
}
