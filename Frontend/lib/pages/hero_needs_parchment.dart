import 'package:flutter/material.dart';
import 'package:life_xp_project/services/auth_services.dart';
import 'package:life_xp_project/pages/login_page.dart';

class HeroNeedsParchmentPage extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String age;
  final String birthDate;
  final String gender;

  const HeroNeedsParchmentPage(
      {super.key,
      required this.email,
      required this.password,
      required this.name,
      required this.age,
      required this.birthDate,
      required this.gender});

  @override
  _HeroNeedsParchmentPageState createState() => _HeroNeedsParchmentPageState();
}

class _HeroNeedsParchmentPageState extends State<HeroNeedsParchmentPage> {
  final TextEditingController _dutyController = TextEditingController();
  final TextEditingController _focusController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final AuthService authService = AuthService();

  void signupUser() async {
    if (_dutyController.text.isEmpty || _focusController.text.isEmpty || _goalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }
    
    try {
      await authService.signUpUser(
        context: context,
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
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              'assets/info_bg6.jpg',
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: signupUser,
              child: Container(
                width: buttonWidth,
                height: 80,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/button22.jpg'),
                    fit: BoxFit.contain,
                  ),
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
