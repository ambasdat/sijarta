import { Client, types } from 'pg';

types.setTypeParser(1082, (val) => val);

const client = new Client({
  user: process.env.DB_USER!,
  password: process.env.DB_PASSWORD!,
  host: process.env.DB_HOST!,
  port: parseInt(process.env.DB_PORT!),
  database: process.env.DB_DATABASE!,
});

export default client;
