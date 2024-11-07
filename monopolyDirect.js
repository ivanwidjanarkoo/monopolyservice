/* eslint-disable no-console */
/**
 * This module implements direct, Android-to-Postgres access to the Monopoly DB.
 * The database is hosted on Azure PostgreSQL. I needed to add my local public
 * IP address to the Azure networking firewall access list.
 *
 * Because the PGP connection variables are stored as Heroku config vars, store
 * those values in .env (stored locally and listed in .gitignore so that they're
 * not pushed to GitHub, e.g., one line would be DB_PORT=5432).
 *
 *      source .env-azure
 *      node monopolyDirect.js
 *
 * @author: kvlinden
 * @date: Summer, 2020
 * @date: Fall, 2024 - updates for Azure PostgreSQL
 */


const pgp = require('pg-promise')();
require('dotenv').config();


const db = pgp({
  host: process.env.DB_SERVER,
  port: process.env.DB_PORT,
  database: process.env.DB_DATABASE,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  ssl: { rejectUnauthorized: false }  // Allow SSL without certificate verification
});


console.log("Connecting to database:", process.env.DB_DATABASE); // Log to confirm the database name

// Send the SQL command directly to Postgres.
db.many('SELECT * FROM Player')
  .then((data) => {
    console.log(data);
  })
  .catch((error) => {
    console.log('ERROR:', error);
  });