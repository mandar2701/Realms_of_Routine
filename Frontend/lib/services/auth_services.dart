import 'dart:convert';

import 'package:flutter/material.dart';
import '/models/user.dart';
import '/providers/user_provider.dart';
import '/pages/home_screen.dart';
import '/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '/utils/constants.dart';
import '/utils/utils.dart'; // Your updated utils file is used here
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUpUser({
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
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        token: '',
        age: age,
        birthDate: birthDate,
        gender: gender,
        duty: duty,
        focus: focus,
        goal: goal,
      );

      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/signup'),
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'age': age,
          'birthDate': birthDate,
          'gender': gender,
          'hero': hero,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        // ✅ context is NO LONGER needed here
        onSuccess: () {
          // This context is still needed for the Dialog and Navigator
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Signup Success'),
                content: const Text('You have successfully signed up!'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      // Use the stored navigator
                      navigator.pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      // ✅ Call the global showSnackBar without context
      showSnackBar(e.toString());
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
      http.Response res = await http.post(
        Uri.parse('${Constants.uri}/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          print('[2] ATTEMPTING to parse JSON and save token...');
          final decodedBody = jsonDecode(res.body);
          await prefs.setString('x-auth-token', decodedBody['token']);
          print('[2] SUCCESS: Token saved.');

          print('[3] ATTEMPTING to set user in UserProvider...');
          userProvider.setUser(res.body);
          print('[3] SUCCESS: User set in provider.');

          print('[4] ATTEMPTING to navigate to HomeScreen...');
          navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // get user data
  void getUserData(BuildContext context) async {
    try {
      var userProvider = Provider.of<UserProvider>(context, listen: false);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        prefs.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('${Constants.uri}/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.uri}/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
