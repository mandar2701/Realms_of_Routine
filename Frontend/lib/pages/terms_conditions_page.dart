import 'package:flutter/material.dart';
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_signup.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/info_bg6.jpg',
              width: MediaQuery.of(context).size.width * 1.25,
              height: MediaQuery.of(context).size.height * 2.5,
            ),
          ),
          _buildTermsContent(context),
        ],
      ),
    );
  }

  Widget _buildTermsContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double contentWidth = 300;
    const double buttonWidth = 200;
    final double horizontalPadding = (screenWidth - contentWidth) / 2;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(horizontalPadding, 250, horizontalPadding, 20),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 30),
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
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _isAgreed ? _showRegistrationSuccess : null,
                child: Opacity(
                  opacity: _isAgreed ? 1.0 : 0.5,
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
          ),
        ),
      ],
    );
  }
}