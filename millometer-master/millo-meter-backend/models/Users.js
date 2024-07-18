// millo-meter-backend/models/User.js
const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name: { type: String, required: false },
  phone: { type: String, required: true, unique: true },
  otp: { type: String }, // Field to store OTP
  isActive: { type: Boolean, default: false },
  token: { type: String },
  // Add more fields as needed
});

const User = mongoose.model("User", userSchema);

module.exports = User;
