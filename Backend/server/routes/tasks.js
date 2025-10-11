const express = require("express");
const Task = require("../models/Task");
const AccountStats = require('../models/accountStats');
const authMiddleware = require("../middleware/auth"); // use your auth middleware
const router = express.Router();

// Helper function to calculate XP based on difficulty
const calculateXp = (difficulty) => {
    switch (difficulty) {
        case 'Easy':
            return 10;
        case 'Medium':
            return 25;
        case 'Hard':
            return 50;
        default:
            return 15;
    }
};


// GET all tasks for user
router.get("/api/tasks", authMiddleware, async (req, res) => {
  try {
    const tasks = await Task.find({ userId: req.user });
    res.json(tasks);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// CREATE a new task
router.post("/api/tasks", authMiddleware, async (req, res) => {
  try {
    const { name, difficulty, dueDate } = req.body;
    const newTask = new Task({
      userId: req.user,
      name,
      difficulty,
      dueDate,
    });
    const savedTask = await newTask.save();
    res.status(201).json(savedTask);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// UPDATE task (complete or delete)
router.patch("/api/tasks/:id", authMiddleware, async (req, res) => {
  try {
    const taskId = req.params.id;
    const updateBody = req.body;

    // 1. Get the current state of the task
    const existingTask = await Task.findById(taskId);

    if (!existingTask) {
        return res.status(404).json({ error: "Task not found." });
    }

    const isCompletionAttempt = updateBody.completed === true;
    const wasAlreadyCompleted = existingTask.completed === true;

    // 2. Perform the task update
    const updatedTask = await Task.findByIdAndUpdate(taskId, updateBody, {
      new: true,
    });

    // 3. Handle XP/Stats update ONLY on first successful completion
    if (isCompletionAttempt && !wasAlreadyCompleted) {
        // Calculate XP based on task details (assuming 'difficulty' field exists in Task model)
        const xpChange = calculateXp(existingTask.difficulty);

        let stats = await AccountStats.findOne({ userId: req.user.id });

        if (!stats) {
            // Create a new stats document if it somehow doesn't exist
            stats = new AccountStats({ userId: req.user.id });
        }

        // --- XP and Level Up Logic (copied and adapted from stats.js for consistency) ---
        stats.xp += xpChange;
        stats.tasksCompleted += 1;

        let levelsGained = 0;
        let xpNeededForNextLevel = stats.level * 100;

        while (stats.xp >= xpNeededForNextLevel) {
            stats.xp -= xpNeededForNextLevel;
            stats.level += 1;
            levelsGained++;
            xpNeededForNextLevel = stats.level * 100;
        }

        if (levelsGained > 0) {
            // Grant 5 stat points for every level gained
            stats.statPoints += levelsGained * 5;
        }

        await stats.save(); // Save the updated stats to the database!
    }

    res.json(updatedTask);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;