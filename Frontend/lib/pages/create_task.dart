import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/task_manager.dart';
import '../models/tasks.dart';
import '../providers/user_provider.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  int _selectedDifficulty = 1;

  void _createTask() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.user.token;

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Authentication required to create task."),
        ),
      );
      return;
    }

    final taskManager = Provider.of<TaskManager>(context, listen: false);
    final title = _titleController.text.trim();
    final notes = _notesController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a title")));
      return;
    }

    final taskName = notes.isEmpty ? title : "$title ($notes)";

    // ✅ FIX: Renamed variable from 'difficulty' to 'priority'
    String priority;
    if (_selectedDifficulty == 1) {
      priority = "Low";
    } else if (_selectedDifficulty == 2) {
      priority = "Medium";
    } else {
      priority = "High";
    }

    final newTask = Task(
      name: taskName,
      // ✅ FIX: Use the correct 'priority' parameter
      priority: priority,
      description: notes.isNotEmpty ? notes : null,
    );

    try {
      await taskManager.addTask(newTask, token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task created successfully!")),
      );

      _titleController.clear();
      _notesController.clear();
      setState(() {
        _selectedDifficulty = 1;
      });

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving task: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Background/create_task.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              // Added for small screens
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.15),
                  TextField(
                    controller: _titleController,
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: GoogleFonts.cinzel(color: Colors.amber),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFB66A2F)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      labelText: "Notes",
                      labelStyle: GoogleFonts.cinzel(color: Colors.amber),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFB66A2F)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.amber),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Difficulty", // This is just a UI label, it can stay
                      style: GoogleFonts.cinzel(
                        color: Colors.amber,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDifficultyButton(1),
                      _buildDifficultyButton(2),
                      _buildDifficultyButton(3),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFB66A2F),
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.2,
                        vertical: screenHeight * 0.02,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _createTask,
                    child: Text(
                      "CREATE TASK",
                      style: GoogleFonts.cinzel(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyButton(int stars) {
    bool isSelected = _selectedDifficulty == stars;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDifficulty = stars;
        });
      },
      child: Container(
        width: screenWidth * 0.23,
        height: screenHeight * 0.06,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFB66A2F),
          borderRadius: BorderRadius.circular(8),
          border:
              isSelected
                  ? Border.all(color: Colors.yellowAccent, width: 2)
                  : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            stars,
            (index) => const Icon(Icons.star, color: Colors.lightBlueAccent),
          ),
        ),
      ),
    );
  }
}
