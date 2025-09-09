import 'package:flutter/material.dart';

class PlayerManager extends ChangeNotifier {
  String name = "Player";
  int level = 25;
  int xp = 700;
  int xpLimit = 1000;

  void setName(String newName) {
    name = newName;
    notifyListeners();
  }

  void gainXP(int amount) {
    xp += amount;

    while (xp >= xpLimit) {
      xp -= xpLimit;
      level++;
      xpLimit += 500;
    }

    notifyListeners();
  }
}
