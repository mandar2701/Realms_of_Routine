import 'package:flutter/material.dart';
import 'home_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true; // Toggle flag

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              isLogin
                  ? 'assets/images/background.png'
                  : 'assets/images/background2.png',
              fit: BoxFit.fill,
            ),
          ),

          // Form Content
          Column(
            children: [
              SizedBox(
                height: isLogin ? screenHeight * 0.15 : screenHeight * 0.15,
              ), // Empty space at top
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Container(
                      width: screenWidth * 0.85,
                      height:
                          isLogin ? screenHeight * 0.63 : screenHeight * 0.70,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.10),
                          buildInputField("Username", screenHeight),
                          SizedBox(height: screenHeight * 0.03),

                          buildInputField(
                            "Password",
                            screenHeight,
                            isPassword: true,
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          if (!isLogin) ...[
                            buildInputField(
                              "Confirm Password",
                              screenHeight,
                              isPassword: true,
                            ),
                            SizedBox(height: screenHeight * 0.03),
                          ],

                          if (isLogin)
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

                          // Centered Auth Button
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
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
                                    isLogin ? "LOGIN" : "SIGN UP",
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

                          Center(
                            child: Column(
                              children: [
                                Text(
                                  isLogin ? "New user ?" : "Already a user ?",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: screenHeight * 0.015,
                                    fontFamily: 'Cinzel',
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isLogin = !isLogin;
                                    });
                                  },
                                  child: Text(
                                    isLogin ? "SIGN UP" : "LOG IN",
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

  Widget buildInputField(
    String label,
    double screenHeight, {
    bool isPassword = false,
  }) {
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
                color:
                    isLogin ? const Color(0xFFFFA726) : const Color(0xFFE5B769),
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
}
