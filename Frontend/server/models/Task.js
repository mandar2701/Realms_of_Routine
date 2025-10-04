const mongoose = require("mongoose");

const taskSchema = new mongoose.Schema({
  userId: { type: String, required: true }, // associate tasks with a user
  name: { type: String, required: true },
  difficulty: { type: String, required: true }, // low, medium, high
  status: {
    type: String,
    enum: ["pending", "completed", "deleted"],
    default: "pending",
  },
  createdAt: { type: Date, default: Date.now },
  dueDate: { type: Date },
});

module.exports = mongoose.model("Task", taskSchema);
