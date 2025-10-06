import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/task_manager.dart';
import '../models/tasks.dart';
import '../providers/user_provider.dart';

class CreateTaskScreen extends StatefulWidget {
  final DateTime? selectedDate;

  const CreateTaskScreen({super.key, this.selectedDate});

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
          content: Text("Authentication is required to create a task."),
        ),
      );
      return;
    }

    final taskManager = Provider.of<TaskManager>(context, listen: false);
    final title = _titleController.text.trim();
    final notes = _notesController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a title for your quest.")),
      );
      return;
    }

    final taskName = notes.isEmpty ? title : "$title ($notes)";

    String priority;
    if (_selectedDifficulty == 1) {
      priority = "Low";
    } else if (_selectedDifficulty == 2) {
      priority = "Medium";
    } else {
      priority = "High";
    }

    // ✅ FIX: This now correctly uses the date from the calendar.
    final DateTime taskDate = widget.selectedDate ?? DateTime.now();

    final newTask = Task(
      name: taskName,
      priority: priority,
      description: notes.isNotEmpty ? notes : null,
      createdAt: taskDate,
      dueDate: taskDate,
    );

    try {
      await taskManager.addTask(newTask, token);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("A new quest has begun!")));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create quest: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
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
                      "Difficulty",
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
