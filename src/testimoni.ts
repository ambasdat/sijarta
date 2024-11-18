import express from "express";

const app = express.Router();

app.get("/", (req, res) => {
  res.render("testimoni/main");
});

export default app;
