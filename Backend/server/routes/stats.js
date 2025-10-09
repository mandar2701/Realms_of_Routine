const express = require('express');
const AccountStats = require('../models/accountStats');
const auth = require('../middleware/auth');
const statsRouter = express.Router();

// Route to fetch a user's stats
statsRouter.get('/api/stats', auth, async (req, res) => {
    try {
        // Use req.user.id provided by your auth middleware
        const stats = await AccountStats.findOne({ userId: req.user.id });

        if (!stats) {
             // If stats don't exist, create a default one (only happens on first login after adding this feature)
             const newStats = new AccountStats({ userId: req.user.id });
             await newStats.save();
             return res.json(newStats);
        }

        res.json(stats);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Route to manually update stats (e.g., when a task is completed)
statsRouter.post('/api/stats/update-xp', auth, async (req, res) => {
    try {
        const { xpChange } = req.body; // e.g., { xpChange: 50 }

        let stats = await AccountStats.findOne({ userId: req.user.id });

        if (!stats) {
            return res.status(404).json({ error: "Stats not found. User must login first." });
        }

        // --- XP and Level Up Logic ---
        stats.xp += xpChange;
        stats.tasksCompleted += 1;
        // Simple linear level up logic (e.g., 100 XP per level)
        const xpNeededForNextLevel = stats.level * 100;

        if (stats.xp >= xpNeededForNextLevel) {
            stats.level += 1;
            // Carry over excess XP
            stats.xp -= xpNeededForNextLevel;
            console.log(`User ${req.user.id} leveled up to ${stats.level}!`);
        }

        stats = await stats.save();
        res.json(stats);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});


module.exports = statsRouter;