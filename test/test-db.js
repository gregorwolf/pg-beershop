var cdsrc = require("../.cdsrc.json");

const { Client } = require('pg')
const client = new Client(cdsrc.cds.requires.postgres.credentials)
;(async () => {
  await client.connect()
  const res = await client.query("SELECT * FROM csw_Beers;")
  console.log(res.rows[0].name)
  await client.end()
})()

