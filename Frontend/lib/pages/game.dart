import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../pages/boss.dart';
import '../pages/player.dart';
import '../pages/player_state.dart';
import 'bottom_navbar.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  double playerHealth = 100;
  double bossHealth = 100;
  String gameMessage = 'Your turn!';
  bool isPlayerTurn = true;
  bool isGameRunning = true;
  bool _isSlashActive = false;
  bool _isShieldActive = false;
  PlayerState _playerState = PlayerState.idle;

  int bossIndex = 0; // Tracks which boss is currently active

  late AnimationController _playerShakeController;
  late AnimationController _bossShakeController;
  late Animation<Offset> _playerShakeAnimation;
  late Animation<Offset> _bossShakeAnimation;

  // Each boss has image, base health, and damage range
  final List<Map<String, dynamic>> bosses = [
    {
      'image': 'boss.png',
      'baseHealth': 100,
      'damageRange': [5, 10],
      'name': 'Goblin Lord',
    },
    {
      'image': 'Characters/boss2.png',
      'baseHealth': 130,
      'damageRange': [8, 14],
      'name': 'Orc Warlord',
    },
    {
      'image': 'Characters/boss3.png',
      'baseHealth': 160,
      'damageRange': [10, 18],
      'name': 'Dragon Emperor',
    },
  ];

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

  // === ATTACKS ===

  void swordAttack() {
    if (isPlayerTurn && isGameRunning) {
      setState(() => _playerState = PlayerState.swordAttack);

      int damage = Random().nextInt(15 - 10 + 1) + 10; // 10–15 dmg
      performPlayerAttack(
        damage,
        'You slashed ${bosses[bossIndex]['name']} for $damage damage!',
      );
    }
  }

  void shieldDefend() {
    if (isPlayerTurn && isGameRunning) {
      setState(() {
        _isShieldActive = true;
        gameMessage = "You raised your shield! Defense increased.";
        isPlayerTurn = false;
      });
      Timer(const Duration(seconds: 2), bossAttack);
    }
  }

  void performPlayerAttack(int damage, String message) {
    setState(() {
      bossHealth -= damage;
      gameMessage = message;
      isPlayerTurn = false;
      _isSlashActive = true;
    });

    _bossShakeController.forward(from: 0.0);

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() {
        _isSlashActive = false;
        _playerState = PlayerState.idle;
      });
    });

    if (bossHealth <= 0) {
      bossHealth = 0;
      isGameRunning = false;
      gameMessage = 'You defeated ${bosses[bossIndex]['name']}!';
      _showBossDefeatedDialog();
    } else {
      Timer(const Duration(seconds: 2), bossAttack);
    }
  }

  void bossAttack() {
    if (!isPlayerTurn && isGameRunning) {
      List<int> damageRange = bosses[bossIndex]['damageRange'];
      int damage =
          Random().nextInt(damageRange[1] - damageRange[0] + 1) +
          damageRange[0];

      // If player used shield, reduce damage
      if (_isShieldActive) {
        damage = (damage * 0.3).toInt(); // 70% damage reduction
        _isShieldActive = false;
        gameMessage = "Your shield absorbed most of the hit!";
      } else {
        gameMessage =
            '${bosses[bossIndex]['name']} attacked you for $damage damage!';
      }

      setState(() {
        playerHealth -= damage;
        isPlayerTurn = true;
      });

      _playerShakeController.forward(from: 0.0);

      if (playerHealth <= 0) {
        playerHealth = 0;
        isGameRunning = false;
        gameMessage = 'You have been defeated!';
        _showGameOverDialog();
      }
    }
  }

  // === DIALOGS ===

  void _showBossDefeatedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Boss Defeated!"),
          content: const Text("A new, stronger boss appears..."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _nextBoss();
              },
              child: const Text("NEXT BOSS"),
            ),
          ],
        );
      },
    );
  }

  void _nextBoss() {
    setState(() {
      bossIndex++;
      if (bossIndex >= bosses.length) bossIndex = 0; // Loop bosses
      bossHealth = bosses[bossIndex]['baseHealth'].toDouble();
      playerHealth = min(playerHealth + 20, 100);
      gameMessage = 'A new boss appears!';
      isGameRunning = true;
      isPlayerTurn = true;
    });
  }

  void _showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("GAME OVER"),
          content: const Text("Would you like to play again?"),
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
      bossHealth = bosses[0]['baseHealth'].toDouble();
      bossIndex = 0;
      gameMessage = 'Your turn!';
      isPlayerTurn = true;
      isGameRunning = true;
      _isSlashActive = false;
      _isShieldActive = false;
      _playerState = PlayerState.idle;
    });
  }

  // === UI ===

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final boss = bosses[bossIndex];

    return Scaffold(
      body: Stack(
        children: [
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
                children: [
                  // Health Bars
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHealthBar(
                        user.name.isNotEmpty ? user.name : "Player",
                        playerHealth,
                        Colors.green,
                      ),
                      _buildHealthBar(boss['name'], bossHealth, Colors.red),
                    ],
                  ),
                  const Spacer(flex: 1),
                  // Game Message
                  Text(
                    gameMessage,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 238, 228, 190),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 4),
                  // Characters (Player + Boss)
                  Expanded(
                    flex: 15,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: SlideTransition(
                            position: _playerShakeAnimation,
                            child: Player(state: _playerState),
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
                                child: Image.asset(
                                  boss['image'],
                                  fit: BoxFit.contain,
                                ),
                              ),
                              if (_isSlashActive)
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: const SlashAnimation(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  // Attack & Shield Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildAttackButton(
                        'assets/icons/attack.png',
                        swordAttack,
                      ),
                      const SizedBox(width: 40),
                      _buildAttackButton('assets/icons/kick.png', shieldDefend),
                    ],
                  ),
                  const Spacer(flex: 1),
                  const BottomNavbar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthBar(String label, double value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 4),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.4,
          child: LinearProgressIndicator(
            value: value / 100,
            backgroundColor: Colors.grey[700],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildAttackButton(String iconPath, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(iconPath, width: 100, height: 100),
    );
  }
}

// Slash animation (unchanged)
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
      if (!mounted) return;
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
