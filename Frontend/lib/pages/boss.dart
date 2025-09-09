import 'package:flutter/material.dart';

class Boss extends StatelessWidget {
  final bool isHit;

  const Boss({super.key, required this.isHit});

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      // This applies a red color overlay when isHit is true
      colorFilter: ColorFilter.mode(
        isHit ? Colors.red : Colors.transparent,
        BlendMode.color,
      ),
      child: Image.asset(
        'boss.png', // Your boss character PNG
      ),
    );
  }
}
