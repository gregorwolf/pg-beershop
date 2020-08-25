const fs = require('fs')
const postgresDatabase = require('cds-pg')

const cdspg = new postgresDatabase()

const cdssql = fs.readFileSync('beershop-cds.sql').toString('utf-8')
let pgsql = cdspg.cdssql2pgsql(cdssql)
pgsql += "\nCOPY csw_Beers(ID, name, abv, ibu, brewery_ID) " 
+ "FROM '/tmp/data/csw-Beers.csv' "
+ "DELIMITER ',' CSV HEADER;"
pgsql += "\nCOPY csw_Brewery(ID, name) " 
+ "FROM '/tmp/data/csw-Brewery.csv' "
+ "DELIMITER ',' CSV HEADER;"
console.log(pgsql)