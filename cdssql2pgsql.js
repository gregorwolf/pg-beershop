const fs = require('fs')

const cdssql = fs.readFileSync('beershop-cds.sql').toString('utf-8')
var pgsql = cdssql.replace(/NVARCHAR/g, 'VARCHAR')
pgsql += "\nCOPY csw_Beers(ID, name, abv, ibu) " 
+ "FROM '/tmp/data/csw-Beers.csv' "
+ "DELIMITER ',' CSV HEADER;"
pgsql += "\nCOPY csw_Brewery(ID, name) " 
+ "FROM '/tmp/data/csw-Brewery.csv' "
+ "DELIMITER ',' CSV HEADER;"
console.log(pgsql)