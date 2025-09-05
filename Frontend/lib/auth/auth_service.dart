import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  /// Signup with username, email, and password
  Future<bool> signUp(String username, String email, String password) async {
    try {
      // Step 1: Create user in Supabase Auth
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return false;
      }

      // Step 2: Store extra details in "profiles" table
      await supabase.from('profiles').insert({
        'id': user.id,       // UUID from Supabase Auth
        'username': username,
        'email': email,
      });

      return true;
    } catch (e) {
      print("Signup error: $e");
      return false;
    }
  }

  // Login using email + password
  Future<AuthResponse> login(String email, String password) async {
    return await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// Logout user
  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  /// Get current user
  User? get currentUser => supabase.auth.currentUser;
}
