import express, { Request, Response } from "express";
import client from "./db";

const app = express.Router();

app.get(
  "/:IdTrPemesanan",
  async (req: Request<{ IdTrPemesanan: string }>, res: Response): Promise<void> => {
    try {
      const { IdTrPemesanan } = req.params;
      const result = await client.query(
        'SELECT * FROM "TESTIMONI" WHERE "IdTrPemesanan" = $1',
        [IdTrPemesanan]
      );

      const isCreate = result.rows.length === 0;

      res.render("testimoni/main", {
        testimoni: result.rows,
        isCreate,
        IdTrPemesanan,
      });
    } catch (error) {
      console.error("Error fetching testimonies:", error);
      res.status(500).send("An error occurred while fetching testimonies.");
    }
  }
);

app.post(
  "/:IdTrPemesanan",
  async (req: Request<{ IdTrPemesanan: string }>, res: Response): Promise<void> => {
    try {
      const { IdTrPemesanan } = req.params;
      const { rating, teks } = req.body;

      // Validate input
      if (!rating || !teks) {
        res.status(400).send("Rating and komentar are required.");
        return;
      }

      // Insert the testimony into the database
      const currentDate = new Date().toISOString().split("T")[0]; // Get current date in YYYY-MM-DD format
      await client.query(
        'INSERT INTO "TESTIMONI" ("IdTrPemesanan", "Tgl", "Teks", "Rating") VALUES ($1, $2, $3, $4)',
        [IdTrPemesanan, currentDate, teks, parseInt(rating)]
      );

      res.redirect(`/testimoni/${IdTrPemesanan}`); // Redirect back to the testimony page
    } catch (error) {
      console.error("Error creating testimony:", error);
      res.status(500).send("An error occurred while creating the testimony.");
    }
  }
);

export default app;
