import express, { json, urlencoded }  from "express";
import cookieParser from "cookie-parser";
import morgan from "morgan";
import path from "path";
import { engine } from "express-handlebars";
import client from "./db";

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

const hbsHelpers = {
  range: function (start: number, end: number) {
    const rangeArray = [];
    for (let i = start; i < end; i++) {
      rangeArray.push(i);
    }
    return rangeArray;
  },
  gt: (a: number, b: number) => a > b, 
  eq: (a: any, b: any) => a === b,
};

app.engine(".hbs", engine({ extname: ".hbs", helpers: hbsHelpers,}));
app.set("view engine", ".hbs");
app.set("views", path.resolve(process.cwd(), "templates"));

app.use(morgan("tiny"));
app.use(json());
app.use(urlencoded({ extended: true }));
app.use(cookieParser());

app.use(async (req, res, next) => {
  const userId = req.cookies.userid;
  console.log

  const query = await client.query('SELECT get_user_type($1::UUID) as user_type', [userId]);
  res.locals.layout = query.rows[0].user_type;
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

(async () => {
  await client.connect();
  app.listen(3000, () => console.log("http://localhost:3000"));
})()
