const cds = require ('@sap/cds')
const { Client } = require('pg')

let _debug_count = 100

function _run(query, dbc) {
  const q = cqn2pgsql(query)

  if (Array.isArray(q)) {
    return Promise.all(q.map(query => _run(query, dbc)))
  }

  console.debug(_debug_count++, q)

  return (dbc._connected ? Promise.resolve() : dbc.connect())
    .then(() => dbc.query(q))
    .then( res => res.rows)
}

module.exports = class PostgresDatabase extends cds.service {

  init() {
    const dbc = new Client(this.options.credentials)
    const queued = []

    this.on('BEGIN', async req => {
      if (this.busy) {
        // queue the begin
        await new Promise(resolve => queued.push(resolve))
      } else {
        this.busy = true
      }
      return _run(req.event, dbc)
    })

    this.on(['COMMIT','ROLLBACK'], async req => {
      await _run(req.event, dbc)
      if (queued.length) {
        queued.shift()()
      } else {
        this.busy = false
      }
    })

    // CRUD
    this.on('INSERT', req => _run(req.query, dbc))
    this.on('SELECT', req => _run(req.query, dbc))
    this.on('UPDATE', req => _run(req.query, dbc))
    this.on('DELETE', req => _run(req.query, dbc))

    // Not supported
    this.on('*', req => { throw new Error(`Event "${req.event}" is not supported`)})
  }

  acquire() { return this }
  release() { return this }

  begin() { return this.emit('BEGIN') }
  commit() { return this.emit('COMMIT') }
  rollback() { return this.emit('ROLLBACK') }
}