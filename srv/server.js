const cds = require("@sap/cds");
const cov2ap = require("@cap-js-community/odata-v2-adapter");

/*
if(process.env.APPINSIGHTS_INSTRUMENTATIONKEY) {
  let appInsights = require('applicationinsights')
  appInsights.setup(process.env.APPINSIGHTS_INSTRUMENTATIONKEY).start()
}
*/

cds.on("bootstrap", (app) => app.use(cov2ap()));

if (process.env.NODE_ENV !== "production") {
  const { cds_launchpad_plugin } = require("cds-launchpad-plugin");

  // Enable launchpad plugin
  cds.once("bootstrap", (app) => {
    const handler = new cds_launchpad_plugin();
    // Current 1.105.0 Version doesn't disply Fiori Elements
    app.use(handler.setup({ version: "1.104.2" }));
    // app.use(handler.setup());
  });
}

module.exports = cds.server;
