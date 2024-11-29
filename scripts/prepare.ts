import { readdirSync, readFileSync } from "fs";
import { join } from "path";
import { Client } from "pg";
import { createInterface } from "readline/promises"

(async () => {
  const rl = createInterface(process.stdin, process.stdout)

  console.log("[i] DB User:", process.env.DB_USER);
  console.log("[i] DB Host:", process.env.DB_HOST);
  console.log("[i] DB Port:", process.env.DB_PORT);
  console.log("[i] DB Name:", process.env.DB_DATABASE);

  console.log();

  const answer = await rl.question("[!] WARNING: This will delete all data on the database. Continue [y/N]? ");

  if (!/[yY]/g.test(answer)) {
    process.exit();
  }

  console.log();

  const client = new Client({
    user: process.env.DB_USER!,
    password: process.env.DB_PASSWORD!,
    host: process.env.DB_HOST!,
    port: parseInt(process.env.DB_PORT!),
    database: process.env.DB_DATABASE!,
  });

  console.log("[i] Connecting to Database");

  await client.connect();

  console.log("[i] Executing DDL Schema");

  const ddl = readFileSync(join(__dirname, "..", "sql", "00-table.sql")).toString();
  await client.query(ddl);

  console.log("[i] Inserting Dummy Data");

  const dummy = readFileSync(join(__dirname, "..", "sql", "01-dummy.sql")).toString();
  await client.query(dummy);

  console.log("[i] Creating Triggers")

  const triggers = readFileSync(join(__dirname, "..", "sql", "02-triggers.sql")).toString();
  await client.query(triggers);

  console.log("[i] Running SQL Files");

  const srcDir = readdirSync(join(__dirname, "..", "src"));
  const sqlFiles = srcDir.filter((file) => file.match(/.*\.sql/ig));
  for (const sqlFile of sqlFiles) {
    const sql = readFileSync(join(__dirname, "..", "src", sqlFile)).toString();
    await client.query(sql);
  }

  console.log("[i] Success");

  process.exit();
})();
