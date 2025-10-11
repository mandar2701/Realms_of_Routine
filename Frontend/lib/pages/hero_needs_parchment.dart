import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_xp_project/pages/terms_conditions_page.dart';

class HeroNeedsParchmentPage extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String age;
  final String birthDate;
  final String gender;

  const HeroNeedsParchmentPage({
    super.key,
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    required this.birthDate,
    required this.gender,
  });

  @override
  _HeroNeedsParchmentPageState createState() => _HeroNeedsParchmentPageState();
}

class _HeroNeedsParchmentPageState extends State<HeroNeedsParchmentPage> {
  final TextEditingController _dutyController = TextEditingController();
  final TextEditingController _focusController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  void _continueToTerms() {
    if (_dutyController.text.isEmpty ||
        _focusController.text.isEmpty ||
        _goalController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TermsConditionsPage(
              email: widget.email,
              password: widget.password,
              name: widget.name,
              age: widget.age,
              birthDate: widget.birthDate,
              gender: widget.gender,
              hero: {
                'duty': _dutyController.text,
                'focus': _focusController.text,
                'goal': _goalController.text,
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Layer 1: Background image
            Image.asset(
              'assets/bg_signup.jpg',
              fit: BoxFit.cover,
              width: screenWidth,
              height: screenHeight,
            ),
            // Layer 2: Parchment overlay
            Center(
              child: Image.asset(
                'assets/parchment.png',
                width: screenWidth * 1.25,
                height: screenHeight * 2.5,
                fit: BoxFit.contain,
              ),
            ),
            // Layer 3: Form
            _buildForm(context, screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    final double formWidth = screenWidth * 0.75;
    final double buttonWidth = screenWidth * 0.45;
    final double fieldHeight = screenWidth * 0.03;
    final double horizontalPadding = (screenWidth - formWidth) / 1;
    return Stack(
      children: [
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: screenHeight * 0.32,
          child: _buildTextField(
            controller: _dutyController,
            hintText: "HERO'S DUTY",
          ),
        ),
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: screenHeight * 0.42,
          child: _buildTextField(
            controller: _focusController,
            hintText: "HERO'S FOCUS",
          ),
        ),
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: screenHeight * 0.52,
          child: _buildTextField(
            controller: _goalController,
            hintText: "HERO'S GOAL",
          ),
        ),
        Positioned(
          left: screenWidth * 0.3,
          right: screenWidth * 0.3,
          top: screenHeight * 0.63,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent, // Transparent parchment look
                elevation: 0,
                minimumSize: Size(double.infinity, screenHeight * 0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 114, 63, 4),
                    width: 1,
                  ),
                ),
              ),
              onPressed: _continueToTerms,

              label: Text(
                "Next",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 116, 54, 2),
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
    const textStyle = TextStyle(
      fontFamily: 'Times New Roman',
      color: Color(0xFF6F4E37),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    return TextField(
      controller: controller,
      textAlign: TextAlign.center,
      style: textStyle,
      cursorColor: const Color(0xFF6F4E37),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: textStyle.copyWith(
          color: const Color(0xFF6F4E37).withOpacity(0.6),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF8B4513), width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF6F4E37), width: 1.5),
        ),
      ),
    );
  }
}
