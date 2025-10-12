const express = require("express");
const mongoose = require("mongoose"); // <--- CRITICAL FIX: Need mongoose import
const Task = require("../models/Task");
const AccountStats = require('../models/accountStats');
const authMiddleware = require("../middleware/auth");
const router = express.Router();

// Helper function to calculate XP based on difficulty (Adjusted logic to match your model strings)
const calculateXp = (difficulty) => {
    // Assuming 'Easy', 'Medium', 'Hard' are the expected strings
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

// GET all tasks for user (Existing code unchanged)
router.get("/api/tasks", authMiddleware, async (req, res) => {
  try {
    const tasks = await Task.find({ userId: req.user });
    res.json(tasks);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// CREATE a new task (Existing code unchanged)
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

// UPDATE task (complete or delete) - FIXED/ROBUST LOGIC
router.patch("/api/tasks/:id", authMiddleware, async (req, res) => {
  try {
    const taskId = req.params.id;
    const updateBody = req.body;

    const userId = new mongoose.Types.ObjectId(req.user.id); // <--- FIX: Define userId first

    const existingTask = await Task.findById(taskId);

    if (!existingTask) {
        return res.status(404).json({ error: "Task not found." });
    }

    const isCompletionAttempt = updateBody.status === 'completed';
    const wasAlreadyCompleted = existingTask.status === 'completed';

    // 1. Perform the task update
    const updatedTask = await Task.findByIdAndUpdate(taskId, updateBody, {
      new: true,
    });

    // 2. Handle XP/Stats update ONLY on first successful completion
    if (isCompletionAttempt && !wasAlreadyCompleted) {

        const xpChange = calculateXp(existingTask.difficulty);

        // FIX: Atomic update to increment XP and task count.
        // We use upsert: true to create the stat document if it doesn't exist.
        let stats = await AccountStats.findOneAndUpdate(
            { userId: userId },
            {
                $inc: { xp: xpChange, tasksCompleted: 1 },
                // Use $setOnInsert to ensure all defaults are set on creation,
                // preventing errors later. This is defensive programming.
                $setOnInsert: {
                    level: 1,
                    statPoints: 0,
                    stats: { strength: 1, agility: 1, vigor: 1, stamina: 1, defense: 1 }
                }
            },
            {
                new: true, // Return the updated document
                upsert: true, // Create if missing
                runValidators: true,
                setDefaultsOnInsert: true // Applies defaults from schema on upsert
            }
        );

        if (!stats) {
            // Should be rare due to upsert: true, but good practice.
            console.error("Failed to find or create AccountStats for user:", userId);
            return res.json(updatedTask);
        }

        // --- Level Up Logic (Calculates any required level/XP changes) ---
        let levelsGained = 0;
        let currentXP = stats.xp;
        let currentLevel = stats.level;
        let xpNeededForNextLevel = currentLevel * 100;

        while (currentXP >= xpNeededForNextLevel) {
            currentXP -= xpNeededForNextLevel;
            currentLevel += 1;
            levelsGained++;
            xpNeededForNextLevel = currentLevel * 100;
        }

        if (levelsGained > 0) {
            // FIX: Atomic update to set the new level, remaining XP, and grant stat points (5 points/level)
            const pointsGained = levelsGained * 5;

            await AccountStats.updateOne(
                { userId: userId },
                {
                    $set: { level: currentLevel, xp: currentXP },
                    $inc: { statPoints: pointsGained } // Atomically adds points
                }
            );
        }
    }

    res.json(updatedTask);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;