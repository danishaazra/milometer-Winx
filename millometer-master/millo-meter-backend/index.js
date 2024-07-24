// millo-meter-backend/server.js
require("dotenv").config();

const express = require("express");
const mongoose = require("mongoose");
const userRoutes = require("./routes/userRoutes");
const User = require("./models/Users");
const authMiddleware = require("./authMiddleware");
const Notification = require("./models/Notifications");
const Sensor = require("./models/Sensor");
const { Factory } = require("./models/Factory");
const Threshold = require("./models/Threshold");
const twilio = require("twilio");
const jwt = require("jsonwebtoken");

const app = express();
const PORT = process.env.PORT || 5000;
const MONGODB_URI = process.env.MONGODB_URI;

// Connect to MongoDB
mongoose
  .connect(MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log("MongoDB connected");
  })
  .catch((err) => {
    console.error("MongoDB connection error", err);
  });

const client = twilio(
  process.env.TWILIO_ACCOUNT_SID,
  process.env.TWILIO_AUTH_TOKEN
);

console.log("Twilio Account SID:", process.env.TWILIO_ACCOUNT_SID);
console.log("Twilio Auth Token:", process.env.TWILIO_AUTH_TOKEN);

// Middleware
app.use(express.json());

// Example of using authMiddleware for protected routes
app.get("/api/sensors", authMiddleware, async (req, res) => {
  try {
    // Fetch sensor data logic here
    const sensorData = await Sensor.find(); // Assuming Sensor is your Mongoose model
    res.status(200).json({ message: "Protected route, token valid" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Routes
app.use("/users", userRoutes);

// Register new user
app.post("/api/register", async (req, res) => {
  const { name, phone } = req.body;

  try {
    const newUser = new User({ name, phone });
    await newUser.save();
    res.status(201).json(newUser);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

const otpGenerator = require("otp-generator");

app.post("/api/otp", async (req, res) => {
  const { phone } = req.body;

  try {
    // Save the OTP in the user's record for later verification
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }

    const otp = otpGenerator.generate(6, {
          digits: true,
          alphabets: false,
          upperCase: false,
          specialChars: false,
        });

    user.otp = otp; // Store the OTP in the user record
    await user.save();

    // // This is the logic to sent notification, for now just remove first, since one otp message is RM1
    // await client.messages.create({
    //   body: Your OTP is: ${otp},
    //   to: phone,
    //   from: process.env.TWILIO_PHONE_NUMBER,
    // });

    res.status(200).json({ otp });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

app.post("/api/activate", async (req, res) => {
  const { phone, otp } = req.body;

  try {
    // Find the user by phone number
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(404).json({ message: "Phone Number not registered" });
    }

    // Verify the OTP
    if (user.otp !== otp) {
      return res.status(400).json({ message: "Invalid OTP" });
    }

    // OTP is valid, activate the user account
    user.isActive = true;
    user.otp = null; // Clear the OTP field

    // Generate JWT token
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: "7d", // Token expires in 7days
    });

    // Store the token in the user record
    user.token = token;

    await user.save();

    res.status(200).json({ message: "User activated successfully", token });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});
// Login user and issue JWT token
app.post("/api/login", async (req, res) => {
  const { phone } = req.body;

  try {
    // Implement logic to verify credentials (phone number and OTP)
    // Example: Find user by phone number and verify OTP
    const user = await User.findOne({ phone });
    if (!user) {
      return res.status(404).json({ message: "Phone Number not registered" });
    }

    // Mock OTP verification (replace with actual logic to verify OTP)
    const isValidOTP = true; // Replace with actual OTP verification logic

    if (!isValidOTP) {
      return res.status(401).json({ message: "Invalid OTP" });
    }

    // Generate JWT token
    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, {
      expiresIn: "1h", // Token expires in 1 hour
    });

    // Return the token to the client
    res.status(200).json({ token });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Example to list all factories of the user
// Example to list all factories of the user
app.get(
  "/api/factories/:ownerPhoneNumber",
  authMiddleware,
  async (req, res) => {
    const { ownerPhoneNumber } = req.params; // Get the filter parameter from path parameters

    if (!ownerPhoneNumber) {
      return res
        .status(400)
        .json({ success: false, message: "Owner phone number is required" });
    }

    try {
      // Fetch factories based on the ownerPhoneNumber
      const factories = await Factory.find({ ownerPhoneNumber }); // Replace Factory with your actual Mongoose model

      res.status(200).json(factories);
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  }
);

// Example to create a new factory
app.post("/api/factories", authMiddleware, async (req, res) => {
  const { name, location, ownerPhoneNumber } = req.body;

  try {
    const newFactory = new Factory({ name, location, ownerPhoneNumber }); // Replace Factory with your actual Mongoose model
    await newFactory.save();
    res.status(201).json(newFactory);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Example to list all notifications
app.get(
  "/api/notifications/:ownerPhoneNumber",
  authMiddleware,
  async (req, res) => {
    try {
      const { ownerPhoneNumber } = req.params;

      if (!ownerPhoneNumber) {
        return res
          .status(400)
          .json({ success: false, message: "Owner phone number is required" });
      }

      const notifications = await Notification.find({
        phoneNumber: ownerPhoneNumber,
      }); // Replace Notification with your actual Mongoose model
      res.status(200).json(notifications);
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  }
);

// Example to send a notification

app.post("/api/notify", authMiddleware, async (req, res) => {
  const { phoneNumber, message } = req.body;

  if (!phoneNumber || !message) {
    return res
      .status(400)
      .json({ message: "Phone number and message are required" });
  }

  try {
    // Send SMS notification using Twilio
    await client.messages.create({
      body: message,
      to: phoneNumber,
      from: process.env.TWILIO_PHONE_NUMBER,
    });

    // Save notification to database
    const newNotification = new Notification({ phoneNumber, message });
    await newNotification.save();

    res.status(200).json({ message: "Notification sent successfully" });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Example to get current threshold values
app.get("/api/thresholds/:factoryId", authMiddleware, async (req, res) => {
  try {
    const { factoryId } = req.params;

    // Fetch current threshold values logic (replace with your actual logic)
    const thresholds = await Threshold.find({ factoryId }).populate(
      "factoryId"
    );
    if (!thresholds.length) {
      return res
        .status(404)
        .json({ message: "No thresholds found for the given factory" });
    }
    res.status(200).json(thresholds);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Example to update threshold values
app.put("/api/thresholds", authMiddleware, async (req, res) => {
  const { factoryId, thresholdType, minValue, maxValue } = req.body;

  try {
    // Find the threshold by factoryId and type, then update its values
    const updatedThreshold = await Threshold.findOneAndUpdate(
      { factoryId: factoryId, thresholdType: thresholdType },
      { minValue: minValue, maxValue: maxValue },
      { new: true, upsert: true } // Create a new document if not found
    );

    res
      .status(200)
      .json({ message: "Threshold updated successfully", updatedThreshold });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Example to create a new threshold entry
app.post("/api/thresholds", authMiddleware, async (req, res) => {
  const { factoryId, thresholdType, minValue, maxValue } = req.body;

  try {
    // Check if the factory exists
    const factoryExists = await Factory.findById(factoryId);
    if (!factoryExists) {
      return res.status(404).json({ message: "Factory not found" });
    }

    // Create a new threshold entry
    const newThreshold = new Threshold({
      factoryId,
      thresholdType,
      minValue,
      maxValue,
    });
    await newThreshold.save();

    res
      .status(201)
      .json({ message: "Threshold created successfully", newThreshold });
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

// Example to add engineers to a factory
app.post("/api/factories/:raspberrypi_id/engineers", async (req, res) => {
  const { raspberrypi_id } = req.params;
  const { name, phoneNum } = req.body;

  try {
    const factory = await Factory.findOne({ raspberrypi_id });
    if (!factory) {
      return res.status(404).json({ message: "Factory not found" });
    }

    // Add engineer to the factory
    factory.engineers.push({ name, phoneNum });
    await factory.save();

    // Add engineer to the Users collection
    const newUser = new User({ name, phone: phoneNum });
    await newUser.save();
    
    res.status(200).json({ message: "Engineer added successfully", factory });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Route to get engineers for a specific factory
app.get("/api/engineers/:raspberrypi_id", async (req, res) => {
  try {
    const { raspberrypi_id } = req.params;

    const factory = await Factory.findOne({ raspberrypi_id }).select("engineers");
    if (!factory) {
      return res.status(404).json({ message: "Factory not found" });
    }

    const engineers = factory.engineers;
    res.status(200).json(engineers);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Example to update threshold values for a factory
app.put(
  "/api/factories/:factoryId/thresholds",
  authMiddleware,
  async (req, res) => {
    const { factoryId } = req.params;
    const { thresholds } = req.body; // Assuming thresholds is an array of threshold objects

    try {
      const factory = await Factory.findById(factoryId);
      if (!factory) {
        return res.status(404).json({ message: "Factory not found" });
      }

      // Update or set thresholds for the factory
      factory.thresholds = thresholds; // Assuming thresholds is an array of threshold objects
      await factory.save();

      res
        .status(200)
        .json({ message: "Thresholds updated successfully", factory });
    } catch (err) {
      res.status(500).json({ message: err.message });
    }
  }
);

// Start the server
app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});