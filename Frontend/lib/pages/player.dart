import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final bool isHit;

  const Player({super.key, required this.isHit});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      // This applies a red color overlay when isHit is true
      colorFilter: ColorFilter.mode(
        isHit ? Colors.red : Colors.transparent,
        BlendMode.color,
      ),
      child: Image.asset(
        'player.png', // Your player character PNG
        width: 100,
        height: 100,
      ),
    );
  }
}
