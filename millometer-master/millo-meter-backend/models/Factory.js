const mongoose = require("mongoose");

const factorySchema = new mongoose.Schema({
  name: { type: String, required: true },
  location: { type: String, required: true },
  ownerPhoneNumber: { type: String, required: true }, // Reference to user phone number who owns the factory
  isActive: { type: Boolean, default: true }, // Indicates if the factory is active
  thresholds: {
    // Default thresholds if not set
    defaultMin: { type: Number, default: 0 },
    defaultMax: { type: Number, default: 100 },
  },
  engineers: [{ name: String, specialization: String, phoneNumber: String }],
});

const engineerSchema = new mongoose.Schema({
  name: { type: String, required: true },
  specialization: { type: String, required: true },
  phoneNumber: { type: String, required: true },
});

const Factory = mongoose.model("Factory", factorySchema);
const Engineer = mongoose.model("Engineer", engineerSchema);

module.exports = { Factory, Engineer };
