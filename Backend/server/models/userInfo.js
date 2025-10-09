const mongoose = require('mongoose');

const userInfoSchema = new mongoose.Schema({
    username: { type: String, required: true, unique: true },
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