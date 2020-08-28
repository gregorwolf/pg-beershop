const { expect } = require('./capire')
const cds = require('@sap/cds')

/*
const cwd = process.cwd()
console.log("cwd = " + cwd)

before(() => {
    console.log("chdir to " + __dirname)
    process.chdir(__dirname)
})

after(() => {
    console.log("chdir to " + cwd)
    process.chdir(cwd)
})
*/

describe('Consuming Services locally', () => {
    before('bootstrap db and services', async () => {
        /*
        const srv = await cds.connect.to ('db')
        const { BeershopService } = await cds.serve('BeershopService')
        const { Beers, Breweries } = BeershopService.entities
        expect(BeershopService).not.to.be.undefined
        expect(Beers).not.to.be.undefined
        expect(Breweries).not.to.be.undefined
        */
    })

    it('bootrapped the database successfully', ()=>{})
})