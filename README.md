# CAP Beershop using PostgreSQL for persistence

## Prerequisites

For the quickest start docker and docker-compose are needed.

## Setup

To run the example with a local PostgreSQL DB in docker create a `default-env.json` file with the following content:

```JSON
{
  "VCAP_SERVICES": {
    "postgres": [
      {
        "name": "postgres",
        "label": "postgres",
        "tags": [
          "postgres"
        ],
        "credentials": {
          "host": "localhost",
          "port": "5432",
          "database": "beershop",
          "user": "postgres",
          "password": "postgres"
        }
      }
    ]
  }
}
```

Start the PostgreSQL database and [Adminer](https://www.adminer.org/) using:

`npm run start:docker`

Then open [http://localhost:8080/](http://localhost:8080/) and login by selecting System *PostgreSQL*, Username *postgres* and Password *postgres*. Create a new database *beershop* using the *Create database* link. Then execute the SQL commands you find in *beershop.sql*.

Now you can start the CAP application by using:

`cds run`

Then open <http://localhost:4004/beershop/Beers> in the browser and you should see:

```JSON
{
  "@odata.context": "$metadata#Beers",
  "value": [
    {
      "ID": "b8c3fc14-22e2-4f42-837a-e6134775a186",
      "name": "Lagerbier Hell",
      "abv": 5.2,
      "ibu": 12,
      "brewery_ID": "9c937100-d459-491f-a72d-81b2929af10f"
    },
    {
      "ID": "9e1704e3-6fd0-4a5d-bfb1-13ac47f7976b",
      "name": "Schönramer Hell",
      "abv": 5,
      "ibu": 20,
      "brewery_ID": "fa6b959e-3a01-40ef-872e-6030ee4de4e5"
    }
  ]
}
```

## Features

### Convert SQL generated from cds compile to PostgreSQL

When you run:

`npm run compile:tosql`

the CDS model will be compiled to the *beershop-cds.sql* file. Using the script *cdssql2pgsql.js* this SQL is converted to support PostgreSQL. Currently only the datatype NVARCHAR must be replaced with VARCHAR.

### Import CDS files from db/data into the beershop database

The path db/data is mounted to the docker container at /tmp/data. That allows to run the COPY commands generated at the end of *beershop.sql*.

## Limitations

### jest tests not working yet

Running the jest test with `npm test` currently fails with:

```bash
    Failed: Object {
      "code": -20005,
      "message": "Failed to load DBCAPI.",
      "sqlState": "HY000",
      "stack": "Error: Failed to load DBCAPI.
```

when running the standalone script `node test/test-db.js` that uses the same way to connect everything is OK.

## Ideas

### Schema Migrations

- <https://flywaydb.org/>
- <https://www.liquibase.org/>
