import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(fit: BoxFit.contain, child: Image.asset('player.png'));
  }
}
