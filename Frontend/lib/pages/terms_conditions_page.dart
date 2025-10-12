import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:life_xp_project/pages/login_page.dart';
import 'package:life_xp_project/services/auth_services.dart';

import '../utils/constants.dart';
import '../utils/utils.dart';

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
  // FIX: Instantiate AuthService
  final AuthService authService = AuthService();

  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String age,
    required String birthDate, // Ensure DD/MM/YYYY format
    required String gender,
    required Map<String, String> hero,
  }) async {
    try {
      // Ensure hero object has all keys
      final heroData = {
        'duty': hero['duty'] ?? '',
        'focus': hero['focus'] ?? '',
        'goal': hero['goal'] ?? '',
      };

      final body = jsonEncode({
        'email': email.trim(),
        'password': password.trim(),
        'name': name.trim(),
        'age': age.trim(), // keep as string, backend will parse
        'birthDate': birthDate.trim(), // must be DD/MM/YYYY
        'gender': gender.trim(),
        'hero': heroData,
      });

      final res = await http.post(
        Uri.parse('${Constants.NODE_API_BASE_URL}/api/signup'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: body,
      );

      // Handle response
      if (res.statusCode == 200) {
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text('Signup Success'),
                content: const Text('You have successfully signed up!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      } else {
        final decoded = jsonDecode(res.body);
        showSnackBar(decoded['msg'] ?? 'Signup failed');
      }
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  // This function is redundant because authService.signUpUser already shows a success dialog.
  // You can remove it if you want to.

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
                              _isAgreed
                                  ? () {
                                    signUpUser(
                                      context: context,
                                      email: widget.email,
                                      password: widget.password,
                                      name: widget.name,
                                      age: widget.age,
                                      birthDate: widget.birthDate,
                                      gender: widget.gender,
                                      hero: widget.hero,
                                    );
                                  }
                                  : null,
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
