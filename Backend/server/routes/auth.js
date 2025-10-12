const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const UserInfo = require("../models/userInfo");
const AccountStats = require("../models/accountStats");
const authRouter = express.Router();
const auth = require("../middleware/auth");

// Helper function to parse date strings like "DD/MM/YYYY"
function parseBirthDate(dateStr) {
  try {
    const [day, month, year] = dateStr.split("/").map(Number);
    if (!day || !month || !year) return null;
    return new Date(year, month - 1, day); // JS months are 0-indexed
  } catch (err) {
    return null;
  }
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
  console.log("Received signin data:", req.body);
  try {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ msg: "Email and password are required!" });
    }

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

    // FIX: Query UserInfo by userId (ObjectId), not the string username field
    const userInfo = await UserInfo.findOne({ userId: user._id });
    const accountStats = await AccountStats.findOne({ userId: user._id });
    const token = jwt.sign({ id: user._id }, "passwordKey");

    // Safely combine user, userInfo, and token in the response
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
    console.error("Signin error:", e);
    res.status(500).json({ error: e.message });
  }
});

// Get User Data (for app startup)
authRouter.get("/", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) {
        return res.status(404).json({ msg: "User not found." });
    }

    // FIX: Query UserInfo by userId (ObjectId), not the string username field
    const userInfo = await UserInfo.findOne({ userId: user._id });
    const accountStats = await AccountStats.findOne({ userId: user._id });

    // Ensure all necessary documents exist before merging/sending
    if (!userInfo || !accountStats) {
        // This is a data inconsistency error, better than a crash
        console.error(`Inconsistent data for user ${user._id}: Missing userInfo or accountStats`);
        // If a new user, maybe send a setup prompt later, but for now, throw error.
        return res.status(500).json({ msg: "Incomplete user profile data. Please try re-logging."});
    }

    // Use explicit field names for consistency and clarity in client apps
    res.json({
        token: req.token,
        email: user.email,
        name: user.name,
        age: userInfo.age,
        birthDate: userInfo.birthDate,
        gender: userInfo.gender,
        hero: userInfo.hero,
        accountStats: accountStats,
    });
  } catch (e) {
    console.error("Get User Data error:", e);
    res.status(500).json({ error: e.message });
  }
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

module.exports = authRouter;