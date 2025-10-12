import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/pages/home_screen.dart';
import '/pages/terms_conditions_page.dart';
import '/providers/user_provider.dart';
import '/utils/constants.dart';
import '/utils/utils.dart'; // Your updated utils file is used here

class AuthService {
  Future<void> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String age,
    required String birthDate,
    required String gender,
    required Map<String, String> hero,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${Constants.NODE_API_BASE_URL}/api/signup'),
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'age': int.parse(age),
          'birthDate': birthDate,
          'gender': gender,
          'hero': hero,
        }),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);

        // ✅ Navigate to TermsConditionsPage with hero included
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => TermsConditionsPage(
                  email: body['email'],
                  password: password,
                  name: body['name'],
                  age: body['age'].toString(),
                  birthDate: body['birthDate'],
                  gender: body['gender'],
                  hero: Map<String, String>.from(body['hero']),
                ),
          ),
        );
      } else {
        final body = jsonDecode(res.body);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(body['msg'] ?? 'Signup failed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      final navigator = Navigator.of(context);

      final res = await http.post(
        Uri.parse('${Constants.NODE_API_BASE_URL}/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('x-auth-token', body['token']);
        await prefs.setString('cached-user', jsonEncode(body));

        userProvider.setUser(jsonEncode(body));

        navigator.pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        final body = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['msg'] ?? 'Sign in failed')),
        );
      }
    } catch (e) {
      showSnackBar(e.toString());
    }
  }

  // get user data
  Future<void> getUserData(BuildContext context) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null || token.isEmpty) return;

      try {
        final tokenRes = await http
            .post(
              Uri.parse('${Constants.NODE_API_BASE_URL}/tokenIsValid'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                'x-auth-token': token,
              },
            )
            .timeout(const Duration(seconds: 3));

        final response = jsonDecode(tokenRes.body);

        if (response == true) {
          final userRes = await http.get(
            Uri.parse('${Constants.NODE_API_BASE_URL}/'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token,
            },
          );

          final userBody = jsonDecode(userRes.body);
          await prefs.setString('cached-user', jsonEncode(userBody));
          userProvider.setUser(jsonEncode(userBody));
        }
      } catch (e) {
        // Use cached user if network fails
        String? cachedUser = prefs.getString('cached-user');
        if (cachedUser != null && cachedUser.isNotEmpty) {
          userProvider.setUser(cachedUser);
        }
      }
    } catch (e) {
      // Ignore startup errors
    }
  }
}
