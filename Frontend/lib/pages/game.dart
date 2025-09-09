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
          title: Text(
            playerWon ? "C O N G R A T U L A T I..." : "G A M E  O V E R",
          ),
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
          SizedBox.expand(
            child: Image.asset(
              "assets/Background/game_bg.png",
              fit: BoxFit.cover,
            ),
          ),
          // Characters and Health Bars
          Stack(
            children: [
              // Player
              Align(
                alignment: const Alignment(-0.75, 0.4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Player(isHit: playerIsHit),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 150, // Match player width
                      child: LinearProgressIndicator(
                        value: playerHealth / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),

              // Boss
              Align(
                alignment: const Alignment(0.75, -0.6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Boss(isHit: bossIsHit),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 200, // Match boss width
                      child: LinearProgressIndicator(
                        value: bossHealth / 100,
                        backgroundColor: Colors.grey[300],
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.red,
                        ),
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Game UI (Message and Buttons)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    gameMessage,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(blurRadius: 5.0, color: Colors.black)],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Sword Attack Button
                      GestureDetector(
                        onTap: swordAttack,
                        child: Image.asset(
                          'icons/sword_icon.png', // Add this asset
                          width: 80,
                          height: 80,
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Kick Attack Button
                      GestureDetector(
                        onTap: kickAttack,
                        child: Image.asset(
                          'icons/kick_icon.png', // Add this asset
                          width: 80,
                          height: 80,
                        ),
                      ),
                    ],
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
