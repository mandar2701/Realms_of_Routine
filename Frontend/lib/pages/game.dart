import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../pages/boss.dart';
import '../pages/player.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

// 1. Add TickerProviderStateMixin for animations
class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Game variables
  double playerHealth = 100;
  double bossHealth = 100;
  String gameMessage = 'Your turn!';
  bool isPlayerTurn = true;
  bool isGameRunning = true;

  // REMOVED: Damage effect variables (no longer needed)
  // bool playerIsHit = false;
  // bool bossIsHit = false;

  // 2. ADD: Animation Controllers for the shake effect
  late AnimationController _playerShakeController;
  late AnimationController _bossShakeController;
  late Animation<Offset> _playerShakeAnimation;
  late Animation<Offset> _bossShakeAnimation;

  // 3. ADD: initState to set up the animations
  @override
  void initState() {
    super.initState();

    _playerShakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _playerShakeAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0), end: const Offset(-0.02, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.02, 0), end: const Offset(0.02, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.02, 0), end: const Offset(-0.02, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.02, 0), end: const Offset(0, 0)),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(parent: _playerShakeController, curve: Curves.easeInOut),
    );

    _bossShakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _bossShakeAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0, 0), end: const Offset(0.02, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.02, 0), end: const Offset(-0.02, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(-0.02, 0), end: const Offset(0.02, 0)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: const Offset(0.02, 0), end: const Offset(0, 0)),
        weight: 1,
      ),
    ]).animate(
      CurvedAnimation(parent: _bossShakeController, curve: Curves.easeInOut),
    );
  }

  // 4. ADD: dispose to clean up the controllers
  @override
  void dispose() {
    _playerShakeController.dispose();
    _bossShakeController.dispose();
    super.dispose();
  }

  void swordAttack() {
    if (isPlayerTurn && isGameRunning) {
      int damage = Random().nextInt(15) + 10;
      performPlayerAttack(damage, 'You slashed the boss for $damage damage!');
    }
  }

  void kickAttack() {
    if (isPlayerTurn && isGameRunning) {
      int damage = Random().nextInt(8) + 5;
      performPlayerAttack(damage, 'You kicked the boss for $damage damage!');
    }
  }

  void performPlayerAttack(int damage, String message) {
    setState(() {
      bossHealth -= damage;
      gameMessage = message;
      isPlayerTurn = false;
      // REMOVED: bossIsHit = true;
    });

    // REMOVED: Timer for the hit effect

    // 5. CHANGE: Trigger the boss shake animation instead of the red flash
    _bossShakeController.forward(from: 0.0);

    if (bossHealth <= 0) {
      bossHealth = 0;
      isGameRunning = false;
      gameMessage = 'You defeated the boss!';
      _showGameOverDialog(true);
    } else {
      Timer(const Duration(seconds: 1), bossAttack);
    }
  }

  void bossAttack() {
    if (!isPlayerTurn && isGameRunning) {
      setState(() {
        int damage = Random().nextInt(8) + 3;
        playerHealth -= damage;
        gameMessage = 'The boss attacked you for $damage damage!';
        isPlayerTurn = true;
        // REMOVED: playerIsHit = true;
      });

      // REMOVED: Timer for the hit effect

      // 6. CHANGE: Trigger the player shake animation instead of the red flash
      _playerShakeController.forward(from: 0.0);

      if (playerHealth <= 0) {
        playerHealth = 0;
        isGameRunning = false;
        gameMessage = 'You have been defeated!';
        _showGameOverDialog(false);
      }
    }
  }

  void _showGameOverDialog(bool playerWon) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(playerWon ? "CONGRATULATIONS" : "GAME OVER"),
          content: Text(
            playerWon ? "You have won!" : "Would you like to play again?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text("PLAY AGAIN"),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      playerHealth = 100;
      bossHealth = 100;
      gameMessage = 'Your turn!';
      isPlayerTurn = true;
      isGameRunning = true;
      // REMOVED: playerIsHit = false;
      // REMOVED: bossIsHit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // YOUR LAYOUT IS UNCHANGED
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              "assets/Background/game_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Player",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: LinearProgressIndicator(
                          value: playerHealth / 100,
                          backgroundColor: Colors.grey[700],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.green,
                          ),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Boss", style: TextStyle(color: Colors.white)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: LinearProgressIndicator(
                          value: bossHealth / 100,
                          backgroundColor: Colors.grey[700],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.red,
                          ),
                          minHeight: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.0, -0.6),
            child: Text(
              gameMessage,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 5.0, color: Colors.black)],
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Align(
              alignment: const Alignment(0.0, 0.4),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Row(
                  children: [
                    // 7. CHANGE: Apply the shake animation to the Player
                    Expanded(
                      flex: 5,
                      child: SlideTransition(
                        position: _playerShakeAnimation,
                        child: const Player(), // Pass no parameters
                      ),
                    ),
                    const Spacer(flex: 1),
                    // 8. CHANGE: Apply the shake animation to the Boss
                    Expanded(
                      flex: 5,
                      child: SlideTransition(
                        position: _bossShakeAnimation,
                        child: const Boss(), // Pass no parameters
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: swordAttack,
                    child: Image.asset(
                      'icons/attack.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                  const SizedBox(width: 40),
                  GestureDetector(
                    onTap: kickAttack,
                    child: Image.asset(
                      'icons/kick.png',
                      width: 120,
                      height: 120,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
