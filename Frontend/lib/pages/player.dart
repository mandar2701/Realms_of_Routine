// lib/pages/player.dart

import 'package:flutter/material.dart';
import 'player_state.dart';

class Player extends StatelessWidget {
  final PlayerState state;

  const Player({super.key, this.state = PlayerState.idle});

  String _getImagePath() {
    switch (state) {
      case PlayerState.swordAttack:
      case PlayerState.kickAttack:
        // Path to your attack GIF
        return 'Characters/player_attack.gif';
      case PlayerState.idle:
      default:
        // Path to your static idle image
        return 'Characters/player.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✨ First, create the Image widget
    Widget imageWidget = Image.asset(
      _getImagePath(),
      key: UniqueKey(),
      fit: BoxFit.contain,
    );

    // ✨ Then, check the state. If it's an attack, wrap the image with Transform.scale
    if (state == PlayerState.swordAttack || state == PlayerState.kickAttack) {
      return Transform.scale(
        // ✨ Adjust this scale value to make the GIF the size you want.
        // 1.0 is normal size, 1.5 is 150% bigger, 2.0 is 200% bigger, etc.
        scale: 2.7,
        child: imageWidget,
      );
    }

    // ✨ Otherwise, return the original, unscaled image widget
    return imageWidget;
  }
}
