const mongoose = require('mongoose');

const userInfoSchema = new mongoose.Schema({
    // CHANGE: Use userId for the unique link to the primary account
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User',
        required: true,
        unique: true // Ensures each user only has one UserInfo document
    },
    // CHANGE: Keep username as a data field, but remove the unique constraint.
    username: { type: String, required: true },
    age: { type: Number, required: true },
    birthDate: { type: Date, required: true },
    gender: { type: String, required: true },
    hero: {
        duty: { type: String, required: true },
        focus: { type: String, required: true },
        goal: { type: String, required: true },
    }
});

const UserInfo = mongoose.model('UserInfo', userInfoSchema);
module.exports = UserInfo;