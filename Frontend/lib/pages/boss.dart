import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/player_manager.dart';

class Boss extends StatelessWidget {
  const Boss({super.key});

  @override
  Widget build(BuildContext context) {
    final playerManager = Provider.of<PlayerManager>(context);
    final int level = playerManager.level;

    // Choose boss image based on level
    String bossImage;

    if (level >= 1 && level <= 14) {
      bossImage = 'boss.png';
    } else if (level >= 15 && level <= 24) {
      bossImage = 'Characters/boss2.png';
    } else {
      bossImage = 'Characters/boss3.png';
    }

    return FittedBox(fit: BoxFit.contain, child: Image.asset(bossImage));
  }
}
