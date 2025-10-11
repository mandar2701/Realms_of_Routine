import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_xp_project/pages/hero_needs_parchment.dart';

class HeroInfoParchmentPage extends StatefulWidget {
  const HeroInfoParchmentPage({
    super.key,
    required this.email,
    required this.password,
    required this.name,
  });

  final String email;
  final String password;
  final String name;

  @override
  State<HeroInfoParchmentPage> createState() => _HeroInfoParchmentPageState();
}

class _HeroInfoParchmentPageState extends State<HeroInfoParchmentPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final height = screen.height;
    final width = screen.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Background
            SizedBox(
              height: height,
              width: width,
              child: Image.asset("assets/bg_signup.jpg", fit: BoxFit.cover),
            ),

            // Parchment background (same height as screen)
            Center(
              child: Image.asset(
                "assets/parchment.png",
                height: height * 1.25, // keep parchment within screen
                width: width * 2.5, // wide enough for form
                fit: BoxFit.contain,
              ),
            ),

            // Form overlay
            _buildForm(context, height, width),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context, double height, double width) {
    final double formWidth = width * 0.75;
    final double buttonWidth = width * 0.45;
    final double fieldHeight = height * 0.03;
    final double horizontalPadding = (width - formWidth) / 1;

    return Stack(
      children: [
        // Name field
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: height * 0.35,
          child: SizedBox(
            height: fieldHeight,
            child: _buildTextField(
              hintText: 'Enter your name',
              controller: _nameController,
            ),
          ),
        ),

        // Age field
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: height * 0.42,
          child: SizedBox(
            height: fieldHeight,
            child: _buildTextField(
              keyboardType: TextInputType.number,
              hintText: 'Enter your age',
              controller: _ageController,
            ),
          ),
        ),

        // Birth date
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: height * 0.49,
          child: SizedBox(
            height: fieldHeight,
            child: _buildTextField(
              hintText: 'MM/DD/YYYY',
              controller: _birthDateController,
            ),
          ),
        ),

        // Gender
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          top: height * 0.56,
          child: SizedBox(
            height: fieldHeight,
            child: _buildTextField(
              hintText: 'Enter your gender',
              controller: _genderController,
            ),
          ),
        ),

        // NEXT button (clickable)
        Positioned(
          left: width * 0.3,
          right: width * 0.3,
          top: height * 0.63,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.05),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.transparent, // 👈 Fully transparent background
                elevation: 0, // 👈 Remove shadow

                minimumSize: Size(double.infinity, height * 0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 114, 63, 4),
                    width: 1,
                  ),
                ),
              ),
              onPressed: () {
                if (_nameController.text.isEmpty ||
                    _ageController.text.isEmpty ||
                    _birthDateController.text.isEmpty ||
                    _genderController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill all fields')),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => HeroNeedsParchmentPage(
                          email: widget.email,
                          password: widget.password,
                          name: _nameController.text,
                          age: _ageController.text,
                          birthDate: _birthDateController.text,
                          gender: _genderController.text,
                        ),
                  ),
                );
              },

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
    TextInputType keyboardType = TextInputType.text,
    String hintText = '',
    required TextEditingController controller,
  }) {
    const textStyle = TextStyle(
      fontFamily: 'Times New Roman',
      color: Color(0xFF6F4E37),
      fontSize: 16,
    );

    return Align(
      alignment: Alignment.bottomCenter,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: textStyle,
        cursorColor: const Color(0xFF6F4E37),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textStyle.copyWith(
            color: Color(0xFF6F4E37).withOpacity(0.6),
          ),
          isDense: true,
          contentPadding: EdgeInsets.zero,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF8B4513), width: 1),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF6F4E37), width: 1.5),
          ),
        ),
      ),
    );
  }
}
