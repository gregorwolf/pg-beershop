const cds = require ('@sap/cds')
const { Pool } = require('pg')
const HanaDatabase = require('../node_modules/@sap/cds-runtime/lib/hana/Service')



function cqn2pgsql(query) {
/*

{ SELECT: {
  from: {ref:['BeershopService.Beers']},
  columns: [ {ref:['ID']}, {ref:['name']} ],
  orderBy: [ {ref:[ 'ID' ], sort: 'asc' } ],
  limit: { rows: {val:1000} }
}}

'SELECT "ID", "name" FROM "BeershopService_Beers" AS "Beers";'
*/
  let sql = ""
  switch (query.cmd) {
    case 'SELECT':
      const cqn = query.SELECT
      sql = `${query.cmd} ${cqn.columns.map(col => `"${col.ref[0]}"`).join(', ')} FROM "${cqn.from.ref[0].replace(".", "_")}"`
      break;
  
    default:
      break;
  }
  return sql
}

module.exports = class PostgresDatabase extends HanaDatabase {
    constructor(...args) {
      super(...args)
      // maybe do more stuff
      this._pool = new Pool(this.options.credentials)
    }

    async init() {
      super.init()

      await this.prepend(function() {
        this.on('BEGIN', async req => {
          // this === tx || srv

          const dbc = this.dbc = await this.acquire(req)
          req.context._dbc = dbc // REVISIT: will become obsolete
          
          const that = this
          return new Promise((resolve, reject) => {
            dbc.query(req.event, (err) => {
              // REVISIT: compat for continue with tx
              that.tx(req)._state = req.event

              if (err) return reject(err)
              resolve('dummy')
            })
          })
        })
        this.on(['COMMIT', 'ROLLBACK'], req => {
          const dbc = this.dbc || req.context._dbc

          const that = this
          return new Promise((resolve, reject) => {
            dbc.query(req.event, (err) => {
              // REVISIT: compat for continue with tx
              that.tx(req)._state = req.event

              if (err) return reject(err)
              resolve('dummy')
            })
          })
        })
        this.on('READ', req => {
          console.log(req.query)
          const dbc = req.context._dbc
          return dbc.query(cqn2pgsql(req.query))
            .then(res => res.rows)
        })
      })

    }

    acquire(arg) {
      // Does PostgreSQL support multi tenancy?
      const tenant = arg && typeof arg === 'string' ? arg : arg.user.tenant || 'anonymous'
      // do acquire
      return this._pool.connect()
        // .then(client => {
        //   return client
        // })
        // .catch(err => {throw new PgError()}) // TODO: err handling -> pg-specific message?
    }

    release(dbc) {
      // do release
      return dbc.release()
    }
}