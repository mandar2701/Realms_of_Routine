import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/task_manager.dart';
import '../models/tasks.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  int _selectedDifficulty = 1;

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

  void _createTask() {
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

    // Assign difficulty string based on selected stars
    String difficulty;
    if (_selectedDifficulty == 1) {
      difficulty = "Low";
    } else if (_selectedDifficulty == 2) {
      difficulty = "Medium";
    } else {
      difficulty = "High";
    }

    // Create a Task object
    final newTask = Task(
      name: taskName,
      difficulty: difficulty,
      status: TaskStatus.pending,
    );

    // Add task to TaskManager
    taskManager.addTask(newTask);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Task created successfully!")));

    _titleController.clear();
    _notesController.clear();
    setState(() {
      _selectedDifficulty = 1;
    });

    Navigator.pop(context); // Go back to previous screen
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.15),

                // Title input
                TextField(
                  controller: _titleController,
                  style: GoogleFonts.imFellEnglish(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 86, 69, 46),
                  ),
                  decoration: InputDecoration(
                    hintText: "Title.....",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Notes input
                TextField(
                  controller: _notesController,
                  maxLines: 4,
                  style: GoogleFonts.imFellEnglish(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 86, 69, 46),
                  ),
                  decoration: InputDecoration(
                    hintText: "Notes.....",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Difficulty selector
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Difficulty",
                    style: GoogleFonts.imFellEnglish(
                      fontSize: 22,
                      color: Colors.black,
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

                // Create button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  onPressed: _createTask,
                  child: Text(
                    "CREATE TASK",
                    style: GoogleFonts.imFellEnglish(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
