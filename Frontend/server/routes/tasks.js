const express = require("express");
const Task = require("../models/Task");
const authMiddleware = require("../middleware/auth"); // use your auth middleware
const router = express.Router();

// GET all tasks for user
router.get("/api/tasks", authMiddleware, async (req, res) => {
  try {
    const tasks = await Task.find({ userId: req.user.id });
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
      userId: req.user.id,
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
    const updatedTask = await Task.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
    });
    res.json(updatedTask);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
