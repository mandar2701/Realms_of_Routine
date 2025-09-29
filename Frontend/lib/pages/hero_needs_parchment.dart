import 'package:flutter/material.dart';
import 'package:life_xp_project/pages/home_screen.dart';

class HeroNeedsParchmentPage extends StatefulWidget {
  const HeroNeedsParchmentPage({super.key});

  @override
  _HeroNeedsParchmentPageState createState() => _HeroNeedsParchmentPageState();
}

class _HeroNeedsParchmentPageState extends State<HeroNeedsParchmentPage> {
  final TextEditingController _dutyController = TextEditingController();
  final TextEditingController _focusController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_signup.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Parchment UI
          Center(
            child: Image.asset(
              'assets/info_bg5.jpg',
              width: MediaQuery.of(context).size.width * 1.25,
              height: MediaQuery.of(context).size.height * 2.5,
            ),
          ),
          _buildForm(context),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double formWidth = 280;
    const double buttonWidth = 200;
    final double horizontalPadding = (screenWidth - formWidth) / 2;

    return Stack(
      children: [
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: 320,
          child: _buildTextField(
            controller: _dutyController,
            hintText: "HERO'S DUTY",
          ),
        ),
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: 420,
          child: _buildTextField(
            controller: _focusController,
            hintText: "HERO'S FOCUS",
          ),
        ),
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: 520,
          child: _buildTextField(
            controller: _goalController,
            hintText: "HERO'S GOAL",
          ),
        ),
        Positioned(
          left: (screenWidth - buttonWidth) / 2,
          top: 620,
          child: GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
            child: Container(
              width: buttonWidth,
              height: 60,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/button22.jpg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontFamily: 'Cinzel',
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontFamily: 'Cinzel',
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        border: const UnderlineInputBorder(),
      ),
    );
  }
}
