import 'package:flutter/material.dart';
import 'home_screen.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orangeAccent, width: 2),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.2),
                ),
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Username Field
                    buildTextField(
                      controller: usernameController,
                      hintText: 'Username',
                    ),
                    SizedBox(height: 16),
                    // Password Field
                    buildTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      isPassword: true,
                    ),
                    SizedBox(height: 10),
                    // Forgot password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Colors.orange[100],
                            fontFamily: 'CinzelDecorative',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Login button
                    GestureDetector(
                      onTap: () {
                        // Handle login
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      },
                      child: Image.asset(
                        'assets/images/login_button.png',
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 30,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.brown,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(color: Colors.black38, blurRadius: 6),
                              ],
                            ),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: 'CinzelDecorative',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    // New user?
                    Text(
                      'New user?',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'CinzelDecorative',
                      ),
                    ),
                    SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        // Handle sign-up
                      },
                      child: Image.asset(
                        'assets/images/signup_button.png',
                        height: 45,
                        errorBuilder: (context, error, stackTrace) {
                          return Text(
                            'SIGN UP',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.orangeAccent,
                              fontFamily: 'CinzelDecorative',
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontFamily: 'CinzelDecorative',
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: Colors.white70,
          fontFamily: 'CinzelDecorative',
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
