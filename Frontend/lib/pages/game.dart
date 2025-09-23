import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../pages/boss.dart';
import '../pages/player.dart';
import 'bottom_navbar.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  // Game variables
  double playerHealth = 100;
  double bossHealth = 100;
  String gameMessage = 'Your turn!';
  bool isPlayerTurn = true;
  bool isGameRunning = true;
  bool _isSlashActive = false; // control slash animation

  late AnimationController _playerShakeController;
  late AnimationController _bossShakeController;
  late Animation<Offset> _playerShakeAnimation;
  late Animation<Offset> _bossShakeAnimation;

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
      _isSlashActive = true; // start slash animation
    });

    _bossShakeController.forward(from: 0.0);

    Future.delayed(const Duration(milliseconds: 450), () {
      setState(() {
        _isSlashActive = false; // stop slash animation
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
      });

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
      _isSlashActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/Background/game_bg.png',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 9,
                    child: Column(
                      children: [
                        // Player + Boss Health Bars
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
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
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.4,
                                      child: LinearProgressIndicator(
                                        value: playerHealth / 100,
                                        backgroundColor: Colors.grey[700],
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
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
                                    const Text(
                                      "Boss",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.4,
                                      child: LinearProgressIndicator(
                                        value: bossHealth / 100,
                                        backgroundColor: Colors.grey[700],
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
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

                        // Game Message
                        Flexible(
                          flex: 2,
                          child: Center(
                            child: Text(
                              gameMessage,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(blurRadius: 5.0, color: Colors.black),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        const Spacer(flex: 12),

                        // Characters (Player + Boss)
                        Flexible(
                          flex: 15,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: SlideTransition(
                                  position: _playerShakeAnimation,
                                  child: const Player(),
                                ),
                              ),
                              const Spacer(flex: 1),
                              Expanded(
                                flex: 5,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SlideTransition(
                                      position: _bossShakeAnimation,
                                      child: const Boss(),
                                    ),
                                    if (_isSlashActive)
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.4,
                                        height:
                                            MediaQuery.of(context).size.width *
                                            0.4,
                                        child: SlashAnimation(),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Attack Buttons
                        Flexible(
                          flex: 5,
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
                      ],
                    ),
                  ),

                  // Bottom Navbar
                  Flexible(flex: 1, child: BottomNavbar()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Slash frame-by-frame animation widget
class SlashAnimation extends StatefulWidget {
  const SlashAnimation({super.key});

  @override
  State<SlashAnimation> createState() => _SlashAnimationState();
}

class _SlashAnimationState extends State<SlashAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  int currentFrame = 0;
  final int totalFrames = 9;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..addListener(() {
      setState(() {
        currentFrame = (_controller.value * totalFrames).floor();
        if (currentFrame >= totalFrames) currentFrame = totalFrames - 1;
      });
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'effects/slash/slash_${currentFrame + 1}.png',
      fit: BoxFit.contain,
    );
  }
}
