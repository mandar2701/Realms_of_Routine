import 'package:flutter/material.dart';
import 'package:life_xp_project/pages/signup_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../pages/login_page.dart';
import '../../pages/home_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // User is signed in → Home
        if (supabase.auth.currentSession != null) {
          return const HomeScreen();
        }

        // User is not signed in → Login
        return const LoginPage();
      },
    );
  }
}
