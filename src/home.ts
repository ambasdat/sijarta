import express from "express";

import client from "./db";

const app = express.Router();

const dataForHome = {
  category: [
    {
      name: "Home Cleaning",
      subcategory: ["Daily Cleaning", "Pembersihan Dapur dan Kulkas"],
    },
    {
      name: "Deep Cleaning",
      subcategory: ["Cuci Kasur", "Bersih Kamar Mandi"],
    },
    {
      name: "Plumbing Services",
      subcategory: ["Perbaikan pipa bocor", "Pembersihan Saluran Air"],
    },
    {
      name: "Electrical Repairs",
      subcategory: ["Instalasi Lampu", "Perbaikan Saklar dan Stop Kontak"],
    },
    {
      name: "Pest Control",
      subcategory: ["Pengendalian Tikus", "Pembasmian Kutu"],
    },
  ],
};

function titleCase(str: string): string {
  return str.split(' ').map(word => word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()).join(' ');
}

function parseQueryForHome(query: Array<any>) {
  const result = [];
  const map : {[index: string]: number} = {};
  for (const row of query) {
    if (!map.hasOwnProperty(row.Kat)) {
      map[row.Kat] = result.length;
      const temp : string[] = [];
      result.push({Kat: row.Kat, Sub: temp,});
    }
    result[map[row.Kat]].Sub.push(titleCase(row.Sub));
  }

  return result;
}

client.query('SELECT * FROM getAllForHome();', (err, res) => {
    if (err) {
      console.error(err);
    }
    else {
        console.log(res.rows);
        console.log(parseQueryForHome(res.rows));
    }
});

app.get("/", async (req, res) => {
  try {
    const s = req.query.s as string || "";
    const k = req.query.k as string || "";
    const userid = req.cookies === undefined ? "" : req.cookies.userid as string || "";
    const result = await client.query(`SELECT * FROM getAllForHome('${s}', '${k}');`);
    const data = parseQueryForHome(result.rows);
    if (userid === "") {
      res.render("home/home.hbs", {data: data, guest: true, pelanggan: false, pekerja: false} );
    }
    else {
      const isCustomer = (await client.query(`SELECT * FROM isPelanggan('${userid}');`)).rows[0].ispelanggan;
      const isWorker = (await client.query(`SELECT * FROM isPekerja('${userid}');`)).rows[0].ispekerja;
      const isGuest = !(isCustomer || isWorker);
      res.render("home/home.hbs", {data: data, guest: isGuest, pelanggan: isCustomer, pekerja: isWorker} );
    }
  } 
  catch (error) {
    console.error(error);
    res.status(500).send("An error occurred while fetching data.");
  }
});

app.get("/s=:string1&k=:string2", (req, res) => {
  console.log(req.params);
  res.render("home/home.hbs", {
    data: JSON.stringify(dataForHome),
    han: dataForHome,
  });
});

export default app;
