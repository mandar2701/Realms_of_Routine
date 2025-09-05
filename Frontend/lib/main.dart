import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../auth/auth_gate.dart'; 
import 'pages/todo_screen.dart';
import 'pages/home_screen.dart';
import 'package:provider/provider.dart';
import 'models/task_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://heezcnpcnitfvolbohpf.supabase.co',     // 🔑 from Supabase project settings
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhlZXpjbnBjbml0ZnZvbGJvaHBmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTY1NjIzMzMsImV4cCI6MjA3MjEzODMzM30._hQVn6IimTJjnHUz-n-ntTZ1Ja7xyMOKEXkFoZHdqE0', 
  );
 
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
      home: const AuthGate(),

      // Optionally, define routes here if you want navigation
      //  routes: {
      //  '/home': (context) => const HomeScreen(),
      //'/todo': (context) => const TodoScreen(),
      //},
    );
  }
}
