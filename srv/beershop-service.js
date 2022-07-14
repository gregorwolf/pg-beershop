const cds = require("@sap/cds");

module.exports = async function (srv) {
  srv.on("READ", "UserScopes", async (req) => {
    const users = [
      {
        username: req.user.id,
        is_admin: req.user.is("admin"),
      },
    ];
    return users;
  });
  srv.before("DELETE", "Breweries", async (req) => {
    if (req.data.ID === "4aeebbed-90c2-4bdd-aa70-d8eecb8eaebb") {
      return req.reject(400, "Not okay");
    }
  });
};
