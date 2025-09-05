import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'login_page.dart';
import '../auth/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> _handleSignup() async {
    if (_passwordController.text.trim() !=
        _confirmPasswordController.text.trim()) {
      setState(() => errorMessage = "Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
  final success = await AuthService().signUp(
    _usernameController.text.trim(),
    _emailController.text.trim(),
    _passwordController.text.trim(),
  );

  setState(() {
    isLoading = false;
  });

  if (success) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } else {
    setState(() {
      errorMessage = "Signup failed. Try again.";
    });
  }
} catch (e) {
  setState(() {
    isLoading = false;
    errorMessage = e.toString();
  });
}
try {
  final success = await AuthService().signUp(
    _usernameController.text.trim(),
    _emailController.text.trim(),
    _passwordController.text.trim(),
  );

  setState(() {
    isLoading = false;
  });

  if (success) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } else {
    setState(() {
      errorMessage = "Signup failed. Try again.";
    });
  }
} catch (e) {
  setState(() {
    isLoading = false;
    errorMessage = e.toString();
  });
}

  }

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
              'assets/images/background2.png',
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
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: screenHeight * 0.05),

                          buildInputField(
                            "Username",
                            screenHeight,
                            controller: _usernameController,
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          buildInputField(
                            "Email",
                            screenHeight,
                            controller: _emailController,
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          buildInputField(
                            "Password",
                            screenHeight,
                            controller: _passwordController,
                            isPassword: true,
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          buildInputField(
                            "Confirm Password",
                            screenHeight,
                            controller: _confirmPasswordController,
                            isPassword: true,
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          if (errorMessage != null)
                            Center(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),

                          SizedBox(height: screenHeight * 0.02),

                          // Signup button
                          Center(
                            child: GestureDetector(
                              onTap: isLoading ? null : _handleSignup,
                              child: Container(
                                width: screenWidth * 0.4,
                                height: screenHeight * 0.07,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isLoading
                                      ? Colors.grey
                                      : const Color(0xFFB66A2F),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.black45),
                                ),
                                child: Center(
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          "SIGN UP",
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

                          // Switch to Login
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "Already a user ?",
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
                                        builder: (context) => const LoginPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "LOG IN",
                                    style: TextStyle(
                                      color: const Color(0xFFFFE57F),
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

// Helper input field with controller
Widget buildInputField(
  String label,
  double screenHeight, {
  bool isPassword = false,
  required TextEditingController controller,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: TextStyle(
          color: const Color(0xFFEFDCC3),
          fontSize: screenHeight * 0.025,
          fontFamily: 'Cinzel',
        ),
      ),
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFFE5B769),
              width: 2,
            ),
          ),
        ),
        child: TextField(
          controller: controller,
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
