import 'package:flutter/material.dart';

class Boss extends StatelessWidget {
  const Boss({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(fit: BoxFit.contain, child: Image.asset('boss.png'));
  }
}
