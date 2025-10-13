const express = require('express');
const mongoose = require('mongoose');
const AccountStats = require('../models/accountStats');
const auth = require('../middleware/auth');
const statsRouter = express.Router();

// Route to fetch a user's stats
statsRouter.get('/api/stats', auth, async (req, res) => {
    try {
        const userId = new mongoose.Types.ObjectId(req.user.id);
        let stats = await AccountStats.findOne({ userId: userId }); // Find first

        // If no document exists, create one with defaults
        if (!stats) {
            const defaultStats = {
                userId: userId,
                level: 1,
                xp: 0,
                statPoints: 0,
                tasksCompleted: 0,
                questsFailed: 0,
                stats: {
                    strength: 1, agility: 1, vigor: 1,
                    stamina: 1, defense: 1
                }
            };
            stats = await AccountStats.create(defaultStats);
        }

        // Return the found or newly created stats
        res.json(stats); // Return the actual stats document
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

// Route to manually update stats (e.g., when a task is completed)
statsRouter.post('/api/stats/update-xp', auth, async (req, res) => {
    try {
        const { xpChange } = req.body;
        const userId = new mongoose.Types.ObjectId(req.user.id);

        // 1. Find the existing document
        let stats = await AccountStats.findOne({ userId: userId });

        if (!stats) {
            // This case should be rare if the GET route works correctly
            return res.status(404).json({ error: "Stats not found. User must login first." });
        }

        // --- Simple XP and Level Up Logic in memory ---
        stats.xp += xpChange;
        stats.tasksCompleted += 1;

        let levelsGained = 0;
        let xpNeededForNextLevel = stats.level * 100;

        while (stats.xp >= xpNeededForNextLevel) {
            stats.xp -= xpNeededForNextLevel;
            stats.level += 1;
            levelsGained++;
            xpNeededForNextLevel = stats.level * 100;
        }

        if (levelsGained > 0) {
            stats.statPoints += levelsGained * 2;
        }

        // 2. Save the modified document back to the database
        stats = await stats.save();

        // 3. Return the saved document
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