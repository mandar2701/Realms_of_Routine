import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'signup_page.dart';
import '../auth/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;
  String? errorMessage;

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      if (_emailController.text.trim().isEmpty ||
          _passwordController.text.trim().isEmpty) {
        setState(() {
          isLoading = false;
          errorMessage = "Please enter both email and password.";
        });
        return;
      }

     final user = await AuthService().login(
  _emailController.text.trim(),
  _passwordController.text.trim(),
);

if (user != null) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomeScreen()),
  );
} else {
  setState(() {
    errorMessage = "Invalid email or password.";
  });
}
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error: ${e.toString()}";
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

                          // Email
                          buildInputField(
                            "Email",
                            screenHeight,
                            true,
                            controller: _emailController,
                          ),
                          SizedBox(height: screenHeight * 0.03),

                          // Password
                          buildInputField(
                            "Password",
                            screenHeight,
                            true,
                            controller: _passwordController,
                            isPassword: true,
                          ),

                          SizedBox(height: screenHeight * 0.03),

                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: const Color(0xFFEEEEEE),
                                fontFamily: 'Cinzel',
                                fontSize: screenHeight * 0.015,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                          SizedBox(height: screenHeight * 0.02),

                          if (errorMessage != null)
                            Center(
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                          SizedBox(height: screenHeight * 0.03),

                          // Login button
                          Center(
                            child: isLoading
                                ? const CircularProgressIndicator()
                                : GestureDetector(
                                    onTap: _handleLogin,
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
                                        builder: (context) =>
                                            const SignupPage(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "SIGN UP",
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

// Reusable input field
Widget buildInputField(
  String label,
  double screenHeight,
  bool isLogin, {
  bool isPassword = false,
  TextEditingController? controller,
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
              color:
                  isLogin ? const Color(0xFFFFA726) : const Color(0xFFE5B769),
              width: 2,
            ),
          ),
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          keyboardType: label == "Email"
              ? TextInputType.emailAddress
              : TextInputType.text,
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
