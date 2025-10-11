import 'package:flutter/material.dart';

import 'player_stats.dart';

class PlayerManager extends ChangeNotifier {
  String? name = "Player";
  int level = 50;
  int xp = 0;
  int xpLimit = 100;
  int unusedStatPoints = 0;

  // Actual stats data for the chart/display
  Map<String, double> statsAttributes = {
    'Strength': 5,
    'Agility': 5,
    'Vigor': 5,
    'Stamina': 5,
    'Defense': 5,
  };

  void updateStats(PlayerStats stats) {
    level = stats.level;
    xp = stats.xp;
    // Dynamically set XP limit (e.g., next level is current level * 100)
    xpLimit = (level + 1) * 100;

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

    while (xp >= xpLimit) {
      level++;
      xpLimit += 1000;
    }

    notifyListeners();
  }
}
