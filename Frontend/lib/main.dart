import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import '../pages/todo_screen.dart';

import 'pages/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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
      home: TodoScreen(
        // ✅ Pass function to toggle theme
      ),
    );
  }
}
