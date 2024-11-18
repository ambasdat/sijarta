import express from "express";
import path from "path";
import { engine } from "express-handlebars";

import auth from "./auth";
import mypay from "./mypay";
import home from "./home";
import order from "./order";
import testimoni from "./testimoni";
import diskon from "./diskon";
import profile from "./profile";

const app = express();

app.engine(".hbs", engine({ extname: ".hbs" }));
app.set("view engine", ".hbs");
app.set("views", path.resolve(process.cwd(), "templates"));

app.use((_, res, next) => {
  res.locals.layout = "pekerja";
  next();
});

app.use("/auth", auth);
app.use("/mypay", mypay);
app.use("/order", order);
app.use("/home", home);
app.use("/testimoni", testimoni);
app.use("/diskon", diskon);
app.use("/profile", profile);

app.get("/", (_req, res) => res.render("main", { name: "World" }));

app.listen(3000, () => console.log("http://localhost:3000"));
