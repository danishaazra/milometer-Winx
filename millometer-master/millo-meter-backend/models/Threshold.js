const mongoose = require("mongoose");

const thresholdSchema = new mongoose.Schema({
  factoryId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Factory",
    required: true,
  },
  thresholdType: { type: String, required: true }, // e.g., temperature, humidity
  minValue: { type: Number, required: true },
  maxValue: { type: Number, required: true },
});

const Threshold = mongoose.model("Threshold", thresholdSchema);

module.exports = Threshold;
