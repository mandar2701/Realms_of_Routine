const mongoose = require('mongoose');

const accountStatsSchema = new mongoose.Schema({
    // A unique reference to the main User account.
    // This is the most crucial part to link the stats to an existing user.
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User', // Assuming your main user/auth model is named 'User'
        required: true,
        unique: true // Ensures each user only has one stats document
    },
    level: {
        type: Number,
        required: true,
        default: 1
    },
    xp: {
        type: Number,
        required: true,
        default: 0
    },
    // Nested object for RPG-style attributes
    stats: {
        strength: { // Matches 'Strength' in Flutter
            type: Number,
            required: true,
            default: 5
        },
        agility: { // Matches 'Agility' in Flutter
            type: Number,
            required: true,
            default: 5
        },
        vigor: { // Matches 'Vigor' in Flutter
            type: Number,
            required: true,
            default: 5
        },
        stamina: { // Matches 'Stamina' in Flutter
            type: Number,
            required: true,
            default: 5
        },
        defense: { // Matches 'Defense' in Flutter
            type: Number,
            required: true,
            default: 5
        }
    },
    // Other tracking fields for the profile page
    tasksCompleted: {
        type: Number,
        default: 0
    },
    questsFailed: {
        type: Number,
        default: 0
    }
});

const AccountStats = mongoose.model('AccountStats', accountStatsSchema);
module.exports = AccountStats;