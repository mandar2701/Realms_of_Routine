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

class _GameScreenState extends State<GameScreen> {
  // Game variables
  double playerHealth = 100;
  double bossHealth = 100;
  String gameMessage = 'Your turn!';
  bool isPlayerTurn = true;
  bool isGameRunning = true;

  // Damage effect variables
  bool playerIsHit = false;
  bool bossIsHit = false;

  // Attack logic for Sword
  void swordAttack() {
    if (isPlayerTurn && isGameRunning) {
      int damage = Random().nextInt(15) + 10; // Sword: Higher damage
      performPlayerAttack(damage, 'You slashed the boss for $damage damage!');
    }
  }

  // Attack logic for Kick
  void kickAttack() {
    if (isPlayerTurn && isGameRunning) {
      int damage = Random().nextInt(8) + 5; // Kick: Lower damage
      performPlayerAttack(damage, 'You kicked the boss for $damage damage!');
    }
  }

  void performPlayerAttack(int damage, String message) {
    setState(() {
      bossHealth -= damage;
      gameMessage = message;
      isPlayerTurn = false;
      bossIsHit = true; // Trigger boss hit effect
    });

    // Remove the hit effect after a short duration
    Timer(const Duration(milliseconds: 300), () {
      setState(() {
        bossIsHit = false;
      });
    });

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
        playerIsHit = true; // Trigger player hit effect
      });

      // Remove the hit effect after a short duration
      Timer(const Duration(milliseconds: 300), () {
        setState(() {
          playerIsHit = false;
        });
      });

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
      playerIsHit = false;
      bossIsHit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE (Bottom layer)
          SizedBox.expand(
            child: Image.asset(
              "assets/Background/game_bg.png",
              fit: BoxFit.cover,
            ),
          ),

          // 2. TOP HEALTH BARS
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Player Health Bar
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
                  // Boss Health Bar
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

          // 3. GAME MESSAGE
          Align(
            alignment: const Alignment(
              0.0,
              -0.6,
            ), // Positioned below health bars
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

          // 4. CHARACTERS
          // We use a SizedBox to constrain the height so characters don't take the full screen
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Align(
              alignment: const Alignment(
                0.0,
                0.4,
              ), // Moves characters lower down
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height *
                    0.4, // 40% of screen height
                child: Row(
                  children: [
                    Expanded(flex: 5, child: Player(isHit: playerIsHit)),
                    const Spacer(flex: 1),
                    Expanded(flex: 5, child: Boss(isHit: bossIsHit)),
                  ],
                ),
              ),
            ),
          ),

          // 5. BOTTOM ATTACK BUTTONS
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
