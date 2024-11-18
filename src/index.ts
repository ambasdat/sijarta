import express, { urlencoded }  from "express";
import path from "path";
import { engine } from "express-handlebars";

import auth from "./auth";
import mypay from "./mypay";
import home from "./home";
import pekerjaan from "./pekerjaan";
import testimoni from "./testimoni";
import diskon from "./diskon";
import profile from "./profile";
import pemesanan from "./pemesanan";
import subkategori from "./subkategori";

const app = express();

app.engine(".hbs", engine({ extname: ".hbs" }));
app.set("view engine", ".hbs");
app.set("views", path.resolve(process.cwd(), "templates"));
app.use(urlencoded({ extended: true }));

app.use((_, res, next) => {
  res.locals.layout = "pengguna";
  next();
});

app.use("/auth", auth);
app.use("/mypay", mypay);
app.use("/pekerjaan", pekerjaan);
app.use("/home", home);
app.use("/testimoni", testimoni);
app.use("/diskon", diskon);
app.use("/profile", profile);
app.use("/pemesanan", pemesanan);
app.use("/subkategori", subkategori);

app.get("/", (_req, res) => {
  const isLoggedIn = false; // ubah dengan logic
  res.redirect(isLoggedIn ? "/home" : "/auth")
});

app.listen(3000, () => console.log("http://localhost:3000"));
