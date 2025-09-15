import 'package:flutter/material.dart';
import 'package:life_xp_project/pages/signup_page.dart';
import 'pages/todo_screen.dart';
import 'pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'models/task_manager.dart';
import 'models/player_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
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
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Realms of Routine',

      // Start with AuthPage (login/signup toggle)
      home: const SignupPage(),

      // Optionally, define routes here if you want navigation
      //  routes: {
      //  '/home': (context) => const HomeScreen(),
      //'/todo': (context) => const TodoScreen(),
      //},
    );
  }
}
