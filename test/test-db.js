var cdsrc = require("../.cdsrc.json");

const { Client } = require('pg')
const client = new Client(cdsrc.requires.postgres.credentials)
;(async () => {
  await client.connect()
  const res = await client.query('SELECT "ID", "name" FROM "BeershopService_Beers" AS "Beers";')
  console.log(res.rows[0])
  await client.end()
})()

