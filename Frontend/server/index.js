const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const authRouter = require("./routes/auth");
const taskRouter = require("./routes/tasks");

const app = express();
const PORT = 3000;

app.use(cors());

app.use(express.json());
app.use(authRouter);
app.use(taskRouter); // add this after your authRouter


const DB =
  "mongodb+srv://realms_of_routine:ror@cluster0.lrgs6q1.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0";

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