import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
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

    final now = DateTime.now();
    final selected = widget.selectedDate ?? now;
    final DateTime taskDate = DateTime(
      selected.year,
      selected.month,
      selected.day,
    );

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
      body: Stack(
        children: [
          // Full-screen background
          SizedBox.expand(
            child: Image.asset(
              "assets/Background/create_task.png",
              fit: BoxFit.fill,
            ),
          ),
          // Glassmorphic foreground
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.1, // Shift down
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                bottom: screenHeight * 0.02,
              ),
              child: GlassmorphicContainer(
                width: double.infinity,
                height: screenHeight * 0.85, // leave some bottom space
                borderRadius: 20,
                blur: 5,
                alignment: Alignment.topCenter,
                border: 1,
                linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.03,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: screenHeight * 0.02),

                        // Title field
                        TextField(
                          controller: _titleController,
                          style: GoogleFonts.cinzel(
                            color: Color(0xFFB66A2F),
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            labelText: "Title",
                            labelStyle: GoogleFonts.cinzel(
                              color: Color(0xFFB66A2F),
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true, // enables background fill
                            fillColor: Colors.white.withOpacity(0.15),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFB66A2F),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.amber),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Notes field
                        TextField(
                          controller: _notesController,
                          maxLines: 4,
                          style: GoogleFonts.cinzel(
                            color: Color(0xFFB66A2F),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            labelText: "Notes",
                            labelStyle: GoogleFonts.cinzel(
                              color: Color(0xFFB66A2F),
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true, // enables background fill
                            fillColor: Colors.white.withOpacity(0.3),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Color(0xFFB66A2F),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.amber),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Difficulty
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
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDifficultyButton(stars: 1, ratio: 4),
                            _buildDifficultyButton(stars: 2, ratio: 6),
                            _buildDifficultyButton(stars: 3, ratio: 7),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        // Create button
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB66A2F),
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.25,
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
                        SizedBox(height: screenHeight * 0.03),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultyButton({required int stars, required double ratio}) {
    bool isSelected = _selectedDifficulty == stars;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Total ratio sum
    final totalRatio = 3 + 6 + 9; // hardcoded for now

    // Button width proportional to its ratio
    final buttonWidth = (screenWidth * 0.8) * (ratio / totalRatio);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDifficulty = stars;
        });
      },
      child: Container(
        width: buttonWidth,
        height: screenHeight * 0.07,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFB66A2F),
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.amber, width: 2) : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            stars,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Image.asset(
                'assets/icons/star.png',
                width: buttonWidth / (stars * 2),
                height: screenHeight * 0.03,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
