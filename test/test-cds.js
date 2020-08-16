const cds = require('@sap/cds')
;const { resolve } = require('@sap/cds');
(async () => {
    const srv = await cds.connect.to ('db')
    const { BeershopService } = await cds.serve('BeershopService')
    const { Beers, Breweries } = BeershopService.entities
    const query = SELECT.from(Beers, ['ID','name'])
    // .where({abv:{'>': 5}})
    .limit(1, 1)
    const result = await srv.run (query)
    console.log(result)
    resolve("dummy")
})()