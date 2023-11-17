const pg = require("pg");
require("dotenv").config();

const config = JSON.parse(process.env.azure);
const client = new pg.Client(config);

client.connect((err) => {
  if (err) throw err;
  else {
    queryDatabase();
  }
});

function queryDatabase() {
  const query = `
        DROP TABLE IF EXISTS inventory;
        CREATE TABLE inventory (id serial PRIMARY KEY, name VARCHAR(50), quantity INTEGER);
        INSERT INTO inventory (name, quantity) VALUES ('banana', 150);
        INSERT INTO inventory (name, quantity) VALUES ('orange', 154);
        INSERT INTO inventory (name, quantity) VALUES ('apple', 100);
        DROP TABLE IF EXISTS inventory;
    `;

  client
    .query(query)
    .then(() => {
      console.log("Table created successfully!");
      client.end(console.log("Closed client connection"));
    })
    .catch((err) => console.log(err))
    .then(() => {
      console.log("Finished execution, exiting now");
      process.exit();
    });
}
