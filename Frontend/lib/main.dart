import 'package:flutter/material.dart';
import 'package:life_xp_project/providers/user_provider.dart';
import 'package:life_xp_project/services/auth_services.dart';
import 'package:provider/provider.dart';

import 'models/player_manager.dart';
import 'models/task_manager.dart';
import 'pages/home_screen.dart';

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
  @override
  void initState() {
    super.initState();
    authService.getUserData(context);
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Realms of Routine',
      home:
          Provider.of<UserProvider>(context).user.token.isEmpty
              ? const HomeScreen()
              : const HomeScreen(),
    );
  }
}
