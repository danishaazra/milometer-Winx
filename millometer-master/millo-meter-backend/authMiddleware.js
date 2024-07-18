// authMiddleware.js

const jwt = require("jsonwebtoken");
const User = require("./models/Users"); // Adjust path as per your project structure

const authMiddleware = async (req, res, next) => {
  const authHeader = req.headers.authorization;
  if (authHeader) {
    const token = authHeader.split(" ")[1];
    try {
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const user = await User.findById(decoded.userId); // Adjust based on your User model
      if (!user) {
        throw new Error("User not found");
      }
      req.user = user; // Attach user object to request
      next();
    } catch (err) {
      return res
        .status(403)
        .json({ message: "Token expired or invalid", error: err.message });
    }
  } else {
    res.status(401).json({ message: "Unauthorized" });
  }
};

module.exports = authMiddleware;
