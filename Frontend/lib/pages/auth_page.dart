import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true; // Toggle flag

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.asset(
              isLogin
                  ? 'assets/images/background.png'
                  : 'assets/images/background2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Form Content
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),

                  buildInputField("Username"),
                  const SizedBox(height: 20),

                  buildInputField("Password", isPassword: true),
                  const SizedBox(height: 20),

                  if (!isLogin) ...[
                    buildInputField("Confirm Password", isPassword: true),
                    const SizedBox(height: 20),
                  ],

                  if (isLogin)
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Color(0xFFEEEEEE),
                          fontFamily: 'Cinzel',
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                  const SizedBox(height: 30),

                  // Centered Auth Button
                  Center(
                    child: Container(
                      width: 150,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB66A2F),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black45),
                      ),
                      child: Center(
                        child: Text(
                          isLogin ? "LOGIN" : "SIGN UP",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Cinzel',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Column(
                      children: [
                        Text(
                          isLogin ? "New user ?" : "Already a user ?",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontFamily: 'Cinzel',
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(
                            isLogin ? "SIGN UP" : "LOG IN",
                            style: const TextStyle(
                              color: Color(0xFFFFE57F),
                              fontSize: 20,
                              fontFamily: 'Cinzel',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInputField(String label, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFEFDCC3),
            fontSize: 18,
            fontFamily: 'Cinzel',
          ),
        ),
        const SizedBox(height: 6),
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
