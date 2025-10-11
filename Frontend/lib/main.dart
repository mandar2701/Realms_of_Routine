import 'package:flutter/material.dart';
import 'package:life_xp_project/providers/user_provider.dart';
import 'package:life_xp_project/services/auth_services.dart';
import 'package:provider/provider.dart';

import 'models/player_manager.dart';
import 'models/task_manager.dart';
import 'pages/home_screen.dart';
import 'pages/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TaskManager()),
        ChangeNotifierProvider(create: (_) => PlayerManager()), // ✅ shared
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await authService.getUserData(context);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Realms of Routine',
      home: Provider.of<UserProvider>(context).user.token.isEmpty
          ? const SignupPage()
          : const HomeScreen(),
    );
  }
}
