import 'package:flutter/material.dart';

import 'player_stats.dart';

class PlayerManager extends ChangeNotifier {
  String? name = "Player";
  int level = 50;
  int xp = 0;
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
    level = stats.level;
    xp = stats.xp;
    statPoints = stats.statPoints;
    // Dynamically set XP limit (e.g., next level is current level * 100)
    xpLimit = (level) * 100;

    // Update the map used by the StatsView widget
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

  void gainXP(int amount) {
    xp += amount;

    // Simulate progression until the next full data sync from the server
    // The server will dictate the real level/xp.
    while (xp >= xpLimit) {
      // Just increase XP limit by 100 locally until the server syncs the new level
      xpLimit += 100;
    }

    notifyListeners();
  }
}
