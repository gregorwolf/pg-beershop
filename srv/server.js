const proxy = require('@sap/cds-odata-v2-adapter-proxy')
const cds = require('@sap/cds')
let appInsights = require('applicationinsights')
appInsights.setup(process.env.APPINSIGHTS_INSTRUMENTATIONKEY).start()
cds.on('bootstrap', app => app.use(proxy()))
module.exports = cds.server