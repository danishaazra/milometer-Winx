const mongoose = require('mongoose');

const sensorSchema = new mongoose.Schema({
  factoryId: { type: mongoose.Schema.Types.ObjectId, ref: 'Factory', required: true },
  paramType: { type: String, required: true },
  minValue: { type: Number, required: true },
  maxValue: { type: Number, required: true },
  currentValue: { type: Number, required: true },
  timestamp: { type: Date, default: Date.now },
});

const Sensor = mongoose.model('Sensor', sensorSchema);

module.exports = Sensor;
