import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:life_xp_project/pages/login_page.dart';

class TermsConditionsPage extends StatefulWidget {
  final String email;
  final String password;
  final String name;
  final String age;
  final String birthDate;
  final String gender;
  final Map<String, String> hero;

  const TermsConditionsPage({
    super.key,
    required this.email,
    required this.password,
    required this.name,
    required this.age,
    required this.birthDate,
    required this.gender,
    required this.hero,
  });

  @override
  _TermsConditionsPageState createState() => _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  bool _isAgreed = false;

  void _showRegistrationSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2D1810),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Registration Successful!',
            style: TextStyle(
              color: Color(0xFFFFE57F),
              fontFamily: 'Times New Roman',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Your hero has been created successfully. Welcome to the realm!',
            style: TextStyle(
              color: Color(0xFFEFDCC3),
              fontFamily: 'Times New Roman',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text(
                'Continue to Login',
                style: TextStyle(
                  color: Color(0xFFFFE57F),
                  fontFamily: 'Times New Roman',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            'assets/bg_signup.jpg',
            fit: BoxFit.cover,
            width: screenWidth,
            height: screenHeight,
          ),
          // Parchment overlay
          Center(
            child: Image.asset(
              'assets/parchment.png',
              width: screenWidth * 1.25,
              height: screenHeight * 2.5,
              fit: BoxFit.contain,
            ),
          ),
          // Scrollable Terms content with button inside
          Center(
            child: SizedBox(
              height: screenHeight * 0.45, // Scrollable area height
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.25),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        'TERMS & CONDITIONS',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Color(0xFF6F4E37),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      const Text(
                        '''By joining this realm, you agree to:

• Complete quests with honor
• Battle procrastination monsters
• Level up through dedication
• Respect fellow heroes
• Use the app responsibly

Your data is protected by ancient magic (encryption) and will never be shared with dark forces.

May your journey be legendary!''',
                        style: TextStyle(
                          fontFamily: 'Times New Roman',
                          color: Color(0xFF6F4E37),
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Row(
                        children: [
                          Checkbox(
                            value: _isAgreed,
                            onChanged: (value) {
                              setState(() {
                                _isAgreed = value ?? false;
                              });
                            },
                            activeColor: const Color(0xFF6F4E37),
                          ),
                          const Expanded(
                            child: Text(
                              'I agree to the Terms & Conditions',
                              style: TextStyle(
                                fontFamily: 'Times New Roman',
                                color: Color(0xFF6F4E37),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      // Transparent parchment-style button inside a Container
                      Container(
                        width: screenWidth * 1.25 * 0.36,
                        height: screenHeight * 0.06,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color.fromARGB(255, 116, 54, 2),
                            width: 1,
                          ),
                          color: Colors.transparent,
                        ),
                        child: TextButton(
                          onPressed:
                              _isAgreed ? _showRegistrationSuccess : null,
                          child: Text(
                            "Next",
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 116, 54, 2),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
