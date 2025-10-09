const express = require("express");
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user");
const UserInfo = require("../models/userInfo"); // Make sure this is imported
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

    const token = jwt.sign({ id: user._id }, "passwordKey");
    // Send back ALL user data
    res.json({ token, ...user._doc, ...userInfo._doc });

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

    const userInfo = await UserInfo.findOne({ username: user.name });
    const token = jwt.sign({ id: user._id }, "passwordKey");

    // Safely combine user, userInfo, and token in the response
    res.json({ token, ...user._doc, ...(userInfo ? userInfo._doc : {}) });

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get User Data (for app startup)
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  // Also fetch the userInfo to send back a complete user object
  const userInfo = await UserInfo.findOne({ username: user.name });

  res.json({ ...user._doc, ...(userInfo ? userInfo._doc : {}), token: req.token });
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