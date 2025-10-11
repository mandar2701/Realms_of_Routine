const express = require('express');
const mongoose = require('mongoose');
const AccountStats = require('../models/accountStats');
const auth = require('../middleware/auth');
const statsRouter = express.Router();

// Route to fetch a user's stats
statsRouter.get('/api/stats', auth, async (req, res) => {
    try {
        // Ensure ID is converted to a proper MongoDB ObjectId for lookup/creation
        const userId = new mongoose.Types.ObjectId(req.user.id);
        // Use req.user.id provided by your auth middleware
        const stats = await AccountStats.findOne({ userId: userId });

        if (!stats) {
             // If stats don't exist, create a default one (only happens on first login after adding this feature)
             const newStats = new AccountStats({ userId: userId });
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

        const userId = new mongoose.Types.ObjectId(req.user.id);

        let stats = await AccountStats.findOne({ userId: userId });

        if (!stats) {
            return res.status(404).json({ error: "Stats not found. User must login first." });
        }

        // --- XP and Level Up Logic ---
        stats.xp += xpChange;
        stats.tasksCompleted += 1;

        // Use a while loop to handle multiple level ups in a single transaction
        let levelsGained = 0;
        let xpNeededForNextLevel = stats.level * 100;

        while (stats.xp >= xpNeededForNextLevel) {
            stats.xp -= xpNeededForNextLevel;
            stats.level += 1;
            levelsGained++;
            // Update the XP threshold for the *new* level
            xpNeededForNextLevel = stats.level * 100;
        }

        if (levelsGained > 0) {
            // Grant 5 stat points for every level gained
            stats.statPoints += levelsGained * 5;
            console.log(`User ${userId} leveled up to ${stats.level}! Gained ${levelsGained * 5} stat points.`);
        }

        stats = await stats.save();
        res.json(stats);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Route to spend available stat points
statsRouter.post('/api/stats/spend-points', auth, async (req, res) => {
    try {
        const { statName, pointsSpent } = req.body;

        // Basic validation
        const validStats = ['strength', 'agility', 'vigor', 'stamina', 'defense'];
        if (!validStats.includes(statName)) {
            return res.status(400).json({ error: "Invalid stat name." });
        }

        if (typeof pointsSpent !== 'number' || pointsSpent <= 0 || pointsSpent % 1 !== 0) {
            return res.status(400).json({ error: "Points spent must be a positive integer." });
        }

        const userId = new mongoose.Types.ObjectId(req.user.id);
        let stats = await AccountStats.findOne({ userId: userId });

        if (!stats) {
            return res.status(404).json({ error: "Stats not found. User must login first." });
        }

        if (stats.statPoints < pointsSpent) {
            return res.status(400).json({ error: "Insufficient stat points." });
        }

        // Update stat and spend points
        stats.stats[statName] += pointsSpent;
        stats.statPoints -= pointsSpent;

        stats = await stats.save();
        res.json(stats);

    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = statsRouter;