const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const authRouter = require("./routes/auth");
const taskRouter = require("./routes/tasks");
const statsRouter = require("./routes/stats");

const app = express();
const PORT = process.env.PORT || 3000;

app.get('/', (req, res) => {
    // This immediately responds with a successful status, stabilizing the container.
    res.status(200).send('API is running.');
});

app.use(cors());
app.use(express.json());

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