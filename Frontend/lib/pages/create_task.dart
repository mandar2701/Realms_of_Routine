import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  int _selectedDifficulty = 1;

  void _createTask() {
    String title = _titleController.text.trim();
    String notes = _notesController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please enter a title")));
      return;
    }

    // TODO: Save task to database or state manager
    print(
      "Task Created: Title=$title, Notes=$notes, Difficulty=$_selectedDifficulty",
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Task created successfully!")));

    _titleController.clear();
    _notesController.clear();
    setState(() {
      _selectedDifficulty = 1;
    });
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
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            stars,
            (index) => const Icon(Icons.star, color: Colors.lightBlueAccent),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/Background/create_task.png",
            ), // replace with your fantasy background
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title banner
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
                    hintStyle: GoogleFonts.imFellEnglish(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 86, 69, 46),
                    ),
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
                    hintStyle: GoogleFonts.imFellEnglish(
                      fontSize: 18,
                      color: const Color.fromARGB(255, 86, 69, 46),
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),

                // Difficulty
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

                // Create task button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 8,
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
