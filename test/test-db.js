const defaultEnv = require("../default-env.json")

const { Client } = require('pg')
const client = new Client(defaultEnv.VCAP_SERVICES.postgres[0].credentials)
;(async () => {
  await client.connect()
  const res = await client.query('SELECT ID AS "ID", name AS "name" FROM BeershopService_Beers AS "Beers";')
  console.log(res.rows[0])
  await client.end()
})()

