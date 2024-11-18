import express from "express";

const app = express.Router();

app.get("/", (req, res) => {
  res.render("pemesanan/main");
});

export default app;
