import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background
          SizedBox.expand(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.fill,
            ),
          ),

          // Form
          Column(
            children: [
              SizedBox(height: screenHeight * 0.15),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: screenWidth * 0.85,
                      height: screenHeight * 0.63,
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.10),
                          buildInputField("Username", screenHeight, true),
                          SizedBox(height: screenHeight * 0.03),
                          buildInputField("Password", screenHeight, true, isPassword: true),
                          SizedBox(height: screenHeight * 0.03),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Color(0xFFEEEEEE),
                                fontFamily: 'Cinzel',
                                fontSize: screenHeight * 0.015,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Login button
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                width: screenWidth * 0.4,
                                height: screenHeight * 0.07,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFB66A2F),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black45),
                                ),
                                child: Center(
                                  child: Text(
                                    "LOGIN",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: screenHeight * 0.022,
                                      fontFamily: 'Cinzel',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          // Switch to Signup
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "New user ?",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: screenHeight * 0.015,
                                    fontFamily: 'Cinzel',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignupPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                      color: Color(0xFFFFE57F),
                                      fontSize: screenHeight * 0.022,
                                      fontFamily: 'Cinzel',
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Reusable input field
Widget buildInputField(
    String label, double screenHeight, bool isLogin,
    {bool isPassword = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: Color(0xFFEFDCC3),
          fontSize: screenHeight * 0.025,
          fontFamily: 'Cinzel',
        ),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isLogin ? const Color(0xFFFFA726) : const Color(0xFFE5B769),
              width: 2,
            ),
          ),
        ),
        child: TextField(
          obscureText: isPassword,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),
          ),
        ),
      ),
    ],
  );
}
