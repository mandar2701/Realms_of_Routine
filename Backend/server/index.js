const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const authRouter = require("./routes/auth");
const taskRouter = require("./routes/tasks");
const statsRouter = require("./routes/stats");

const app = express();
const PORT = process.env.PORT || 3000;

// --- START: CORS Configuration (CORRECTED) ---
const corsOptions = {
    // Specify the exact origin of your Flutter web app
    origin: '*',
    // Allow the necessary methods (including POST, and OPTIONS for preflight)
    methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
    credentials: true,
    // This ensures the crucial OPTIONS preflight request is handled correctly
    optionsSuccessStatus: 204
};

// 🌟 THE FIX: Pass the configuration object to the middleware 🌟
app.use(cors(corsOptions));
// --- END: CORS Configuration (CORRECTED) ---

app.use(express.json());

app.get('/', (req, res) => {
    // This immediately responds with a successful status, stabilizing the container.
    res.status(200).send('API is running.');
});

app.use(authRouter);
app.use(taskRouter);
app.use(statsRouter);


const DB = process.env.MONGODB_URI || "mongodb+srv://realms_of_routine:ror@cluster0.lrgs6q1.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Server connected at port ${PORT}`);
});