const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const UserInfo = require("../models/userInfo");
const AccountStats = require("../models/accountStats");
const authRouter = express.Router();
const auth = require("../middleware/auth");

// 🌟 Define the missing helper function here 🌟
function parseBirthDate(dateString) {
  if (!dateString) return null;
  // Assumes input format DD/MM/YYYY, converts to standard Date object, and returns ISO string
  const parts = dateString.split('/');
  if (parts.length === 3) {
    const d = parseInt(parts[0], 10);
    const m = parseInt(parts[1], 10);
    const y = parseInt(parts[2], 10);
    const date = new Date(Date.UTC(y, m - 1, d)); // Note: Month is 0-indexed
    // Simple check to ensure date components are valid (e.g., prevents 32/01/2000)
    if (date && date.getUTCFullYear() === y && date.getUTCMonth() === m - 1 && date.getUTCDate() === d) {
      return date.toISOString();
    }
  }
  return null;
}

// Sign Up
authRouter.post("/api/signup", async (req, res) => {
  console.log("Received signup data:", req.body);
  try {
    const { name, email, password, age, birthDate, gender, hero } = req.body;

    // Basic Validation - Re-added missing initial checks from your earlier code snippet
    if (!name || !email || !password || !age || !birthDate || !gender || !hero) {
      return res.status(400).json({ msg: "All fields are required!" });
    }

    // Check if email exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }

    // Hash password
    const hashedPassword = await bcryptjs.hash(password, 8);
    let user = new User({
      email,
      password: hashedPassword,
      name,
    });
    user = await user.save();

    // Safely parse date and age if these functions were in your previous full code
    const parsedBirthDate = parseBirthDate(birthDate);
    if (!parsedBirthDate) {
      return res.status(400).json({ msg: "Invalid birthDate format. Use DD/MM/YYYY" });
    }

    const parsedAge = Number(age);
    if (isNaN(parsedAge) || parsedAge <= 0) {
      return res.status(400).json({ msg: "Age must be a positive number" });
    }

    const heroData = hero || { duty: "", focus: "", goal: "" };

    // FIX: Add userId to link to the newly created user document
    let userInfo = new UserInfo({
        userId: user._id, // <--- CORRECTED LINE
        username: name,
        age: parsedAge,
        birthDate: parsedBirthDate,
        gender,
        hero: {
            duty: heroData.duty,
            focus: heroData.focus,
            goal: heroData.goal,
        }
    });
    userInfo = await userInfo.save();

    // Create initial AccountStats
    let accountStats = new AccountStats({
        userId: user._id,
        // The remaining fields will automatically use defaults from schema
    });
    accountStats = await accountStats.save();

    const token = jwt.sign({ id: user._id }, "passwordKey");
    // Send back ALL user data
    res.json({
      token,
      email: user.email,
      name: user.name,
      age: userInfo.age,
      birthDate: userInfo.birthDate,
      gender: userInfo.gender,
      hero: userInfo.hero,
      accountStats: accountStats,
    });

  } catch (e) {
    console.error("Signup error:", e);
    // IMPROVEMENT: Handle validation errors specifically (400)
    if (e.name === 'ValidationError') {
      return res.status(400).json({ msg: e.message });
    }
    res.status(500).json({ error: e.message });
  }
});
// Sign In
authRouter.post("/api/signin", async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist!" });
    }

    const isMatch = await bcryptjs.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password." });
    }

    const userInfo = await UserInfo.findOne({ username: user.name });
    const accountStats = await AccountStats.findOne({ userId: user._id }) || {};
    const token = jwt.sign({ id: user._id }, "passwordKey");

    // Safely combine user, userInfo, and token in the response
    res.json({ token, ...user._doc, ...(userInfo ? userInfo._doc : {}), ...(accountStats ? accountStats._doc : {}) });

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get User Data (for app startup)
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  // Also fetch the userInfo to send back a complete user object
  const userInfo = await UserInfo.findOne({ username: user._id });
  const accountStats = await AccountStats.findOne({ userId: user._id });

  res.json({ ...user._doc, ...(userInfo ? userInfo._doc : {}), ...(accountStats ? accountStats._doc : {}), token: req.token });
});

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get Hero Data by Username (Used by Python AI service)
authRouter.get("/api/hero/:username", async (req, res) => {
  try {
    const username = req.params.username;

    if (!username) {
      return res.status(400).json({ msg: "Username parameter is required." });
    }

    // 1. Find UserInfo by username
    const userInfo = await UserInfo.findOne({ username });

    if (!userInfo) {
      return res.status(404).json({ msg: "User hero data not found." });
    }

    // 2. Return the hero details for the Python script
    // We only return the `hero` object fields which are needed for the AI prompt
    res.json({
      duty: userInfo.hero.duty,
      focus: userInfo.hero.focus,
      goal: userInfo.hero.goal,
    });

  } catch (e) {
    console.error("Get Hero Data error:", e);
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;