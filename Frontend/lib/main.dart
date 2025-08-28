import 'package:flutter/material.dart';
import 'pages/auth_page.dart'; // login/signup combined page
import 'pages/todo_screen.dart';
import 'pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'models/task_manager.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => TaskManager(), child: const MyApp()),
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
      home: const AuthPage(),

      // Optionally, define routes here if you want navigation
      //  routes: {
      //  '/home': (context) => const HomeScreen(),
      //'/todo': (context) => const TodoScreen(),
      //},
    );
  }
}
