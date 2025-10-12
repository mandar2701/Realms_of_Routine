const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const UserInfo = require("../models/userInfo");
const AccountStats = require("../models/accountStats");
const authRouter = express.Router();

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

    // Check if email exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ msg: "User with same email already exists!" });
    }

    // Check if username exists
    const existingUserInfo = await UserInfo.findOne({ username: name });
    if (existingUserInfo) {
      return res.status(400).json({ msg: "Username is already taken." });
    }

    // Hash password
    const hashedPassword = await bcryptjs.hash(password, 8);

    // Create User
    let user = new User({ email, password: hashedPassword, name });
    user = await user.save();

    // Safely parse birthDate
    const parsedBirthDate = parseBirthDate(birthDate);
    if (!parsedBirthDate) {
      return res.status(400).json({ msg: "Invalid birthDate format. Use DD/MM/YYYY" });
    }

    // Create UserInfo
    let userInfo = new UserInfo({
      username: name,
      age,
      birthDate: parsedBirthDate,
      gender,
      hero: {
        duty: hero.duty,
        focus: hero.focus,
        goal: hero.goal,
      },
    });
    userInfo = await userInfo.save();

    // Create AccountStats
    let accountStats = new AccountStats({ userId: user._id });
    accountStats = await accountStats.save();

    // Create token
    const token = jwt.sign({ id: user._id }, "passwordKey");

    // Send combined data
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
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

module.exports = authRouter;
