const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const UserInfo = require("../models/userInfo");
const AccountStats = require("../models/accountStats");
const authRouter = express.Router();
const auth = require("../middleware/auth");

// Sign Up
authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, password, age, birthDate, gender, hero } = req.body;

    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }

    const existingUserInfo = await UserInfo.findOne({ username: name });
    if (existingUserInfo) {
        return res
            .status(400)
            .json({ msg: "Username is already taken." });
    }

    const hashedPassword = await bcryptjs.hash(password, 8);
    let user = new User({
      email,
      password: hashedPassword,
      name,
    });
    user = await user.save();

    let userInfo = new UserInfo({
        username: name,
        age,
        birthDate,
        gender,
        hero: {
            duty: hero.duty,
            focus: hero.focus,
            goal: hero.goal,
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
    res.json({ token, ...user._doc, ...userInfo._doc, ...accountStats._doc });

  } catch (e) {
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

    const userInfo = await UserInfo.findOne({ username: user._id });
    const accountStats = await AccountStats.findOne({ userId: user._id });
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

// GET hero info by username
authRouter.get("/api/hero/:username", async (req, res) => {
  try {
    const { username } = req.params;

    // Find the first UserInfo document with this username
    const userInfo = await UserInfo.findOne({ username });

    if (!userInfo) {
      return res.status(404).json({ msg: "User not found" });
    }

    // Return only the hero object
    res.json(userInfo.hero);

  } catch (err) {
    res.status(500).json({ error: err.message });
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